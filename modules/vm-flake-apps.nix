{ inputs, config, ... }:
{
  perSystem =
    { lib, system, ... }:
    {
      apps = lib.mapAttrs' (
        name: value:
        let
          appName = "vm-" + name;
          extendedNixosConfig = value.extendModules { modules = [ module ]; };
          program = lib.getExe extendedNixosConfig.config.system.build.vm;

          module = {
            virtualisation.vmVariant = {
              sops.age.keyFile = "";
              sops.environment.SOPS_AGE_KEY_FILE = ../secrets-mock/key.txt;
              services.getty.autologinUser = "root";
              virtualisation = {
                host.pkgs = inputs.nixpkgs.legacyPackages.${system};
                diskImage = "./.tmp/${appName}.qcow2";
              };
            };
          };
        in
        lib.nameValuePair appName { inherit program; }
      ) config.flake.nixosConfigurations;
    };
}
