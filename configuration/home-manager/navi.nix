{...}: {
  programs.navi = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true; # Since you're using fish
    settings = {
      finder.key_binding = "ctrl-g";
      cheats = {
        paths = ["~/.config/navi/cheats"];
      };
    };
  };

  # Create the cheatsheet file
  home.file.".config/navi/cheats/imv.cheat".text = ''
    % imv

    # pattern
    imv <pattern>*

    # delete marked files with rm
    rm DEL_*

    # unmark deletion
    sh -c 'for f in DEL_*; do mv "$f" "''${f#DEL_}"; done'

    # move selected files
    sh -c 'for f in SELECTED_*; do mv "$f" "<destination>/$(basename "$f" | sed s/^SELECTED_//)"; done'

    # unmark selection
    sh -c 'for f in SELECTED_*; do mv "$f" "''${f#SELECTED_}"; done'

    # Count del files
    ls -1 DEL_* 2>/dev/null | wc -l

    # Count selected files
    ls -1 SELECTED_* 2>/dev/null | wc -l


    $ pattern: ls -1 *.{png,jpg,jpeg,gif,webp} 2>/dev/null | sed -E 's/[_-][0-9]+[_.].*$//' | sort -u --- --fzf-overrides '--header="Image prefix pattern"'
    $ destination: printf '%s\n' ../keepers ../archive ../final --- --fzf-overrides '--header="Move selected to..."'
  '';
}
