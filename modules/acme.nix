{
  flake.modules.nixos.acme-server =
    { config, ... }:
    {
      security.pki.certificateFiles = [ ../certs/root-ca.crt ];

      security.acme = {
        defaults = {
          server = "https://${config.ro.domain}:8400/acme/my-acme-provisioner/directory";

          email = "e@mail.com";
        };
        acceptTerms = true;
      };

      services.step-ca = {
        enable = true;

        port = 8400;
        address = "0.0.0.0";

        intermediatePasswordFile = "/dev/null";
        settings = {
          root = ../certs/root-ca.crt;
          crt = ../certs/intermediate-ca.crt;
          key = ../certs/intermediate-ca.key;

          dnsNames = [ config.ro.domain ];

          db = {
            type = "badgerv2";
            dataSource = "/var/lib/step-ca/db";
          };

          authority.provisioners = [
            {
              type = "ACME";
              name = "my-acme-provisioner";
            }
          ];
        };
      };
    };
}
