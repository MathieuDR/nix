# From: https://git.scottworley.com/nix-profile-gc
# nix-profile-gc: More gently remove old profiles
# Copyright (C) 2022 Scott Worley <scottworley@scottworley.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) escapeShellArg;
  cfg = config.nix.profile-gc;
  parse-duration = duration:
    pkgs.runCommand "duration" {buildInputs = with pkgs; [systemd];} ''
      set -euo pipefail
      parsed=$(systemd-analyze timespan ${escapeShellArg duration} | awk '$1 == "Î¼s:" { print $2 }')
      echo "$parsed" > "$out"
    '';
in {
  options = {
    nix.profile-gc = {
      enable = lib.mkEnableOption "Automatic profile garbage collection";
      dryRun = lib.mkOption {
        description = "Say what would have been deleted rather than actually deleting profiles";
        type = lib.types.bool;
        default = false;
      };
      keepLast = lib.mkOption {
        description = ''
          Number of recent profiles to keep.
          This control is similar to nix-env --delete-generation's +5 syntax.
        '';
        type = lib.types.ints.unsigned;
        default = 5;
      };
      keepLastActive = lib.mkOption {
        description = "Number of recent active profiles to keep";
        type = lib.types.ints.unsigned;
        default = 5;
      };
      keepLastActiveSystem = lib.mkOption {
        description = "Number of recent active system profiles to keep";
        type = lib.types.ints.unsigned;
        default = 5;
      };
      keepLastActiveBoot = lib.mkOption {
        description = "Number of recent active boot profiles to keep";
        type = lib.types.ints.unsigned;
        default = 3;
      };
      activeThreshold = lib.mkOption {
        description = ''
          A system profile that is active (or is either /run/current-system or /run/booted-system)
          for at least this long (of powered-on machine time) is considered 'active' for
          the purpose of evaluating the keepLastActive number of profiles.  This mechanism is
          intended to preserve profiles that are in some sense stable, that have served us well,
          so they don't immediately become gc-elligible when a system hasn't been updated in
          awhile (so keepLatest won't protect them) generates a bunch of broken profiles (so
          keepLast won't protect them) while trying to get up to date.

          This threshold is approximate, see activeMeasurementGranularity.
          Do not set less than activeMeasurementGranularity!
        '';
        # We admonish the user "Do not set less than activeMeasurementGranularity!" and check
        # it at runtime rather than verifying this with an assertion at evaluation time because
        # parsing these durations at evaluation-time requires import-from-derivation, which we
        # want to avoid.  :(
        type = lib.types.str;
        default = "5 days";
      };
      activeMeasurementGranularity = lib.mkOption {
        description = ''
          How often to make a note of the currently-active profiles.  This is the useful
          granularity and minimum value of activeThreshold.
        '';
        default = "1 hour";
      };
      keepLatest = lib.mkOption {
        description = ''
          Keep all profiles younger than this duration (systemd.time format).
          This control is similar to nix-collect-garbage's --delete-older-than.
        '';
        type = lib.types.str;
        default = "6 months";
      };
      keepFuture = lib.mkOption {
        description = "Keep profiles 'ahead' of the current profile (happens after rollback)";
        type = lib.types.bool;
        default = true;
      };
      logdir = lib.mkOption {
        description = "Where to keep liveness logs";
        type = lib.types.str;
        default = "/var/log/profile-gc";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.enable -> config.nix.gc.automatic;
        message = ''nix.profile-gc.enable requires nix.gc.automatic'';
      }
    ];
    systemd.services.nix-gc.serviceConfig.ExecStartPre = pkgs.writeShellScript "nix-profile-gc" ''
      set -euo pipefail

      if [[ ! -e ${cfg.logdir}/active-system
         || ! -e ${cfg.logdir}/active-boot
         || ! -e ${cfg.logdir}/active-profiles ]]
      then
        echo "Liveness logs not found.  Not doing any profile garbage collection." >&2
        exit 0
      fi

      alive_threshold="$(< ${parse-duration cfg.activeThreshold})"
      alive_loginterval="$(< ${parse-duration cfg.activeMeasurementGranularity})"
      if (( alive_threshold < alive_loginterval ));then
        echo "Liveness threshold is too low.  Not doing any profile garbage collection." >&2
        exit 0
      fi

      topn() {
        ${pkgs.coreutils}/bin/tac "$1" |
          ${pkgs.gawk}/bin/awk \
            --assign key="$2" \
            --assign n="$3" \
            --assign threshold="$alive_threshold" \
            --assign loginterval="$alive_loginterval" \
            '
              !key || $1 == key {
                val = key ? $2 : $1
                if (++count[val] == int(threshold/loginterval)) {
                  print val
                  if (++found == n) {
                    exit 0
                  }
                }
              }
            '
      }

      verbose_topn() {
        topn "$@" | tee >(
          echo "Keeping the last $3 $2 entries from $1:" >&2
          ${pkgs.gawk}/bin/gawk '{ print "  " $0 }' >&2 )
      }

      declare -A active_targets
      while read -r target;do
        active_targets[$target]=1
      done < <(
        verbose_topn ${cfg.logdir}/active-system "" ${escapeShellArg cfg.keepLastActiveSystem}
        verbose_topn ${cfg.logdir}/active-boot   "" ${escapeShellArg cfg.keepLastActiveBoot}
      )

      now=$(${pkgs.coreutils}/bin/date +%s)
      age_threshold="$(< ${parse-duration cfg.keepLatest})"
      while read -r profile;do
        echo "Contemplating profiles for $profile:" >&2
        unset active
        declare -A active
        while read -r pname;do
          active[$pname]=1
        done < <(verbose_topn ${cfg.logdir}/active-profiles "$profile" ${escapeShellArg cfg.keepLastActive})
        current=$(${pkgs.coreutils}/bin/readlink "$profile")
        currentgen=''${current%-link}
        currentgen=''${currentgen##*-}
        for p in "$profile"-*-link;do
          pgen=''${p%-link}
          pgen=''${pgen##*-}
          if [[ "$p" != "$profile-$pgen-link" ]];then
            echo "(Disregarding unrelated profile $p)" >&2
            continue
          fi
          pname=$(${pkgs.coreutils}/bin/basename "$p")
          if [[ "$pname" == "$current" ]];then
            echo "Keeeping current profile $p" >&2
            continue
          fi
          if [[ "''${active_targets[$(${pkgs.coreutils}/bin/readlink "$p")]:-}" ]];then
            echo "Keeeping active system/boot profile $p" >&2
            continue
          fi
          if [[ "''${active[$pname]:-}" ]];then
            echo "Keeeping active profile $p" >&2
            continue
          fi
          if (( (now - "$(${pkgs.findutils}/bin/find "$p" -printf %Ts)") < age_threshold/1000000 ));then
            echo "Keeeping young profile $p" >&2
            continue
          fi
          ${lib.optionalString cfg.keepFuture ''
        if (( pgen > currentgen ));then
          echo "Keeeping future profile $p" >&2
          continue
        fi
      ''}
          ${
        if cfg.dryRun
        then ''
          echo "Would remove profile $p" >&2
        ''
        else ''
          echo "Removing profile $p" >&2
          rm "$p"
        ''
      }
        done
      done < <(${pkgs.findutils}/bin/find "''${NIX_STATE_DIR:-/nix/var/nix}/profiles/" -type l -not -name '*[0-9]-link')
    '';
    systemd.timers.profile-gc-log-active = {
      wantedBy = ["timers.target"];
      timerConfig.OnActiveSec = cfg.activeMeasurementGranularity;
      timerConfig.OnUnitActiveSec = cfg.activeMeasurementGranularity;
    };
    systemd.services.profile-gc-log-active = {
      description = "Log the active profiles for gc collection policy evaluation";
      serviceConfig.Type = "oneshot";
      script = ''
        ${pkgs.coreutils}/bin/mkdir -p ${cfg.logdir}
        ${pkgs.coreutils}/bin/readlink /run/current-system >> ${cfg.logdir}/active-system
        ${pkgs.coreutils}/bin/readlink /run/booted-system  >> ${cfg.logdir}/active-boot
        ${pkgs.findutils}/bin/find ''${NIX_STATE_DIR:-/nix/var/nix}/profiles/ \
          -type l -not -name '*[0-9]-link' \
          -exec ${pkgs.stdenv.shell} -c '
            for f;do
              echo -n "$f "
              ${pkgs.coreutils}/bin/readlink "$f"
            done' - {} + \
          >> ${cfg.logdir}/active-profiles
      '';
    };
  };
}
