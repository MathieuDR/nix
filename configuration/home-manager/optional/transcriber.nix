{
  pkgs,
  config,
  ...
}: let
  promptKeywords = [
    "Elixir"
    "Phoenix"
    "LiveView"
    "Kubernetes"
    "Terraform"
    "NixOS"
    "CQRS"
    "JSON"
    "SQL"
    "event sourcing"
    "entrepreneurship"
  ];

  hotwords = [
    "Danu"
    "Lina"
    "Mathieu"
    "7mind"
    "Shooki"
    "Moochy"
    "Zettelkasten"
  ];

  initialPrompt = "Personal voice memos and fleeting notes from a software engineer. Topics include software engineering with terms like ${builtins.concatStringsSep ", " promptKeywords}, and hobbies like Dungeons and Dragons.";

  memosDir = "${config.home.homeDirectory}/recordings/memos";
  archiveDir = "${memosDir}/archive";
  notesDir = "${config.home.homeDirectory}/notes/obsidian/fleeting";

  transcribeScript = pkgs.writeShellApplication {
    name = "transcribe-memo";
    runtimeInputs = with pkgs; [
      coreutils
      gnused
      ffmpeg
      jq
      whisper-ctranslate2
      libnotify
    ];
    text = ''
      INPUT_FILE="$1"

      notify_error() {
        notify-send \
          --urgency=critical \
          --app-name="memo-transcriber" \
          "Memo transcription failed" \
          "$1"
        echo "$1" >&2
      }

      BASENAME=$(basename "$INPUT_FILE")
      TITLE=$(basename "$INPUT_FILE" | sed 's/\.[^.]*$//')

      NORMALIZED=$(echo "$TITLE" \
        | tr ' ' '-' \
        | sed 's/[^A-Za-z0-9-]//g' \
        | tr '[:upper:]' '[:lower:]')

      AUDIO_TIMESTAMP=$(ffprobe \
        -v quiet \
        -print_format json \
        -show_format "$INPUT_FILE" \
        | jq -r '.format.tags.creation_time // empty')

      if [[ -n "$AUDIO_TIMESTAMP" ]]; then
        TIMESTAMP=$(date -d "$AUDIO_TIMESTAMP" +%s)
        HUMAN_TIMESTAMP=$(date -d "$AUDIO_TIMESTAMP" '+%Y-%m-%d %H:%M:%S')
      else
        TIMESTAMP=$(date +%s)
        HUMAN_TIMESTAMP=$(date -d "@$TIMESTAMP" '+%Y-%m-%d %H:%M:%S')
      fi

      ID="''${TIMESTAMP}-''${NORMALIZED}"
      ARCHIVED_PATH="${archiveDir}/''${BASENAME}"
      NOTE_PATH="${notesDir}/''${ID}.md"

      if [[ -f "$NOTE_PATH" ]]; then
        notify-send \
          --urgency=normal \
          --app-name="memo-transcriber" \
          "Memo already transcribed" \
          "Skipping $BASENAME — note already exists at $NOTE_PATH"
        echo "Skipping $BASENAME, note already exists" >&2
        exit 0
      fi

      whisper-ctranslate2 "$INPUT_FILE" \
        --output_dir /tmp \
        --output_format txt \
        --language en \
        --vad_filter True \
        --initial_prompt "${initialPrompt}" \
        --hotwords "${builtins.concatStringsSep "," hotwords}"

      TRANSCRIPT_FILE="/tmp/''${TITLE}.txt"

      if [[ ! -f "$TRANSCRIPT_FILE" ]]; then
        notify_error "Whisper produced no output for $BASENAME"
        exit 1
      fi

      TRANSCRIPT=$(cat "$TRANSCRIPT_FILE" \
        | tr '\n' ' ' \
        | sed 's/  */ /g' \
        | sed 's/[.!?] /&\n/g')

      mv "$INPUT_FILE" "$ARCHIVED_PATH"

      cat > "$NOTE_PATH" <<MARKDOWN
      ---
      id: $ID
      tags:
        - zettelkasten
        - fleeting-note
        - transcribed
      path: fleeting
      publish: false
      processed: false
      reference: false
      title: "$TITLE"
      aliases:
        - "$TITLE"
      ---
      # Transcribed $TITLE
      $TRANSCRIPT

      ## Reference
      $HUMAN_TIMESTAMP
      $ARCHIVED_PATH
      MARKDOWN

      rm -f "$TRANSCRIPT_FILE"
      echo "Done: $NOTE_PATH"
    '';
  };

  watchScript = pkgs.writeShellApplication {
    name = "watch-memos";
    runtimeInputs = with pkgs; [
      coreutils
      inotify-tools
      libnotify
    ];
    text = ''
      echo "Watching ${memosDir} for new voice memos..."

      for f in "${memosDir}"/*.m4a "${memosDir}"/*.aac "${memosDir}"/*.mp3 "${memosDir}"/*.ogg; do
        [[ -f "$f" ]] && ${transcribeScript}/bin/transcribe-memo "$f" || true
      done

      inotifywait \
        --monitor \
        --quiet \
        --event close_write \
        --event moved_to \
        --format '%w%f' \
        "${memosDir}" | while read -r FILE; do
          case "$FILE" in
            *.m4a|*.aac|*.mp3|*.ogg)
              echo "New memo detected: $FILE"
              ${transcribeScript}/bin/transcribe-memo "$FILE" || notify-send \
                --urgency=critical \
                --app-name="memo-transcriber" \
                "Memo transcription failed" \
                "Unexpected error processing $(basename "$FILE")"
              ;;
            *)
              echo "Ignoring: $FILE"
              ;;
          esac
        done
    '';
  };
in {
  home = {
    packages = with pkgs; [
      whisper-ctranslate2
      inotify-tools
      ffmpeg
      jq
      libnotify
    ];
  };

  systemd.user.tmpfiles.rules = let
    user = config.home.username;
    group = "users";
  in [
    "d ${memosDir} 0755 ${user} ${group} - -"
    "d ${archiveDir} 0755 ${user} ${group} - -"
    "d ${notesDir} 0755 ${user} ${group} - -"
  ];

  services.syncthing.settings.folders = {
    "recordings" = {
      enable = true;
      path = memosDir;
      id = "ncp43-9drkl";
      label = "Recordings";
      type = "sendreceive";
      devices = ["wanderer" "bastion"];
      ignorePatterns = ["/archive" "/.tmp" "/.trash"];
      versioning = {
        type = "trashcan";
        params.cleanoutDays = "14";
      };
    };
  };

  systemd.user.services.memo-transcriber = {
    Unit = {
      Description = "Voice memo transcriber";
      After = ["default.target"];
    };

    Service = {
      Type = "simple";
      ExecStart = "${watchScript}/bin/watch-memos";
      Restart = "on-failure";
      RestartSec = "5s";
      TimeoutStopSec = "30s";
    };

    Install = {
      WantedBy = ["default.target"];
    };
  };
}
