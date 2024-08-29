{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    esp32 = pkgs.dockerTools.pullImage {
      imageName = "espressif/idf-rust";
      imageDigest = "sha256:0e1fba439a7d4cee57c5822feda8cd09ec38d55b40e402273d5c10477e53ddd4";
      sha256 = "rUumcjsV3rKmQeGpMK93srfuQpf4OMXvbqTszJa2BXg=";
      finalImageName = "espressif/idf-rust";
      finalImageTag = "all_latest";
    };
  in {
    packages.x86_64-linux.esp32 = pkgs.stdenv.mkDerivation {
      name = "esp32";
      src = esp32;
      unpackPhase = ''
        mkdir -p source
        tar -C source -xvf $src
      '';
      sourceRoot = "source";
      nativeBuildInputs = [
        pkgs.autoPatchelfHook
        pkgs.jq
      ];
      buildInputs = [
        pkgs.xz
        pkgs.zlib
        pkgs.libxml2
        pkgs.python2
        pkgs.python312Packages.find-libpython
        pkgs.libudev-zero
        pkgs.stdenv.cc.cc
      ];
      buildPhase = ''
        jq -r '.[0].Layers | @tsv' < manifest.json > layers
      '';
      installPhase = ''
        mkdir -p $out
        for i in $(< layers); do
          tar -C $out -xvf "$i" home/esp/.cargo home/esp/.rustup || true
        done
        mv -t $out $out/home/esp/{.cargo,.rustup}
        rmdir $out/home/esp
        rmdir $out/home
        # [ -d $out/.cargo ] && [ -d $out/.rustup ]
      '';
    };
  };
}
