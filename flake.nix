{
  description = "A simple rust flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:

    {
      overlay = final: prev: with final; {
        hello-rs = rustPlatform.buildRustPackage {
          pname = "hello-rs";
          version = "0.1.0";
          src = ./hello-rs;
          cargoLock = {
            lockFile = ./hello-rs/Cargo.lock;
          };
        };
      };
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlay ];
        };
      in
      {
        packages = rec {
          hello-rs = pkgs.hello-rs;
          default = hello-rs;
        };
      }
    );
}
