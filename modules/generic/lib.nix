{ inputs, config, ... }:
{
  flake.lib.loadNixosSystemForHost =
    hostname: modules:
    inputs.nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        config.flake.modules.nixos.${hostname}
        config.flake.modules.nixos.config-assertions
      ]
      ++ builtins.map (module: config.flake.modules.nixos.${module}) modules;
    };

  flake.lib.loadNixosSystemForRpiHost =
    hostname: modules:
    inputs.nixos-raspberrypi.lib.nixosSystem {
      specialArgs = { inherit (inputs) nixos-raspberrypi; };
      modules = [
        config.flake.modules.nixos.${hostname}
        config.flake.modules.nixos.config-assertions
      ]
      ++ builtins.map (module: config.flake.modules.nixos.${module}) modules;
    };

  flake.modules.nixos.config-assertions =
    { config, lib, ... }:
    {
      assertions = [
        {
          assertion = config.networking.hostName != "nixos";
          message = "networking.hostName must be set";
        }
        {
          assertion = config.system.stateVersion != "00.00";
          message = "system.stateVersion must be set";
        }
      ];
      system.stateVersion = lib.mkDefault "00.00";
    };
}
