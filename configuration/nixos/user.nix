{user, ...}: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
  };

  services.getty.autologinUser = user;
}
