{
  pkgs ? import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/refs/tags/22.11.tar.gz";
    sha256 = "sha256:11w3wn2yjhaa5pv20gbfbirvjq6i3m7pqrq2msf0g7cv44vijwgw";
  }) {},
  platform ? " ",
  bao_cfg_repo ? " ",
  bao_cfg ? " ",
  list_tests ? " ",
  list_suites ? " ",
  log_level ? " "
}:

with pkgs;

let
  packages = rec {

    system-cfg  = callPackage ../../bao-nix/pkgs/system-cfg/system-cfg.nix{
      inherit platform;
      bao-tests = ../../bao-tests;
      tests_srcs = ./src;
      baremetal_patch = ./baremetal.patch;
    };

    #Build toolchain
    toolchain = callPackage ../../bao-nix/pkgs/toolchains/${system-cfg.toolchain_name}.nix{};

    #Build guests
    guests = [
          (callPackage (../../bao-nix/pkgs/guest/baremetal-remote-tf.nix)
                  { 
                    inherit system-cfg;
                    inherit toolchain;
                    guest_name = "baremetal";
                    list_tests = "";
                    list_suites = "CPU_BOOT_CHECK";
                    inherit log_level; #maybe move to the cfg file?                    
                  }
          )
      ];

    bao_cfg_repo = ./configs;
   
    #Build Hypervisor
    bao = callPackage ../../bao-nix/pkgs/bao/bao.nix 
    { 
      inherit system-cfg;
      inherit toolchain;
      inherit bao_cfg_repo;
      inherit bao_cfg;
      inherit guests; 
    };

    # Build Firmware
    firmware = callPackage ../../bao-nix/pkgs/firmware/${platform}.nix
    {
        inherit toolchain;
        inherit platform;
    };

    inherit pkgs;
  };
in
  packages

