{ config, ... }:

{
  flake.modules.nixos.helo = {
    networking.hostName = "helo";
    system.stateVersion = "25.05";
  };

  flake.nixosConfigurations.helo = config.flake.lib.loadNixosSystemForHost "helo" [
    "acme-server"
    "ro"
    "secrets"
    "incus"
    "nginx"
    "dex"
    "postgres"
  ];
}
