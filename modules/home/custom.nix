# Interface options — values are set per-host in hosts/<name>/misc.nix
{...}: {
  flake.modules.homeManager.custom = {lib, ...}: {
    options.custom = {
      terminal = {
        package = lib.mkOption {
          type = lib.types.package;
          description = "Default terminal emulator package";
        };
        command = lib.mkOption {
          type = lib.types.str;
          description = "Command to launch the terminal";
        };
        # Flags for running a command inside the terminal — varies per emulator
        # kitty: "--hold -e"  |  ghostty: "--wait-after-command -e"  |  foot: "-e"
        execArgs = lib.mkOption {
          type = lib.types.str;
          default = "-e";
          description = "Args to exec a command in the terminal";
        };
      };
      browser = {
        package = lib.mkOption {
          type = lib.types.package;
          description = "Default browser package";
        };
        command = lib.mkOption {
          type = lib.types.str;
          description = "Command to launch the browser";
        };
      };
      fileManager = {
        package = lib.mkOption {
          type = lib.types.package;
          description = "Default file manager package";
        };
        command = lib.mkOption {
          type = lib.types.str;
          description = "Command to launch the file manager";
        };
      };
      launcher = {
        package = lib.mkOption {
          type = lib.types.package;
          description = "Default app launcher package";
        };
        command = lib.mkOption {
          type = lib.types.str;
          description = "Base launcher binary";
        };
        drunCommand = lib.mkOption {
          type = lib.types.str;
          description = "Command to show desktop app search";
        };
        windowCommand = lib.mkOption {
          type = lib.types.str;
          description = "Command to show window switcher";
        };
      };
    };
  };
}
