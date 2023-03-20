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
    idf-rust = esp32.packages.x86_64-linux.esp32;
  in {
    devShells.x86_64-linux.default = pkgs.mkShell {
      buildInputs = [
        idf-rust
      ];

      shellHook = ''
        export PATH="${idf-rust}/.rustup/toolchains/esp/bin:$PATH"
        export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
      '';
    };
  };
}
```

## Getting started

Use the above flake, then follow the [Rust on ESP Book](https://esp-rs.github.io/book/writing-your-own-application/generate-project-from-template.html).

## Notes

When building from source, you need a huge amount of memory, about 36 GB.
To create temporary swap, use following commands:

```
$ fallocate -l 36G /tmp/swap; mkswap /tmp/swap; swapon /tmp/swap
```
