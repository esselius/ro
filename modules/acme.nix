{
  flake.modules.nixos.acme-server =
    { config, ... }:
    {
      security.pki.certificateFiles = [ config.ro.secrets.acme-root-cert.path ];

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

        intermediatePasswordFile = config.ro.secrets.acme-intermediate-password.path;

        settings = {
          root = config.ro.secrets.acme-root-cert.path;
          crt = config.ro.secrets.acme-intermediate-cert.path;
          key = config.ro.secrets.acme-intermediate-key.path;

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

      ro.secrets.acme-root-cert = {
        literal = builtins.readFile ../certs/root-ca.crt;
      };
      ro.secrets.acme-intermediate-cert = {
        literal = builtins.readFile ../certs/intermediate-ca.crt;
      };
      ro.secrets.acme-intermediate-key = {
        literal = builtins.readFile ../certs/intermediate-ca.key;
      };
      ro.secrets.acme-intermediate-password = {
        path = "/dev/null";
      };
    };
}
