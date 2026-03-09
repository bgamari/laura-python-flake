{
  description = "Python dev shell for using uv venvs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    nix-gl-host.url = "github:numtide/nix-gl-host";
  };

  outputs = { self, nixpkgs, flake-utils, nix-gl-host }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfreePredicate = pkg: true;
            #pkgs.lib.strings.hasInfix "cuda" (pkgs.lib.getName pkg);
        };
        python = pkgs.python311;
        pythonEnv =
          pkgs.python3.withPackages (ps: [
          ]);
      in {
        devShells.default =
          pkgs.mkShell {
            name = "python-dev";
            packages = with pkgs; [
              pythonEnv
              python3Packages.uv
              git-lfs
              screen
              bashInteractive
              tmux

              cudaPackages.cudatoolkit
              cudaPackages.cudnn
              nix-gl-host.defaultPackage.${system}

              stdenv.cc.cc.lib
            ];
            shellHook = ''
              export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH"
            '';
          };
      });
}
