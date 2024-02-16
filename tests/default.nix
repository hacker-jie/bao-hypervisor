{
  pkgs ? import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/refs/tags/22.11.tar.gz";
    sha256 = "sha256:11w3wn2yjhaa5pv20gbfbirvjq6i3m7pqrq2msf0g7cv44vijwgw";
  }) {},
  platform ? " ",
  list_tests ? " ",
  list_suites ? " "
}:

with pkgs;

let
  packages = rec {

    # Get Platform details
    plat_cfg  = callPackage ./bao-nix/pkgs/platforms/platforms.nix{
      inherit platform;
    };
    arch = plat_cfg .platforms-arch.${platform};

    # Build toolchain
    aarch64-none-elf = callPackage ./bao-nix/pkgs/toolchains/aarch64-none-elf-11-3.nix{};

    # Build Tests Dependencies (will be deprecated)
    demos = callPackage ./bao-nix/pkgs/demos/demos.nix {};
    bao-tests = callPackage ./bao-nix/pkgs/bao-tests/bao-tests.nix {};
    tests = callPackage ./bao-nix/pkgs/tests/tests.nix {};
    baremetal = callPackage ./bao-nix/pkgs/guest/baremetal-remote-tf.nix
                { 
                  toolchain = aarch64-none-elf;
                  guest_name = "baremetal";
                  platform_cfg = plat_cfg;
                  inherit list_tests; 
                  inherit list_suites;
                  bao-tests = ./bao-tests;
                  tests_srcs = ./src;
                  testf_patch = ./baremetal.patch;
                };


    # Build Hypervisor
    bao = callPackage ./bao-nix/pkgs/bao/bao.nix 
                { 
                  toolchain = aarch64-none-elf; 
                  guest = baremetal; 
                  inherit demos; 
                  platform_cfg = plat_cfg;
                };

    # Build firmware (1/2)
    u-boot = callPackage ./bao-nix/pkgs/firmware/u-boot/u-boot.nix 
                { 
                  toolchain = aarch64-none-elf; 
                };

    # Build firmware (2/2)
    atf = callPackage ./bao-nix/pkgs/firmware/atf/atf.nix 
                { 
                  toolchain = aarch64-none-elf; 
                  inherit u-boot; 
                  inherit platform;
                };

    inherit pkgs;
  };
in
  packages

