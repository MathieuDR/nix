# Define the default recipe to list available commands
default:
    @just --list

rebuild:
	sudo nixos-rebuild switch --flake .#anchor

hm:
	home-manager switch --flake .#Thieu@anchor -b backup

update:
	nix flake update
	just rebuild
	just hm

update_yvim:
	nix flake lock --update-input yvim
	just hm
