{
  flake.modules.nixos.ro =
    { lib, config, ... }:
    {
      options = {
        ro.domain = lib.mkOption {
          type = lib.types.str;
          default = if config.ro.inVM then "localho.st" else "${config.networking.hostName}.esselius.dev";
        };
        ro.inVM = lib.mkOption {
          type = lib.types.bool;
          default = false;
          example = true;
          description = "Whether this is built for local testing in the VM";
        };
      };
      config = {
        virtualisation.vmVariant = {
          ro.inVM = true;
        };
      };
    };
}
