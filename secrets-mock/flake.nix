{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { self, nixpkgs }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.aarch64-darwin.default = pkgs.mkShell {
        buildInputs = [ pkgs.sops ];
        SOPS_AGE_KEY_FILE = ./key.txt;
      };
    };
}
