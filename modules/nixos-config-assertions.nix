{
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
