{...}: {
  flake.modules.homeManager.copyq = {...}: {
    services.copyq.enable = true;
  };
}
