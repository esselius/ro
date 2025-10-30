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
      inherit (lib.types)
        attrsOf
        submodule
        anything
        path
        ;
      isBuildVM = config.virtualisation ? qemu;
      cfg = config.ro;
    in
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];

      options.ro = {
        secrets = lib.mkOption {
          type = attrsOf (
            submodule (
              { name, ... }:
              {
                freeformType = attrsOf anything;
                options = {
                  path = lib.mkOption {
                    readOnly = true;
                    type = path;
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

        sops.secrets = lib.mkIf (!isBuildVM) (
          lib.mapAttrs (
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
