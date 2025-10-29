{
  flake.modules.nixos.acme-server = {
    ro.secrets.intermediate_ca_key = {
      owner = "step-ca";
      literal = "xxx";
    };
    # ro.secrets.intermediate_ca_key_passphrase = {
    # owner = "step-ca";
    # };
  };
}
