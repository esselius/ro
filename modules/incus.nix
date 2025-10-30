{
  flake.modules.nixos.incus =
    { config, ... }:
    {
      networking.nftables.enable = true;

      virtualisation.incus = {
        enable = true;
        ui.enable = true;
        preseed.config = {
          "core.https_address" = "127.0.0.1:9999";
          "oidc.issuer" = "https://dex.${config.ro.domain}";
          "oidc.client.id" = "incus";
        };
      };

      networking.firewall.allowedTCPPorts = [ 9999 ];

      virtualisation.vmVariant.virtualisation.forwardPorts = [
        {
          host.port = 9999;
          guest.port = 9999;
        }
      ];

      services.nginx.virtualHosts."incus.${config.ro.domain}" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "https://127.0.0.1:9999";
          proxyWebsockets = true;
        };
      };
    };
}
