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
}
