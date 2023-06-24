{
  inputs.nixpkgs.url = "nixpkgs";
  inputs.nixpkgs52.url =
    "github:nixos/nixpkgs/08adc0781104813a3d44936ab7c318b751aa43c0";

  description = "2020 qemu advent calendar";
  outputs = { self, nixpkgs, nixpkgs52, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      pkgs52 = import nixpkgs52 { inherit system; };
      day01 = with pkgs;
        stdenv.mkDerivation {
          name = "2020 qemu-advent-day01";
          src = fetchurl {
            url =
              "https://www.qemu-advent-calendar.org/2020/download/day01.tar.gz";
            hash = "sha256-joBFhVbCqibSx2r1eb9Tyme5Rgz+MiY9vARK5HnI8VU=";
          };
          patches = [ ./01patch ];

          buildPhase = "";
          buildInputs = [ qemu ];
          installPhase = ''
            mkdir -p $out
            cp -r * $out
          '';
        };

      day03 = with pkgs;
        stdenv.mkDerivation {
          name = "2020 qemu-advent-day03";
          src = fetchurl {
            url =
              "https://www.qemu-advent-calendar.org/2020/download/gw-basic.tar.xz";
            hash = "sha256-D1GSCLq7PytB1FI9i81toCbzlkZ57dA5iqHdLhx1T2U=";
          };

          patches = [ ./03patch ];
          buildInputs = [ qemu ];
          installPhase = ''
            mkdir -p $out
            cp -r * $out
          '';
        };

      day04 = with pkgs;
        stdenv.mkDerivation {
          name = "2020 qemu-advent-day04";
          src = fetchurl {
            url =
              "https://www.qemu-advent-calendar.org/2020/download/day04.tar.gz";
            hash = "sha256-toVrFbbsZxh8BdGjzKMUyetbRAu1ktk883u7in4cY68=";
          };

          patches = [ ./04patch ];
          buildInputs = [ qemu ];
          installPhase = ''
            mkdir -p $out
            cp -r * $out
          '';
        };

      day05 = with pkgs;
        stdenv.mkDerivation {
          name = "2020 qemu-advent-day05";
          src = fetchurl {
            url =
              "https://www.qemu-advent-calendar.org/2020/download/day05.tar.gz";
            hash = "sha256-ccmRndhPQFA+vaFX6AMrfWtuAS9AkHov4hrWNWuN/po=";

          };

          patches = [ ./05patch ];
          buildInputs = [ qemu ];
          installPhase = ''
            mkdir -p $out
            cp -r * $out
          '';
        };
      day06 = with pkgs;
        stdenv.mkDerivation {
          name = "2022 qemu-advent-day06";
          src = fetchurl {
            url =
              "https://www.qemu-advent-calendar.org/2020/download/day06.tar.gz";
            hash = "sha256-HkhQMv6hG/61wxV6uTQDTTCYfYLMW8kl2aKQdLc56T4=";
          };

          patches = [ ./06patch ];
          buildInputs = [ qemu ];
          installPhase = ''
            mkdir -p $out
            cp -r * $out
          '';
        };

      day07 = with pkgs;
        stdenv.mkDerivation {
          name = "2020 qemu-advent-day07";
          src = fetchurl {
            url =
              "https://www.qemu-advent-calendar.org/2020/download/day07.tar.gz";
            hash = "sha256-lnLql/1dWXvXG6ZeZAqg12WCQiacoW3G8ofgIkWVqYA=";
          };
          patches = [ ./07patch ];
          buildInputs = [ qemu ];
          installPhase = ''
            mkdir -p $out
            cp -r * $out
          '';
        };

      day08 = with pkgs;
        stdenv.mkDerivation {
          name = "2020 qemu-advent-day08";
          src = fetchurl {
            url =
              "https://www.qemu-advent-calendar.org/2020/download/day08.tar.gz";
            hash = "sha256-qR9YAIdXuwoM9sn7jVMN/eikpBvPZ4UaB+TzFtogVfo=";
          };
          patches = [ ./08patch ];
          buildInputs = [ qemu ];
          installPhase = ''
            mkdir -p $out
            cp -r * $out
          '';
        };

      day09 = with pkgs;
        stdenv.mkDerivation {
          name = "2020 qemu-advent-day09";
          src = fetchurl {
            url =
              "https://www.qemu-advent-calendar.org/2020/download/day09.tar.xz";
            hash = "sha256-DUF/WsH611fvyJhP9fH6EwcSUTR0hOinf5vL7XhilRw=";
          };
          patches = [ ];
          buildInputs = [ qemu ];
          installPhase = ''
            mkdir -p $out
            cp -r * $out
          '';
        };

      qemu-custom = with pkgs;
        stdenv.mkDerivation rec {
          pname = "qemu-custom";
          version = "1.0";

          src = fetchurl {
            url = "https://download.qemu.org/qemu-5.2.0.tar.xz";
            sha256 = "sha256-yxjYibYo++Y3ZysDJnidmw47gCfgRFuTZTfHhUnfF7w=";
          };

          buildInputs = [ coreutils glib pkg-config makeWrapper python3 ninja ];
          makeFlags = [ "TARGET_LIST=lm32-softmmu" ];

          configurePhase = ''
            ./configure --target-list=$TARGET_LIST --prefix=$out
          '';

          buildPhase = ''
            make -j $NIX_BUILD_CORES
          '';

          installPhase = ''
            make install
          '';
        };

      day11 = let
        img = pkgs.fetchurl {
          hash = "sha256-ZOI+V+/85gKzKnPRbUDQ0ZUnvdJ03IirGatoVJYr/bU=";
          url = "http://milkymist.walle.cc/updates/2012-03-01/flickernoise";
        };
      in pkgs.writeShellApplication {
        name = "milkmist";
        runtimeInputs =
          [ (pkgs52.qemu.override { hostCpuTargets = [ "lm32-softmmu" ]; }) ];
        text = ''
          qemu-system-lm32 -M milkymist -kernel ${img}
        '';
      };

      nbdkit = with pkgs;
        stdenv.mkDerivation {
          name = "nbdkit";
          src = fetchFromGitLab {
            owner = "nbdkit";
            repo = "nbdkit";
            rev = "3e4c1b79a72970c17cb42b21070e61ec634a38bb";
            hash = "sha256-5ZJSwS2crjmts5s0Rk2A+g1drXkoop6Fq/qTZcB5W6Y=";
          };
          nativeBuildInputs = [
            autoreconfHook
            pkg-config
            m4
            libtool
            automake
            autoconf
            zlib
            gnutls
            cryptsetup
            libssh
            xz
          ];
          buildPhase = "make";
          configurePhase = "./configure";
          autoreconfPhase = "autoreconf -i";
          buildInputs = [ gnutls cryptsetup ];
        };

      nbdkit2 = with pkgs;
        stdenv.mkDerivation {
          src = fetchurl {
            url =
              "https://download.libguestfs.org/nbdkit/1.34-stable/nbdkit-1.34.0.tar.gz";
            hash = "sha256-vnXnRtRTdVzvLlQuX5by8vRUP5wXRRUm5SBUXo1SlZo=";

          };
          name = "nbdkit2";
          nativeBuildInputs = [
            autoreconfHook
            pkg-config
            m4
            libtool
            automake
            autoconf
            zlib
            gnutls
            cryptsetup
            libssh
            xz
          ];
          buildInputs = [ gnutls cryptsetup ];
        };

    in {
      apps.${system} = {
        day01 = {
          program = "${day01}/run.sh";
          type = "app";
          description = "snake game in 893 bytes";
        };

        day03 = {
          program = "${day03}/run.sh";
          type = "app";
          description = "donkey bas in MSDOS basic";
        };

        day04 = {
          program = "${day04}/run.sh";
          type = "app";
          description = ''
            bootRogue, a roguelike game that fits in a boot sector
                      (511 bytes) by Oscar Toledo G.'';
        };

        day05 = {
          program = "${day05}/run.sh";
          type = "app";
          description = ''
            lights, a memory game that fits in a boot sector (512 bytes) by Oscar
                      Toledo G.'';
        };

        day06 = {
          program = "${day06}/run.sh";
          type = "app";
          description = ''
            BootMine, Bootable minesweeper game in a 512-byte boot sector by
                        BLevy'';
        };

        day07 = {
          program = "${day07}/run.sh";
          type = "app";
          description = ''
            Visopsys is a hobby graphical, network-capable
                      alternative operating system released under the GPL.'';
        };

        day08 = {
          program = "${day08}/run.sh";
          type = "app";
          description = ''
            Fountain.bin is a demo created as an entry into an irc
                      floppy assembly demo contest.'';
        };

        day09 = {
          program = "${day09}/run.sh";
          type = "app";
          description = ''
            Incredible ray-tracing demo in a QEMU "data disk" in a
                        boot loader'';
        };

        day11 = {
          program = "${day11}/bin/milkmist";
          type = "app";
          description = ''
            Say good bye to LM32 (a target that has been marked as deprecated)
                        by running the Flickernoise GUI a last time before the LM32 code
                        gets removed.'';
        };
      };

      packages.${system} = { inherit qemu-custom day11; };

      devShells.${system} = {
        inherit day11 day01 day03 day04 day05 day06 day07 day08 day09 nbdkit
          nbdkit2 qemu-custom;
      };
    };
}
