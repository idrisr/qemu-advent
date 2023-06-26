{
  inputs.nixpkgs.url = "nixpkgs";

  # latest qemu with support of lm32
  inputs.nixpkgs52.url =
    "github:nixos/nixpkgs/08adc0781104813a3d44936ab7c318b751aa43c0";

  description = "2020 qemu advent calendar";
  outputs = { self, nixpkgs, nixpkgs52, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      pkgs52 = import nixpkgs52 { inherit system; };
      makeapp = day: {
        program = "${day}/bin/run.sh";
        type = "app";
      };

      day01 = with pkgs;
        stdenv.mkDerivation rec {
          name = "2020 qemu-advent-day01";
          src = fetchurl {
            url =
              "https://www.qemu-advent-calendar.org/2020/download/day01.tar.gz";
            hash = "sha256-joBFhVbCqibSx2r1eb9Tyme5Rgz+MiY9vARK5HnI8VU=";
          };
          patches = [ ./01patch ];
          buildInputs = [ makeWrapper ];
          nativeBuildInputs = [ qemu ];
          installPhase = ''
            mkdir -p $out/bin
            cp -r * $out/bin
            wrapProgram $out/bin/run.sh \
            --prefix PATH : "${lib.makeBinPath nativeBuildInputs}"
          '';
        };

      day03 = with pkgs;
        stdenv.mkDerivation rec {
          name = "2020 qemu-advent-day03";
          src = fetchurl {
            url =
              "https://www.qemu-advent-calendar.org/2020/download/gw-basic.tar.xz";
            hash = "sha256-D1GSCLq7PytB1FI9i81toCbzlkZ57dA5iqHdLhx1T2U=";
          };
          patches = [ ./03patch ];
          buildInputs = [ makeWrapper ];
          nativeBuildInputs = [ qemu ];
          installPhase = ''
            mkdir -p $out/bin
            cp -r * $out/bin
            wrapProgram $out/bin/run.sh \
              --prefix PATH : "${lib.makeBinPath nativeBuildInputs}"
          '';
        };

      day04 = with pkgs;
        stdenv.mkDerivation rec {
          name = "2020 qemu-advent-day04";
          src = fetchurl {
            url =
              "https://www.qemu-advent-calendar.org/2020/download/day04.tar.gz";
            hash = "sha256-toVrFbbsZxh8BdGjzKMUyetbRAu1ktk883u7in4cY68=";
          };
          patches = [ ./04patch ];
          buildInputs = [ makeWrapper ];
          nativeBuildInputs = [ qemu ];
          installPhase = ''
            mkdir -p $out/bin
            cp -r * $out/bin
            wrapProgram $out/bin/run.sh \
              --prefix PATH : "${lib.makeBinPath nativeBuildInputs}"
          '';
        };

      day05 = with pkgs;
        stdenv.mkDerivation rec {
          name = "2020 qemu-advent-day05";
          src = fetchurl {
            url =
              "https://www.qemu-advent-calendar.org/2020/download/day05.tar.gz";
            hash = "sha256-ccmRndhPQFA+vaFX6AMrfWtuAS9AkHov4hrWNWuN/po=";

          };
          patches = [ ./05patch ];
          buildInputs = [ makeWrapper ];
          nativeBuildInputs = [ qemu ];
          installPhase = ''
            mkdir -p $out/bin
            cp -r * $out/bin
            wrapProgram $out/bin/run.sh \
              --prefix PATH : "${lib.makeBinPath nativeBuildInputs}"
          '';
        };

      day06 = with pkgs;
        stdenv.mkDerivation rec {
          name = "2022 qemu-advent-day06";
          src = fetchurl {
            url =
              "https://www.qemu-advent-calendar.org/2020/download/day06.tar.gz";
            hash = "sha256-HkhQMv6hG/61wxV6uTQDTTCYfYLMW8kl2aKQdLc56T4=";
          };
          patches = [ ./06patch ];
          buildInputs = [ makeWrapper ];
          nativeBuildInputs = [ qemu ];
          installPhase = ''
            mkdir -p $out/bin
            cp -r * $out/bin
            wrapProgram $out/bin/run.sh \
              --prefix PATH : "${lib.makeBinPath nativeBuildInputs}"
          '';
        };

      day07 = with pkgs;
        stdenv.mkDerivation rec {
          name = "2020 qemu-advent-day07";
          src = fetchurl {
            url =
              "https://www.qemu-advent-calendar.org/2020/download/day07.tar.gz";
            hash = "sha256-lnLql/1dWXvXG6ZeZAqg12WCQiacoW3G8ofgIkWVqYA=";
          };
          patches = [ ./07patch ];
          buildInputs = [ makeWrapper ];
          nativeBuildInputs = [ qemu ];
          installPhase = ''
            mkdir -p $out/bin
            cp -r * $out/bin
            wrapProgram $out/bin/run.sh \
              --prefix PATH : "${lib.makeBinPath nativeBuildInputs}"
          '';
        };

      day08 = with pkgs;
        stdenv.mkDerivation rec {
          name = "2020 qemu-advent-day08";
          src = fetchurl {
            url =
              "https://www.qemu-advent-calendar.org/2020/download/day08.tar.gz";
            hash = "sha256-qR9YAIdXuwoM9sn7jVMN/eikpBvPZ4UaB+TzFtogVfo=";
          };
          patches = [ ./08patch ];
          buildInputs = [ makeWrapper ];
          nativeBuildInputs = [ qemu ];
          installPhase = ''
            mkdir -p $out/bin
            cp -r * $out/bin
            wrapProgram $out/bin/run.sh \
              --prefix PATH : "${lib.makeBinPath nativeBuildInputs}"
          '';
        };

      day09 = with pkgs;
        stdenv.mkDerivation rec {
          nbdkit = with pkgs;
            stdenv.mkDerivation {
              name = "nbdkit";
              src = fetchFromGitLab {
                owner = "nbdkit";
                repo = "nbdkit";
                rev = "3e4c1b79a72970c17cb42b21070e61ec634a38bb";
                hash = "sha256-5ZJSwS2crjmts5s0Rk2A+g1drXkoop6Fq/qTZcB5W6Y=";
              };
              autoreconfPhase = "autoreconf -i";
              configureFlags = [
                "--without-manpages"
                "--without-ssh"
                "--without-gnutls"
                "--disable-perl"
              ];
              postPatch = "patchShebangs .";
              nativeBuildInputs =
                [ autoconf automake autoreconfHook libtool pkg-config python3 ];
            };

          name = "2020 qemu-advent-day09";
          src = fetchurl {
            url =
              "http://www.qemu-advent-calendar.org/2020/download/day09.tar.xz";
            hash = "sha256-DUF/WsH611fvyJhP9fH6EwcSUTR0hOinf5vL7XhilRw=";
          };
          buildInputs = [ makeWrapper ];
          nativeBuildInputs = [ nbdkit qemu ];
          installPhase = ''
            mkdir -p $out/bin
            cp -r * $out/bin
            wrapProgram $out/bin/run.sh \
              --prefix PATH : "${lib.makeBinPath nativeBuildInputs}"
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

      day12 = with pkgs;
        stdenv.mkDerivation rec {
          name = "gameoflife";
          src = fetchFromGitHub {
            owner = "glitzflitz";
            repo = "gameoflife";
            rev = "ac17b5987f845f242bc7c9f8f4aea38e8a98f92f";
            hash = "sha256-LVYlVwwAWPuKpNcYDmyStlctS/OUa6wIhPXrPzBlp6A=";
          };
          cargoHash = "sha256-yBoaLqynvYC9ebC0zjd2FmSSd53xzn4ralihtCFubAw=";
          buildInputs = [ makeWrapper ];
          nativeBuildInputs = [ qemu ];
          postPatch = ''
            substituteInPlace ./run.sh \
            --replace \
            file=gameoflife.bin \
            file=\"$out/share/gameoflife.bin\"
          '';
          patches = [ ./09patch ];
          installPhase = ''
            mkdir -p $out/bin
            mkdir -p $out/share
            mv ./gameoflife.bin $out/share
            mv ./README.md $out/bin
            mv ./run.sh $out/bin
            wrapProgram $out/bin/run.sh \
              --prefix PATH : ${lib.makeBinPath nativeBuildInputs}
          '';
        };

      day13 = with pkgs;
        stdenv.mkDerivation rec {
          name = "day13";
          src = fetchurl {
            url =
              "https://www.qemu-advent-calendar.org/2020/download/day13.tar.xz";
            hash = "sha256-a8Yzob+fLaUi4fSdfDFgLaeAz+xrnqc0Igkd0V3j7F8=";
          };
          patches = [ ./13patch ];
          buildInputs = [ makeWrapper ];
          nativeBuildInputs = [ qemu ];
          installPhase = ''
            mkdir -p $out/bin
            cp run.sh $out/bin
            cp invaders.img $out/bin
            wrapProgram $out/bin/run.sh \
              --prefix PATH : "${lib.makeBinPath nativeBuildInputs}"
          '';
        };

      day14 = with pkgs;
        stdenv.mkDerivation rec {
          name = "day14";
          src = fetchurl {
            url =
              "https://www.qemu-advent-calendar.org/2020/download/day14.tar.xz";
            hash = "sha256-pAAorZbNUiW1gaXxOoQhb5uIgHPkr1g1105woCMVvFM=";
          };
          buildInputs = [ makeWrapper ];
          nativeBuildInputs = [ qemu ];
          installPhase = ''
            mkdir -p $out/{bin,share}
            substituteInPlace ./run.sh --replace file=eggos.img file=\"$out/share/eggos.img\",snapshot=on
            cp run.sh $out/bin
            cp README $out/bin
            cp eggos.img $out/share
            wrapProgram $out/bin/run.sh \
              --prefix PATH : "${lib.makeBinPath nativeBuildInputs}"
          '';
        };

      day15 = with pkgs;
        stdenv.mkDerivation rec {
          name = "day15";
          src = fetchurl {
            url =
              "https://www.qemu-advent-calendar.org/2020/download/day15.tar.gz";
            hash = "sha256-+jx/hTex1iLvLeUUBNyT49GPRZg3Vg6E+uSgDNmUYuQ=";
          };
          buildInputs = [ makeWrapper ];
          nativeBuildInputs = [ qemu ];
          installPhase = ''
            mkdir -p $out/{bin,share}
            substituteInPlace ./run.sh --replace file=snow.bin file=\"$out/share/snow.bin\",snapshot=on
            cp run.sh $out/bin
            cp README $out/bin
            cp snow.bin $out/share
            wrapProgram $out/bin/run.sh \
              --prefix PATH : "${lib.makeBinPath nativeBuildInputs}"
          '';
        };

      day16 = with pkgs;
        stdenv.mkDerivation rec {
          name = "day16";
          src = fetchurl {
            url =
              "https://www.qemu-advent-calendar.org/2020/download/day16.tar.gz";
            hash = "sha256-p333yL8t5GGw8zvadWz2fDFEMMJ45049QYEPIYSSdug=";
          };
          img = fetchurl {
            url = "https://eldondev.com/openwrt-privoxy-qcow.img";
            hash = "";
          };
          buildInputs = [ makeWrapper ];
          nativeBuildInputs = [ qemu ];
          installPhase = ''
            mkdir -p $out/{bin,share}
            substituteInPlace ./run.sh --replace \
            file=openwrt-privoxy-qcow.img \
            file=\"$out/share/openwrt-privoxy-qcow.img\",snapshot=on
            cp run.sh $out/bin
            cp README $out/bin
            cp openwrt-privoxy-qcow.img $out/share
            wrapProgram $out/bin/run.sh \
              --prefix PATH : "${lib.makeBinPath nativeBuildInputs}"
          '';
        };

      day17 = with pkgs;
        stdenv.mkDerivation rec {
          name = "day17";
          src = fetchurl {
            url =
              "https://www.qemu-advent-calendar.org/2020/download/day17.tar.gz";
            hash = "sha256-UlJGX1hUpDkD6s+3KC50cOYGPu06diSraNl3L2rhqEE=";
          };
          buildInputs = [ makeWrapper ];
          nativeBuildInputs = [ qemu ];
          installPhase = ''
            mkdir -p $out/bin
            cp * $out/bin
            wrapProgram $out/bin/run.sh \
              --prefix PATH : "${lib.makeBinPath nativeBuildInputs}"
          '';
        };

      day18 = with pkgs;
        stdenv.mkDerivation rec {
          name = "day18";
          src = fetchurl {
            url =
              "http://www.qemu-advent-calendar.org/2020/download/day18.tar.gz";
            hash = "sha256-kulrXZ29fLHAHltSY2sXOXBvbzCUOX5kvfzKivcHjmU=";
          };
          buildInputs = [ makeWrapper ];
          nativeBuildInputs = [ qemu ];

          installPhase = ''
            mkdir -p $out/{bin,share}
            substituteInPlace run.sh --replace '-hda doom.img' "-drive file=$out/share/doom.img -snapshot"
            mv doom.img $out/share/
            cp * $out/bin
            wrapProgram $out/bin/run.sh \
              --prefix PATH : "${lib.makeBinPath nativeBuildInputs}"
          '';
        };

      day19 = with pkgs;
        stdenv.mkDerivation rec {
          name = "day19";
          src = fetchurl {
            url =
              "https://www.qemu-advent-calendar.org/2020/download/day19.tar.gz";
            hash = "sha256-hfx891OeYSjy0+aaQrVkxvKgM2483yR73ldRrLAvfZ0=";
          };
          patches = [ ./19patch ];
          buildInputs = [ makeWrapper ];
          nativeBuildInputs = [ qemu ];
          installPhase = ''
            mkdir -p $out/bin
            cp * $out/bin
            wrapProgram $out/bin/run.sh \
              --prefix PATH : "${lib.makeBinPath nativeBuildInputs}"
          '';
        };

      day20 = with pkgs;
        stdenv.mkDerivation rec {
          name = "day20";
          src = fetchurl {
            url =
              "https://www.qemu-advent-calendar.org/2020/download/day20.tar.gz";
            hash = "sha256-yzMh37u97W/YuCztRAN9lHqBCn4CreVdynAKNAd5q6c=";
          };
          buildInputs = [ makeWrapper ];
          nativeBuildInputs = [ qemu ];
          installPhase = ''
            mkdir -p $out/bin
            substituteInPlace ./run.sh --replace if=floppy if=floppy,snapshot=on
            cp * $out/bin
            wrapProgram $out/bin/run.sh \
              --prefix PATH : "${lib.makeBinPath nativeBuildInputs}"
          '';
        };

      day21 = with pkgs;
        stdenv.mkDerivation rec {
          name = "day21";
          src = fetchurl {
            url =
              "https://www.qemu-advent-calendar.org/2020/download/day21.tar.gz";
            hash = "sha256-MNXqSjn3L1EKZszREibmTov/MnjKGtHNh6YjbkTgP8I=";
          };
          buildInputs = [ makeWrapper ];
          nativeBuildInputs = [ qemu ];
          installPhase = ''
            mkdir -p $out/bin
            substituteInPlace ./run.sh --replace vmlinuz "$out/bin/vmlinuz"
            substituteInPlace ./run.sh --replace initramfs.linux_amd64.cpio "$out/bin/initramfs.linux_amd64.cpio"
            cp * $out/bin
            chmod +x $out/bin/run.sh
            wrapProgram $out/bin/run.sh \
              --prefix PATH : "${lib.makeBinPath nativeBuildInputs}"
          '';
        };

      day22 = with pkgs;
        stdenv.mkDerivation rec {
          name = "day22";
          src = fetchurl {
            url =
              "https://www.qemu-advent-calendar.org/2020/download/day22.tar.xz";
            hash = "sha256-cQMahfdaW4RgngFEGUtK6Z576wpU5ZLb6FtrOwjY4W4=";
          };
          buildInputs = [ makeWrapper ];
          nativeBuildInputs = [ qemu ];
          installPhase = ''
            mkdir -p $out/bin
            substituteInPlace ./run.sh --replace ventoy.qcow2 "$out/bin/ventoy.qcow2 -snapshot"
            cp * $out/bin
            chmod +x $out/bin/run.sh
            wrapProgram $out/bin/run.sh \
              --prefix PATH : "${lib.makeBinPath nativeBuildInputs}"
          '';
        };

      day23 = with pkgs;
        stdenv.mkDerivation rec {
          name = "day23";
          src = fetchurl {
            url =
              "https://www.qemu-advent-calendar.org/2020/download/day23.tar.gz";
            hash = "sha256-rzmEOfUAuq9oyPD0AEXR+4YGh++vV7KxZnrxvzhzLUs=";
          };
          buildInputs = [ makeWrapper ];
          nativeBuildInputs = [ qemu ];
          installPhase = ''
            mkdir -p $out/bin
            substituteInPlace ./run.sh --replace 'exec $QEMU' 'exec $QEMU -snapshot'
            cp -r * $out/bin
            chmod +x $out/bin/run.sh
            wrapProgram $out/bin/run.sh \
              --prefix PATH : "${lib.makeBinPath nativeBuildInputs}"
          '';
        };

      day24 = with pkgs;
        stdenv.mkDerivation rec {
          name = "day24";
          src = fetchurl {
            url =
              "https://www.qemu-advent-calendar.org/2020/download/hippo.tar.gz";
            hash = "sha256-I1GEAUEpq4BnWwQDpexBGVBGuuB/IGSgR5zFfoNyfEg=";
          };
          buildInputs = [ makeWrapper ];
          nativeBuildInputs = [ qemu ];
          installPhase = ''
            mkdir -p $out/bin
            substituteInPlace ./run.sh --replace 'exec $QEMU' 'exec $QEMU -snapshot'
            cp -r * $out/bin
            chmod +x $out/bin/run.sh
            wrapProgram $out/bin/run.sh \
              --prefix PATH : "${lib.makeBinPath nativeBuildInputs}"
          '';
        };

    in {
      apps.${system} = {
        day01 = makeapp "${day01}";
        day03 = makeapp "${day03}";
        day04 = makeapp "${day04}";
        day05 = makeapp "${day05}";
        day06 = makeapp "${day06}";
        day07 = makeapp "${day07}";
        day08 = makeapp "${day08}";
        day09 = makeapp "${day09}";
        day11 = makeapp "${day11}";
        day12 = makeapp "${day12}";
        day13 = makeapp "${day13}";
        day14 = makeapp "${day14}";
        day15 = makeapp "${day15}";
        day16 = makeapp "${day16}";
        day17 = makeapp "${day17}";
        day18 = makeapp "${day18}";
        day19 = makeapp "${day19}";
        day20 = makeapp "${day20}";
        day21 = makeapp "${day21}";
        day22 = makeapp "${day22}";
        day23 = makeapp "${day23}";
        day24 = makeapp "${day24}";
      };
      packages.${system} = { };
      devShells.${system} = { };
    };
}
