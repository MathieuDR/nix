# https://github.com/colonelpanic8/rofi-systemd/
{pkgs, ...}:
pkgs.writeShellScriptBin "rofi-systemd" ''
  exec 2>> /tmp/rofi-systemd.log  # Redirect stderr to log file
  exec 1>&2                       # Redirect stdout to stderr (which goes to our log file)
  # Add timestamp to log
  echo "=== $(date) ==="

  need_terminal() {
    if [ ! -t 1 ]; then
      return 0  # true, need terminal
    fi

    #TODO: Make this terminal agnostic, somehow.
    if [ "$TERM" = "xterm-kitty" ]; then
      return 1  # false, already in kitty
    fi

    return 0
  }

  term=''${ROFI_SYSTEMD_TERM-"${pkgs.kitty}/bin/kitty -e"}
  default_action=''${ROFI_SYSTEMD_DEFAULT_ACTION-"list_actions"}
  rofi_command=''${ROFI_SYSTEMD_ROFI_COMMAND-"${pkgs.rofi-wayland}/bin/rofi -dmenu -i -p"}
  truncate_length=''${ROFI_SYSTEMD_TRUNCATE_LENGTH-60}
  files_jquery_columns=''${ROFI_SYSTEMD_FILES_JQ_COLUMNS-'(.[0] + " " + .[1])'}
  running_jquery_columns=''${ROFI_SYSTEMD_RUNNING_JQ_COLUMNS-'(.[0] + " " + .[3])'}
  get_units_strategy=''${ROFI_SYSTEMD_GET_UNITS_STRATEGY-files}

  truncate() {
    ${pkgs.gawk}/bin/awk '{print substr($0, length($0)-'$truncate_length')}'
  }

  call_systemd_dbus() {
    ${pkgs.systemd}/bin/busctl call org.freedesktop.systemd1 /org/freedesktop/systemd1 \
         org.freedesktop.systemd1.Manager "$@" --json=short
  }

  unit_files() {
    call_systemd_dbus ListUnitFiles "$1" | ${pkgs.jq}/bin/jq ".data[][] | $files_jquery_columns" -r | \
      ${pkgs.gawk}/bin/awk -F'/' '{print $NF}'
  }

  running_units() {
    call_systemd_dbus ListUnits "$1" | ${pkgs.jq}/bin/jq ".data[][] | $running_jquery_columns" -r
  }

  get_units() {
    { running_units "--$1";  } | ${pkgs.coreutils}/bin/sort -u -k1,1 | truncate |
      ${pkgs.gawk}/bin/awk -v unit_type="$1" '{print $0 " " unit_type}'
  }

  get_unit_files() {
    { unit_files "--$1";  } | ${pkgs.coreutils}/bin/sort -u -k1,1 | truncate |
      ${pkgs.gawk}/bin/awk -v unit_type="$1" '{print $0 " " unit_type}'
  }

  all_units() {
    case "$get_units_strategy" in
      "files")
        { get_unit_files user; get_unit_files system; } | ${pkgs.util-linux}/bin/column -tc 1
        ;;
      "units")
        { get_units user; get_units system; } | ${pkgs.util-linux}/bin/column -tc 1
        ;;
      *)
        { get_units user; get_units system; } | ${pkgs.util-linux}/bin/column -tc 1
        { get_unit_files user; get_unit_files system; } | ${pkgs.util-linux}/bin/column -tc 1
        ;;
    esac
  }

  enable="Alt+e"
  disable="Alt+d"
  stop="Alt+k"
  restart="Alt+r"
  tail="Alt+t"
  boot_logs="Alt+l"

  all_actions="enable
  disable
  stop
  status
  restart
  tail
  boot_logs"

  select_service_and_act() {
    result=$($rofi_command "systemd unit: " \
                -kb-custom-1 "$enable" \
                -kb-custom-2 "$disable" \
                -kb-custom-3 "$stop" \
                -kb-custom-4 "$restart" \
                -kb-custom-5 "$tail" \
                -kb-custom-6 "$boot_logs")

    rofi_exit="$?"

    case "$rofi_exit" in
      1)
        action="exit"
        exit 1
        ;;
      10)
        action="enable"
        ;;
      11)
        action="disable"
        ;;
      12)
        action="stop"
        ;;
      13)
        action="restart"
        ;;
      14)
        action="tail"
        ;;
      15)
        action="boot_logs"
        ;;
      16)
        action="list_actions"
        ;;
      *)
        action="$default_action"
        ;;
    esac

    selection="$(echo $result | ${pkgs.gnused}/bin/sed -n 's/ \+/ /gp')"
    service_name=$(echo "$selection" | ${pkgs.gawk}/bin/awk '{ print $1 }' | ${pkgs.coreutils}/bin/tr -d ' ')
    is_user="$(echo $selection | ${pkgs.gawk}/bin/awk '{ print $3 }' )"

    case "$is_user" in
      user*)
        user_arg="--user"
        command="${pkgs.systemd}/bin/systemctl $user_arg"
        ;;
      system*)
        user_arg=""
        # command="${pkgs.sudo}/bin/sudo ${pkgs.systemd}/bin/systemctl"
        command="${pkgs.systemd}/bin/systemctl"
        ;;
      *)
        command="${pkgs.systemd}/bin/systemctl"
    esac

    to_run="$(get_command_with_args)"
    echo "Debug: to_run before terminal check: $to_run" >&2
    if need_terminal && [[ "$to_run" = *"journalctl"* || "$to_run" = *"status"* ]]; then
      echo "Debug: Wrapping in terminal" >&2
      to_run="$term $to_run"
    else
      echo "Debug: Not wrapping in terminal" >&2
      to_run="$to_run | ${pkgs.less}/bin/less"
    fi
    echo "Running $to_run"
    eval "$to_run"
  }

  get_command_with_args() {
    case "$action" in
      "tail")
        echo "${pkgs.systemd}/bin/journalctl $user_arg -u '$service_name' -f"
        ;;
      "boot_logs")
        echo "${pkgs.systemd}/bin/journalctl $user_arg -u '$service_name' --boot"
        ;;
      "list_actions")
        action=$(echo "$all_actions" | $rofi_command "Select action: ")
        get_command_with_args
        ;;
      *)
        echo "$command $action '$service_name'"
        ;;
    esac
  }

  all_units | select_service_and_act
''
