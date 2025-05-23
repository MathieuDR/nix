{user, ...}: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    description = "Mathieu De Raedt";
    extraGroups = [
      "networkmanager"
      "wheel"
      "scanner"
      "lp"
    ];
  };

  services.getty.autologinUser = user;
}
