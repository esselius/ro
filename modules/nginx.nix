{
  flake.modules.nixos.nginx = {
    services.nginx = {
      enable = true;

      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
      recommendedProxySettings = true;
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    virtualisation.vmVariant.virtualisation.forwardPorts = [
      {
        host.port = 80;
        guest.port = 80;
      }
      {
        host.port = 443;
        guest.port = 443;
      }
    ];
  };
}
