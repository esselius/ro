{
  flake.modules.nixos.nginx = {
    services.nginx = {
      enable = true;

      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
      recommendedProxySettings = true;
    };
    networking.firewall.allowedTCPPorts = [ 443 ];

    virtualisation.vmVariant.virtualisation.forwardPorts = [
      {
        host.port = 443;
        guest.port = 443;
      }
    ];
  };
}
