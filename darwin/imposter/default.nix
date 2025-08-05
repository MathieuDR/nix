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
  ];

  system.primaryUser = user;

  system.defaults = {
    dock.autohide = true;
    finder.AppleShowAllExtensions = true;
  };
}
