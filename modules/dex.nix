{
  flake.modules.nixos.dex =
    { config, ... }:
    {
      services.postgresql = {
        ensureUsers = [
          {
            name = "dex";
            ensureDBOwnership = true;
          }
        ];
        ensureDatabases = [ "dex" ];
      };

      services.dex = {
        enable = true;
        settings = {
          web.http = "127.0.0.1:5556";
          enablePasswordDB = true;
          storage = {
            type = "postgres";
            config.host = "/var/run/postgresql";
          };
          issuer = "https://dex.${config.ro.domain}";
          staticPasswords = [
            {
              email = "pepp@me.com";
              hash = "$2y$10$xKCCyv/gNUVze6Qbt6aZF.xHHUjMwAgk8qsSMyrloJXTtU8KStluK";
              username = "pepp";
              userID = "69036cd4-a07a-4cec-a9f2-b228c94eb3f6";
            }
          ];

        };
      };

      services.nginx.virtualHosts."dex.${config.ro.domain}" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:5556";
        };
      };
    };
}
