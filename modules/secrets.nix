{ inputs, ... }:
{
  flake.modules.nixos.secrets =
    { config, ... }:
    {
      sops.defaultSopsFile = inputs.secrets + "/nixos-" + config.networking.hostName + ".yaml";
    };
}
