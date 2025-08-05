{
  inputs,
  self,
  hostname,
  user,
  alias,
  ...
}: {
  # Host-specific Darwin configuration
  environment.systemPackages = [
    inputs.home-manager.packages.aarch64-darwin.default
  ];

  system.primaryUser = user;

  system.defaults = {
    dock.autohide = true;
    finder.AppleShowAllExtensions = true;
  };
}
