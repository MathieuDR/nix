{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

  programs.zen-browser = {
    enable = true;

    languagePacks = ["en-GB" "en" "nl-BE" "de"];

    policies = {
      DisableAppUpdate = true;
      DisableTelemetry = true;
      DisablePocket = true;
      DisableSetDesktopBackground = true;
      DontCheckDefaultBrowser = true;
      DefaultDownloadDirectory = "\${home}/downloads";
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
          # Language and region
          "general.useragent.locale" = "en-GB";
          "browser.search.region" = "DE";
          "browser.search.isUS" = false;
          "distribution.searchplugins.defaultLocale" = "en-GB";
          "browser.search.defaultenginename" = "ddg";

          # Downloads
          "browser.download.dir" = "\${home}/downloads";

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

          /* CATPPUCCIN
            https://github.com/catppuccin/zen-browser
          */

          @media (prefers-color-scheme: dark) {
            :root {
              --zen-colors-primary: #313244 !important;
              --zen-primary-color: #cba6f7 !important;
              --zen-colors-secondary: #313244 !important;
              --zen-colors-tertiary: #181825 !important;
              --zen-colors-border: #cba6f7 !important;
              --toolbarbutton-icon-fill: #cba6f7 !important;
              --lwt-text-color: #cdd6f4 !important;
              --toolbar-field-color: #cdd6f4 !important;
              --tab-selected-textcolor: rgb(204, 190, 246) !important;
              --toolbar-field-focus-color: #cdd6f4 !important;
              --toolbar-color: #cdd6f4 !important;
              --newtab-text-primary-color: #cdd6f4 !important;
              --arrowpanel-color: #cdd6f4 !important;
              --arrowpanel-background: #1e1e2e !important;
              --sidebar-text-color: #cdd6f4 !important;
              --lwt-sidebar-text-color: #cdd6f4 !important;
              --lwt-sidebar-background-color: #11111b !important;
              --toolbar-bgcolor: #313244 !important;
              --newtab-background-color: #1e1e2e !important;
              --zen-themed-toolbar-bg: #181825 !important;
              --zen-main-browser-background: #181825 !important;
              --toolbox-bgcolor-inactive: #181825 !important;
            }

            #permissions-granted-icon{
              color: #181825 !important;
            }

            .sidebar-placesTree {
              background-color: #1e1e2e !important;
            }

            #zen-workspaces-button {
              background-color: #1e1e2e !important;
            }

            #TabsToolbar {
              background-color: #181825 !important;
            }

            #urlbar-background {
              background-color: #1e1e2e !important;
            }

            .content-shortcuts {
              background-color: #1e1e2e !important;
              border-color: #cba6f7 !important;
            }

            .urlbarView-url {
              color: #cba6f7 !important;
            }

            #zenEditBookmarkPanelFaviconContainer {
              background: #11111b !important;
            }

            #zen-media-controls-toolbar {
              & #zen-media-progress-bar {
                &::-moz-range-track {
                  background: #313244 !important;
                }
              }
            }

            toolbar .toolbarbutton-1 {
              &:not([disabled]) {
                &:is([open], [checked])
                  > :is(
                    .toolbarbutton-icon,
                    .toolbarbutton-text,
                    .toolbarbutton-badge-stack
                  ) {
                  fill: #11111b;
                }
              }
            }

            .identity-color-blue {
              --identity-tab-color: #89b4fa !important;
              --identity-icon-color: #89b4fa !important;
            }

            .identity-color-turquoise {
              --identity-tab-color: #94e2d5 !important;
              --identity-icon-color: #94e2d5 !important;
            }

            .identity-color-green {
              --identity-tab-color: #a6e3a1 !important;
              --identity-icon-color: #a6e3a1 !important;
            }

            .identity-color-yellow {
              --identity-tab-color: #f9e2af !important;
              --identity-icon-color: #f9e2af !important;
            }

            .identity-color-orange {
              --identity-tab-color: #fab387 !important;
              --identity-icon-color: #fab387 !important;
            }

            .identity-color-red {
              --identity-tab-color: #f38ba8 !important;
              --identity-icon-color: #f38ba8 !important;
            }

            .identity-color-pink {
              --identity-tab-color: #f5c2e7 !important;
              --identity-icon-color: #f5c2e7 !important;
            }

            .identity-color-purple {
              --identity-tab-color: #cba6f7 !important;
              --identity-icon-color: #cba6f7 !important;
            }
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

          /* CATPPUCCIN
             https://github.com/catppuccin/zen-browser
          */

          /* Catppuccin Mocha Mauve userContent.css*/

          @media (prefers-color-scheme: dark) {

            /* Common variables affecting all pages */
            @-moz-document url-prefix("about:") {
              :root {
                --in-content-page-color: #cdd6f4 !important;
                --color-accent-primary: #cba6f7 !important;
                --color-accent-primary-hover: rgb(217, 191, 249) !important;
                --color-accent-primary-active: rgb(223, 167, 247) !important;
                background-color: #1e1e2e !important;
                --in-content-page-background: #1e1e2e !important;
              }

            }

            /* Variables and styles specific to about:newtab and about:home */
            @-moz-document url("about:newtab"), url("about:home") {

              :root {
                --newtab-background-color: #1e1e2e !important;
                --newtab-background-color-secondary: #313244 !important;
                --newtab-element-hover-color: #313244 !important;
                --newtab-text-primary-color: #cdd6f4 !important;
                --newtab-wordmark-color: #cdd6f4 !important;
                --newtab-primary-action-background: #cba6f7 !important;
              }

              .icon {
                color: #cba6f7 !important;
              }

              .search-wrapper .logo-and-wordmark .logo {
                background: url("zen-logo-mocha.svg"), url("https://raw.githubusercontent.com/IAmJafeth/zen-browser/main/themes/Mocha/Mauve/zen-logo-mocha.svg") no-repeat center !important;
                display: inline-block !important;
                height: 82px !important;
                width: 82px !important;
                background-size: 82px !important;
              }

              @media (max-width: 609px) {
                .search-wrapper .logo-and-wordmark .logo {
                  background-size: 64px !important;
                  height: 64px !important;
                  width: 64px !important;
                }
              }

              .card-outer:is(:hover, :focus, .active):not(.placeholder) .card-title {
                color: #cba6f7 !important;
              }

              .top-site-outer .search-topsite {
                background-color: #89b4fa !important;
              }

              .compact-cards .card-outer .card-context .card-context-icon.icon-download {
                fill: #a6e3a1 !important;
              }
            }

            /* Variables and styles specific to about:preferences */
            @-moz-document url-prefix("about:preferences") {
              :root {
                --zen-colors-tertiary: #181825 !important;
                --in-content-text-color: #cdd6f4 !important;
                --link-color: #cba6f7 !important;
                --link-color-hover: rgb(217, 191, 249) !important;
                --zen-colors-primary: #313244 !important;
                --in-content-box-background: #313244 !important;
                --zen-primary-color: #cba6f7 !important;
              }

              groupbox , moz-card{
                background: #1e1e2e !important;
              }

              button,
              groupbox menulist {
                background: #313244 !important;
                color: #cdd6f4 !important;
              }

              .main-content {
                background-color: #11111b !important;
              }

              .identity-color-blue {
                --identity-tab-color: #8aadf4 !important;
                --identity-icon-color: #8aadf4 !important;
              }

              .identity-color-turquoise {
                --identity-tab-color: #8bd5ca !important;
                --identity-icon-color: #8bd5ca !important;
              }

              .identity-color-green {
                --identity-tab-color: #a6da95 !important;
                --identity-icon-color: #a6da95 !important;
              }

              .identity-color-yellow {
                --identity-tab-color: #eed49f !important;
                --identity-icon-color: #eed49f !important;
              }

              .identity-color-orange {
                --identity-tab-color: #f5a97f !important;
                --identity-icon-color: #f5a97f !important;
              }

              .identity-color-red {
                --identity-tab-color: #ed8796 !important;
                --identity-icon-color: #ed8796 !important;
              }

              .identity-color-pink {
                --identity-tab-color: #f5bde6 !important;
                --identity-icon-color: #f5bde6 !important;
              }

              .identity-color-purple {
                --identity-tab-color: #c6a0f6 !important;
                --identity-icon-color: #c6a0f6 !important;
              }
            }

            /* Variables and styles specific to about:addons */
            @-moz-document url-prefix("about:addons") {
              :root {
                --zen-dark-color-mix-base: #181825 !important;
                --background-color-box: #1e1e2e !important;
              }
            }

            /* Variables and styles specific to about:protections */
            @-moz-document url-prefix("about:protections") {
              :root {
                --zen-primary-color: #1e1e2e !important;
                --social-color: #cba6f7 !important;
                --coockie-color: #89dceb !important;
                --fingerprinter-color: #f9e2af !important;
                --cryptominer-color: #b4befe !important;
                --tracker-color: #a6e3a1 !important;
                --in-content-primary-button-background-hover: rgb(81, 83, 105) !important;
                --in-content-primary-button-text-color-hover: #cdd6f4 !important;
                --in-content-primary-button-background: #45475a !important;
                --in-content-primary-button-text-color: #cdd6f4 !important;
              }


              .card {
                background-color: #313244 !important;
              }
            }
          }
        '';
      };
    };
  };
}
