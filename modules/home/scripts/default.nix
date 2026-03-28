{...}: {
  flake.modules.homeManager.scripts = {...}: {
    imports = [
      ./_git.nix
      ./_shlink.nix
    ];
  };
}
