{
  flake.modules.nixos.postgres = {
    services.postgresql = {
      enable = true;
    };
  };
}
