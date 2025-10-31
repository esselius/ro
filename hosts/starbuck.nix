{ config, ... }:

{
  flake.modules.nixos.starbuck = {
    networking.hostName = "starbuck";
    system.stateVersion = "25.05";
    networking.hostId = "9c8031a8";
    username = "peteresselius";
  };

  flake.nixosConfigurations.starbuck = config.flake.lib.loadNixosSystemForRpiHost "starbuck" [
    "acme-server"
    "ro"
    "secrets"
    "incus"
    "nginx"
    "dex"
    "postgres"
    "user"
    "hw-rpi5"
    "zfs-rpi5"
  ];
}
