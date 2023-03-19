# esp32

Rust with Xtensa support for Nix using flakes.

```
$ nix flake show github:knarkzel/esp32
└───packages
    └───x86_64-linux
        └───esp32: package 'esp32'
$ nix build github:knarkzel/esp32#esp32
$ ls -a result
.  ..  .cargo  .rustup
```

## Minimal example

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    esp32 = {
      url = "github:knarkzel/esp32";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    esp32,
  }: let
    pkgs = import nixpkgs {system = "x86_64-linux";};
  in {
    devShells.x86_64-linux.default = pkgs.mkShell {
      buildInputs = [
        esp32.packages.x86_64-linux.esp32
      ];
    };
  };
}
```

## Notes

When building from source, you need a huge amount of memory, about 36 GB.
