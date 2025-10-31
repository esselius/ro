{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    sops-nix.url = "github:Mic92/sops-nix";
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
  };

  outputs =
    inputs@{ flake-parts, import-tree, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (import-tree [
      ./modules
      ./hosts
    ]);

  nixConfig = {
    extra-substituters = [
      "https://nixos-raspberrypi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };
}
