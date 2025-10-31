{
  flake.modules.nixos.ro =
    { lib, config, ... }:
    {
      options = {
        ro.domain = lib.mkOption {
          type = lib.types.str;
          default = "${config.networking.hostName}.esselius.dev";
        };
      };
    };
}
