{
  description = "Python dev shell for using uv venvs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        python = pkgs.python311;
      in {
        devShells.default =
          let base = pkgs.appimageTools.defaultFhsEnvArgs;
          in (pkgs.buildFHSEnv (base // {
            name = "FHS";
            targetPkgs = pkgs: (with pkgs; [
              gcc glibc zlib
              python3
              python3Packages.uv
              git-lfs
              screen
              bashInteractive
              tmux
            ]);
            runScript = "bash $@";
            extraOutputsToInstall = [ "dev" ];
          })).env;
      });
}
