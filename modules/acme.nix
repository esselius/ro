{
  flake.modules.nixos.acme-server = {
    sops.secrets.intermediate_ca_key = {
      # owner = "step-ca";
    };
    sops.secrets.intermediate_ca_key_passphrase = {
      # owner = "step-ca";
    };
  };
}
