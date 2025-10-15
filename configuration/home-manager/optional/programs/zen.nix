{
  pkgs,
  inputs,
  config,
  ...
}: let
  catppuccin-css = pkgs.fetchgit {
    url = "https://github.com/catppuccin/zen-browser";
    rev = "e171e2a1d94ed70f39ff0ac452aef335f8b233c9";
    hash = "sha256-v4Gg2oyITMV/KWCy+gWrmCcmYLRUyMV1HiYSeFjVOuI=";
    sparseCheckout = [
      "themes/Latte/Mauve"
      "themes/Mocha/Mauve"
    ];
  };
in {
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

  home.file = {
    "${config.programs.zen-browser.configPath}/${config.programs.zen-browser.profiles.default.path}/chrome/zen-logo-mocha.svg" = {
      source = "${catppuccin-css}/themes/Mocha/Mauve/zen-logo-mocha.svg";
    };
    "${config.programs.zen-browser.configPath}/${config.programs.zen-browser.profiles.default.path}/chrome/zen-logo-latte.svg" = {
      source = "${catppuccin-css}/themes/Latte/Mauve/zen-logo-latte.svg";
    };
  };

  programs.zen-browser = {
    enable = true;

    languagePacks = ["en-GB" "en" "nl-BE" "de"];

    policies = {
      DisableAppUpdate = true;
      DisableTelemetry = true;
      DisablePocket = true;
      DisableSetDesktopBackground = true;
      DontCheckDefaultBrowser = true;
      PasswordManagerEnabled = false;
      DisableFormHistory = true;
      DisableFirefoxStudies = true;
    };

    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;

        # Browser settings
        settings = {
          # Enable userChrome.css and userContent.css
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

          # Language and region
          "general.useragent.locale" = "en-GB";
          "browser.search.region" = "DE";
          "browser.search.isUS" = false;
          "distribution.searchplugins.defaultLocale" = "en-GB";
          "browser.search.defaultenginename" = "ddg";

          # Downloads
          # We now use XDG stuff!
          # "browser.download.dir" = "${config.home.homeDirectory}/downloads";
          # # 0=Desktop dir, 1=Downloads / system dir, 2=Custom
          # "browser.download.folderList" = 2;
          # "browser.download.useDownloadDir" = true;

          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "privacy.donottrackheader.enabled" = true;

          # Disable password manager
          "signon.rememberSignons" = false;
          "signon.autofillForms" = false;
          "signon.generation.enabled" = false;

          # Disable form autofill
          "browser.formfill.enable" = false;
          "extensions.formautofill.addresses.enabled" = false;
          "extensions.formautofill.creditCards.enabled" = false;

          # Performance and UI
          "browser.tabs.loadInBackground" = true;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

          "devtools.theme" = "dark";
          "devtools.toolbox.host" = "bottom";

          "privacy.userContext.enabled" = true;
          "privacy.userContext.ui.enabled" = true;
          "extensions.autoDisableScopes" = 0;

          "layout.spellcheckDefault" = 2; # Check all text
          "spellchecker.dictionary" = "en-GB,en-US,nl-BE,de-DE";
        };

        containers = {
          personal = {
            id = 1;
            name = "Personal";
            color = "blue";
            icon = "fingerprint";
          };
          work = {
            id = 2;
            name = "Work";
            color = "green";
            icon = "briefcase";
          };
        };
        containersForce = true;

        search = {
          enable = true;
          force = true;
          default = "ddg";
        };

        # Extensions
        extensions = {
          force = true;
          # Missing
          # MediumParser
          # GIFS For Github
          # POPUP Blocker Ultimate
          # Clickbait remover for Youtube
          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin
            privacy-badger
            clearurls
            disconnect

            cookie-quick-manager
            i-dont-care-about-cookies # or istilldontcareaboutcookies

            darkreader
            firefox-color
            stylus

            multi-account-containers
            vimium-c
            new-tab-override
            scroll_anywhere
            tampermonkey

            enhanced-github
            downthemall

            old-reddit-redirect
            reddit-enhancement-suite
            youtube-shorts-block

            keepassxc-browser
            readeck
            leechblock-ng
            beyond-20

            augmented-steam
            steam-database

            #belgium-eid
          ];

          # Extension-specific settings
          # settings = {};
        };

        # Custom CSS for better development experience
        userChrome = ''
          /* Compact tabs for more screen space */
          #TabsToolbar {
            margin-bottom: -1px !important;
          }

          /* Hide unnecessary UI elements */
          #reader-mode-button,
          #pageActionButton {
            display: none !important;
          }

          /* Catppuccin theme */
          ${builtins.readFile "${catppuccin-css}/themes/Latte/Mauve/userChrome.css"}
          ${builtins.readFile "${catppuccin-css}/themes/Mocha/Mauve/userChrome.css"}

          #contentAreaContextMenu menu, menuitem, menupopup {
            color: #c6d0f5 !important;
          }
        '';

        userContent = ''
          /* Dark scrollbars */
          * {
            scrollbar-width: thin !important;
            scrollbar-color: #4a5568 #2d3748 !important;
          }

          /* Better code highlighting in web pages */
          pre, code {
            font-family: "JetBrains Mono", "Fira Code", monospace !important;
          }

          /* Catppuccin theme */
          ${builtins.readFile "${catppuccin-css}/themes/Latte/Mauve/userContent.css"}
          ${builtins.readFile "${catppuccin-css}/themes/Mocha/Mauve/userContent.css"}
        '';
      };
    };
  };
}
