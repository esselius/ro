{ inputs, ... }:
{
  flake.modules.nixos.secrets =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      inherit (lib)
        mkOption
        types
        mkIf
        mapAttrs
        ;
      isBuildVM = config.virtualisation ? qemu;
      cfg = config.ro;
    in
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];

      options.ro = {
        secrets = mkOption {
          type = types.attrsOf (
            types.submodule (
              { name, ... }:
              {
                freeformType = types.attrsOf types.anything;
                options = {
                  path = mkOption {
                    readOnly = true;
                    type = types.path;
                    default =
                      if isBuildVM then
                        (pkgs.writeText name cfg.secrets.${name}.literal).outPath
                      else
                        config.sops.secrets.${name}.path;
                  };
                };
              }
            )
          );
        };
      };

      config = {
        sops.defaultSopsFile = inputs.secrets + "/nixos-" + config.networking.hostName + ".yaml";
        sops.defaultSopsFormat = "yaml";

        sops.secrets = mkIf (!isBuildVM) (
          mapAttrs (
            k: v:
            (builtins.removeAttrs v [
              "literal"
              "path"
            ])
          ) config.ro.secrets
        );
      };
    };
}
