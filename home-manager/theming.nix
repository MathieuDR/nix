{ config, pkgs, lib, inputs, ... }:
let
  accent = "mauve";
  flavor = "mocha";
in
{
  catppuccin = {
    enable = true;
    accent = accent;
    flavor = flavor;
  };

  #gtk = {
  #  enable = true;
  #  font = {
  #    name ="JetBrainsMono"; 
  #  };

  #  catppuccin = {
  #    enable = true;
  #    accent = accent;
  #    flavor = flavor;
  #    tweaks = ["rimless" "normal"];

  #    cursor = {
  #      enable = true;
  #      accent = accent;
  #      flavor = flavor;
  #    };

  #    icon = {
  #      enable = true;
  #      accent = accent;
  #      flavor = flavor;
  #    };
  #  };
  #};

  #programs = {
  #  waybar.catppuccin = {
  #    enable = true;
  #    flavor = flavor;
  #  };

  #  rofi.catppuccin = {
  #    enable = true;
  #    flavor = flavor;
  #  };

  #  kitty.catppuccin = {
  #    enable = true;
  #    flavor = flavor;
  #  };

  #  k9s.catppuccin = {
  #    enable = true;
  #    flavor = flavor;
  #  };

  #  fzf.catppuccin = {
  #    enable = true;
  #    flavor = flavor;
  #  };
  #};

  #services = {
  #  dunst.catppuccin = {
  #    enable = true;
  #    flavor = flavor;
  #  };
  #};

  #wayland.windowManager.hyprland.catppuccin = {
  #  enable = true;
  #  accent = accent;
  #  flavor = flavor;
  #};
}
