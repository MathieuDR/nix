{
  pkgs,
  config,
  ...
}: let
  # So I can rename files
  processingDelay = 15;

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
  ];

  initialPrompt = "Personal voice memos and fleeting notes from a software engineer. Topics include software engineering with terms like ${builtins.concatStringsSep ", " promptKeywords}, and hobbies like Dungeons and Dragons.";

  memosDir = "${config.home.homeDirectory}/recordings/memos";
  transcribeScript = pkgs.writeShellScript "transcribe-memo" ''
        set -euo pipefail

        INPUT_FILE="$1"
        MEMOS_DIR="${memosDir}"
        ARCHIVE_DIR="${memosDir}/archive"
        NOTES_DIR="$HOME/notes/obsidian/fleeting"

        mkdir -p "$ARCHIVE_DIR" "$NOTES_DIR"

        notify_error() {
          ${pkgs.libnotify}/bin/notify-send \
            --urgency=critical \
            --app-name="memo-transcriber" \
            "Memo transcription failed" \
            "$1"
          echo "$1" >&2
        }

        # Derive base name and title
        BASENAME=$(basename "$INPUT_FILE")
        TITLE=$(basename "$INPUT_FILE" | sed 's/\.[^.]*$//')

        # Normalize title: spaces to dashes, strip non-alphanumeric-or-dash, lowercase
        NORMALIZED=$(echo "$TITLE" \
          | tr ' ' '-' \
          | sed 's/[^A-Za-z0-9-]//g' \
          | tr '[:upper:]' '[:lower:]')

        # Try to get creation time from audio metadata
        AUDIO_TIMESTAMP=$(${pkgs.ffmpeg}/bin/ffprobe \
          -v quiet \
          -print_format json \
          -show_format "$INPUT_FILE" \
          | ${pkgs.jq}/bin/jq -r '.format.tags.creation_time // empty')

        if [[ -n "$AUDIO_TIMESTAMP" ]]; then
          TIMESTAMP=$(date -d "$AUDIO_TIMESTAMP" +%s)
          HUMAN_TIMESTAMP=$(date -d "$AUDIO_TIMESTAMP" '+%Y-%m-%d %H:%M:%S')
        else
          TIMESTAMP=$(date +%s)
          HUMAN_TIMESTAMP=$(date -d "@$TIMESTAMP" '+%Y-%m-%d %H:%M:%S')
        fi

        ID="''${TIMESTAMP}-''${NORMALIZED}"
        ARCHIVED_PATH="''${ARCHIVE_DIR}/''${BASENAME}"
        NOTE_PATH="''${NOTES_DIR}/''${ID}.md"

        # Skip if note already exists
        if [[ -f "$NOTE_PATH" ]]; then
          ${pkgs.libnotify}/bin/notify-send \
            --urgency=normal \
            --app-name="memo-transcriber" \
            "Memo already transcribed" \
            "Skipping $BASENAME — note already exists at $NOTE_PATH"
          echo "Skipping $BASENAME, note already exists" >&2
          exit 0
        fi

        # 1. Transcribe
        ${pkgs.whisper-ctranslate2}/bin/whisper-ctranslate2 "$INPUT_FILE" \
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

        # Unwrap whisper's hard-wrapped lines into one block, then split on sentence endings
        TRANSCRIPT=$(cat "$TRANSCRIPT_FILE" \
          | tr '\n' ' ' \
          | sed 's/  */ /g' \
          | sed 's/[.!?] /&\n/g')

        # 2. Archive the audio
        mv "$INPUT_FILE" "$ARCHIVED_PATH"

        # 3. Write the markdown note
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

  watchScript = pkgs.writeShellScript "watch-memos" ''
    set -euo pipefail
    MEMOS_DIR="${memosDir}"

    echo "Watching $MEMOS_DIR for new voice memos..."

    # Process any files that were synced while the service was not running
    for f in "$MEMOS_DIR"/*.m4a "$MEMOS_DIR"/*.aac "$MEMOS_DIR"/*.mp3 "$MEMOS_DIR"/*.ogg; do
      [[ -f "$f" ]] && ${transcribeScript} "$f" || true
    done

    # Watch for new files
    ${pkgs.inotify-tools}/bin/inotifywait \
      --monitor \
      --quiet \
      --event close_write \
      --event moved_to \
      --format '%w%f' \
      "$MEMOS_DIR" | while read -r FILE; do
        case "$FILE" in
          *.m4a|*.aac|*.mp3|*.ogg)
            echo "Waiting ${toString processingDelay}s before processing: $FILE"
            sleep ${toString processingDelay}
            if [[ ! -f "$FILE" ]]; then
              echo "File no longer exists, likely renamed: $FILE"
              continue
            fi
            echo "New memo detected: $FILE"
            ${transcribeScript} "$FILE" || ${pkgs.libnotify}/bin/notify-send \
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

  # Syncthing has to be enabled for the following
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
      ExecStart = "${watchScript}";
      Restart = "on-failure";
      RestartSec = "5s";
      TimeoutStopSec = "30s";
    };

    Install = {
      WantedBy = ["default.target"];
    };
  };
}
