{ inputs, ... }:
{
  flake.modules.nixos.secrets =
    { config, ... }:
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];
      sops.defaultSopsFile = inputs.secrets + "/nixos-" + config.networking.hostName + ".yaml";
      sops.defaultSopsFormat = "yaml";
    };
}
