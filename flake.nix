{
  description = "Basic Dev Shell Example";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { nixpkgs, ... }: 
    let
        allSystems = [
          "x86_64-linux"
          "aarch64-linux"
          "x86_64-darwin"
          "aarch64-darwin"
        ];
        forAllSystems =
          f: nixpkgs.lib.genAttrs allSystems (system: f { pkgs = import nixpkgs { inherit system; config.allowUnfree = true; }; });
    in
   {
        devShells = forAllSystems (
          { pkgs }:
          {
            default = pkgs.mkShell {
              buildInputs = [ 
                pkgs.awscli2
                pkgs.terraform
                ];
            };
          }
        );
      };
        shellHook = ''
          echo 'You can do somethuing here before the shell starts'
        '';
}
