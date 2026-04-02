{
  pkgs,
  config,
  inputs,
  ...
}: let
  shlinkCreate = pkgs.writeShellApplication {
    name = "shlink";
    runtimeInputs = [pkgs.httpie pkgs.jq];
    text = ''
      SHLINK_HOST="https://l.deraedt.dev"
      SHLINK_API_KEY="$(cat "${config.age.secrets."shlink/key".path}")"

      usage() {
        echo "Usage: shlink-create <long-url> <slug> [-t <tag>]..."
        echo ""
        echo "  -t  tag to apply (can be repeated)"
        exit 1
      }

      [[ $# -lt 2 ]] && usage
      LONG_URL="''${1}"
      SLUG="''${2}"
      shift 2
      DEBUG=false
      TAGS="[]"
      while getopts ":t:d" opt; do
        case $opt in
          t) TAGS="$(echo "$TAGS" | jq --arg t "$OPTARG" '. + [$t]')" ;;
          d) DEBUG=true ;;
          *) usage ;;
        esac
      done

      RESPONSE=$(http POST "''${SHLINK_HOST}/rest/v3/short-urls" \
        X-Api-Key:"''${SHLINK_API_KEY}" \
        longUrl="''${LONG_URL}" \
        customSlug="''${SLUG}" \
        findIfExists:=true \
        forwardQuery:=false \
        tags:="''${TAGS}")

      if ''${DEBUG}; then
        echo "$RESPONSE" | jq .
      else
        echo "$RESPONSE" | jq -r '.shortUrl'
      fi
    '';
  };

  gardenShare = pkgs.writeShellApplication {
    name = "garden-share";
    runtimeInputs = [pkgs.httpie pkgs.jq shlinkCreate];
    text = ''
      usage() {
        echo "Usage: garden-share <note-path> <slug> <utm_source> <utm_medium> <utm_campaign>"
        exit 1
      }

      [[ $# -lt 5 ]] && usage

      NOTE_PATH="''${1}"
      SLUG="''${2}"
      UTM_SOURCE="''${3}"
      UTM_MEDIUM="''${4}"
      UTM_CAMPAIGN="''${5}"

      NOTE_CLEAN="''${NOTE_PATH#/}"
      NOTE_CLEAN="''${NOTE_CLEAN%.md}"
      LONG_URL="https://mathieu.deraedt.dev/''${NOTE_CLEAN}?utm_source=''${UTM_SOURCE}&utm_medium=''${UTM_MEDIUM}&utm_campaign=''${UTM_CAMPAIGN}"

      shlink "''${LONG_URL}" "''${SLUG}" \
        -t garden \
        -t utm \
        -t "source:''${UTM_SOURCE}" \
        -t "medium:''${UTM_MEDIUM}" \
        -t "campaign:''${UTM_CAMPAIGN}"
    '';
  };
in {
  age.secrets."shlink/key".file = "${inputs.self}/data/secrets/shlink/key.age";

  home.packages = [shlinkCreate gardenShare];
}
