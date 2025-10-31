{
  flake.modules.nixos.incus =
    { config, ... }:
    {
      networking.nftables.enable = true;

      virtualisation.incus = {
        enable = true;
        ui.enable = true;
        preseed = {
          config = {
            "core.https_address" = "127.0.0.1:9999";
            "oidc.issuer" = "https://dex.${config.ro.domain}";
            "oidc.client.id" = "incus";
            "user.ui.sso_only" = true;
          };
          storage_pools = [
            {
              name = "default";
              driver = "dir";
            }
          ];
          networks = [
            {
              config = {
                "ipv4.address" = "auto";
                "ipv6.address" = "auto";
              };
              description = "";
              name = "incusbr0";
              type = "bridge";
              project = "default";
            }
          ];
          profiles = [
            {
              config = {
                "raw.qemu.conf" = ''
                  [memory]
                  maxmem = "256G"
                '';
                "security.secureboot" = "false";
              };
              description = "";
              devices = {
                eth0 = {
                  name = "eth0";
                  network = "incusbr0";
                  type = "nic";
                };
                root = {
                  path = "/";
                  pool = "default";
                  type = "disk";
                };
              };
              name = "default";
              project = "default";
            }
          ];
        };
      };

      services.nginx.virtualHosts."incus.${config.ro.domain}" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "https://127.0.0.1:9999";
          proxyWebsockets = true;
        };
      };

      services.dex.settings.staticClients = [
        {
          id = "incus";
          redirectURIs = [
            "https://incus.${config.ro.domain}/oidc/callback"
          ];
          name = "Incus";
          public = true;
        }
      ];
    };
}
