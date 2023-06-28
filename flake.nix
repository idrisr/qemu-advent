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
      stdInstall = x@{ name, url ? "", hash ? "", ... }:
        with pkgs;
        let
          y = rec {
            inherit name;
            src = if lib.hasAttr "src" x then
              x.src
            else
              fetchurl { inherit url hash; };
            buildInputs = [ makeWrapper ];
            nativeBuildInputs = let
              l1 = [ qemusnap coreutils ];
              l2 = (lib.attrByPath [ "nativeBuildInputs" ] [ ] x);
            in lib.unique (l1 ++ l2);
            installPhase = ''
              runHook preInstall
              chmod +x run.sh
              mkdir -p $out/bin
              cp -r * $out/bin
              wrapProgram $out/bin/run.sh --set PATH "${
                lib.makeBinPath nativeBuildInputs
              }"
              runHook postInstall
            '';
          };
        in stdenv.mkDerivation (y // x);
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
      qemusnap = with pkgs;
        runCommand "test" { nativeBuildInputs = [ qemu makeWrapper ]; } ''
          mkdir -p $out/bin
          for x in ${qemu}/bin/qemu-*; do
            cp $x $out/bin
          done;
          for x in $out/bin/qemu-*; do
            wrapProgram $x --add-flags "-snapshot"
          done;
        '';
      day01 = stdInstall {
        name = "2020 qemu-advent-day01";
        url = "https://www.qemu-advent-calendar.org/2020/download/day01.tar.gz";
        hash = "sha256-joBFhVbCqibSx2r1eb9Tyme5Rgz+MiY9vARK5HnI8VU=";
      };
      day03 = stdInstall {
        name = "2020 qemu-advent-day03";
        url =
          "https://www.qemu-advent-calendar.org/2020/download/gw-basic.tar.xz";
        hash = "sha256-D1GSCLq7PytB1FI9i81toCbzlkZ57dA5iqHdLhx1T2U=";
      };
      day04 = stdInstall {
        name = "2020 qemu-advent-day04";
        url = "https://www.qemu-advent-calendar.org/2020/download/day04.tar.gz";
        hash = "sha256-toVrFbbsZxh8BdGjzKMUyetbRAu1ktk883u7in4cY68=";
        patches = [ ./patches/04patch ];
      };
      day05 = stdInstall {
        name = "2020 qemu-advent-day05";
        url = "https://www.qemu-advent-calendar.org/2020/download/day05.tar.gz";
        hash = "sha256-ccmRndhPQFA+vaFX6AMrfWtuAS9AkHov4hrWNWuN/po=";
        patches = [ ./patches/05patch ];
      };
      day06 = stdInstall {
        name = "2022 qemu-advent-day06";
        url = "https://www.qemu-advent-calendar.org/2020/download/day06.tar.gz";
        hash = "sha256-HkhQMv6hG/61wxV6uTQDTTCYfYLMW8kl2aKQdLc56T4=";
      };
      day07 = stdInstall {
        name = "2020 qemu-advent-day07";
        url = "https://www.qemu-advent-calendar.org/2020/download/day07.tar.gz";
        hash = "sha256-lnLql/1dWXvXG6ZeZAqg12WCQiacoW3G8ofgIkWVqYA=";
        patches = [ ./patches/07patch ];
      };
      day08 = stdInstall {
        name = "2020 qemu-advent-day08";
        url = "https://www.qemu-advent-calendar.org/2020/download/day08.tar.gz";
        hash = "sha256-qR9YAIdXuwoM9sn7jVMN/eikpBvPZ4UaB+TzFtogVfo=";
        patches = [ ./patches/08patch ];
      };
      day09 = stdInstall {
        name = "2020 qemu-advent-day09";
        url = "http://www.qemu-advent-calendar.org/2020/download/day09.tar.xz";
        hash = "sha256-DUF/WsH611fvyJhP9fH6EwcSUTR0hOinf5vL7XhilRw=";
        nativeBuildInputs = [ nbdkit ];
      };
      day11 = stdInstall rec {
        name = "2020 qemu-advent-day11";
        url = "http://www.qemu-advent-calendar.org/2020/download/milky.tar.gz";
        hash = "sha256-UW6PJ5vFiOZeNiuK/g+ua66Bh3nC4+Lp3JaXvrm931o=";
        img = pkgs.fetchurl {
          hash = "sha256-ZOI+V+/85gKzKnPRbUDQ0ZUnvdJ03IirGatoVJYr/bU=";
          url = "http://milkymist.walle.cc/updates/2012-03-01/flickernoise";
        };
        patches = [ ./patches/11patch ];
        qemu52 = pkgs52.qemu.override { hostCpuTargets = [ "lm32-softmmu" ]; };
        nativeBuildInputs = [ qemu52 ];
        postInstall = ''
          wrapProgram $out/bin/run.sh --set image ${img}
        '';
      };
      day12 = stdInstall {
        name = "gameoflife";
        patches = [ ./patches/12patch ];
        src = pkgs.fetchFromGitHub {
          owner = "glitzflitz";
          repo = "gameoflife";
          rev = "ac17b5987f845f242bc7c9f8f4aea38e8a98f92f";
          hash = "sha256-LVYlVwwAWPuKpNcYDmyStlctS/OUa6wIhPXrPzBlp6A=";
        };
      };
      day13 = stdInstall {
        name = "day13";
        url = "https://www.qemu-advent-calendar.org/2020/download/day13.tar.xz";
        hash = "sha256-a8Yzob+fLaUi4fSdfDFgLaeAz+xrnqc0Igkd0V3j7F8=";
        patches = [ ./patches/13patch ];
      };
      day14 = stdInstall {
        name = "day14";
        url = "https://www.qemu-advent-calendar.org/2020/download/day14.tar.xz";
        hash = "sha256-pAAorZbNUiW1gaXxOoQhb5uIgHPkr1g1105woCMVvFM=";
        patches = [ ./patches/14patch ];
      };
      day15 = stdInstall {
        name = "day15";
        url = "https://www.qemu-advent-calendar.org/2020/download/day15.tar.gz";
        hash = "sha256-+jx/hTex1iLvLeUUBNyT49GPRZg3Vg6E+uSgDNmUYuQ=";
        patches = [ ./patches/15patch ];
      };
      day16 = stdInstall {
        name = "day16";
        url = "https://www.qemu-advent-calendar.org/2020/download/day16.tar.gz";
        hash = "sha256-p333yL8t5GGw8zvadWz2fDFEMMJ45049QYEPIYSSdug=";
        img = pkgs.fetchurl {
          url = "https://eldondev.com/openwrt-privoxy-qcow.img";
          hash = ""; # fails as img no longer available
        };
      };
      day17 = stdInstall {
        name = "day17";
        url = "https://www.qemu-advent-calendar.org/2020/download/day17.tar.gz";
        hash = "sha256-UlJGX1hUpDkD6s+3KC50cOYGPu06diSraNl3L2rhqEE=";
      };
      day18 = stdInstall {
        name = "day18";
        url = "http://www.qemu-advent-calendar.org/2020/download/day18.tar.gz";
        hash = "sha256-kulrXZ29fLHAHltSY2sXOXBvbzCUOX5kvfzKivcHjmU=";
        patches = [ ./patches/18patch ];
      };
      day19 = stdInstall {
        name = "day19";
        url = "https://www.qemu-advent-calendar.org/2020/download/day19.tar.gz";
        hash = "sha256-hfx891OeYSjy0+aaQrVkxvKgM2483yR73ldRrLAvfZ0=";
        patches = [ ./patches/19patch ];
      };
      day20 = stdInstall {
        name = "day20";
        url = "https://www.qemu-advent-calendar.org/2020/download/day20.tar.gz";
        hash = "sha256-yzMh37u97W/YuCztRAN9lHqBCn4CreVdynAKNAd5q6c=";
      };
      day21 = stdInstall {
        name = "day21";
        url = "https://www.qemu-advent-calendar.org/2020/download/day21.tar.gz";
        hash = "sha256-MNXqSjn3L1EKZszREibmTov/MnjKGtHNh6YjbkTgP8I=";
        patches = [ ./patches/21patch ];
        # todo fix error - qemu: linux kernel too old to load a ram disk
      };
      day22 = stdInstall {
        name = "day22";
        url = "https://www.qemu-advent-calendar.org/2020/download/day22.tar.xz";
        hash = "sha256-cQMahfdaW4RgngFEGUtK6Z576wpU5ZLb6FtrOwjY4W4=";
        patches = [ ./patches/22patch ];
      };
      day23 = stdInstall {
        name = "day23";
        url = "https://www.qemu-advent-calendar.org/2020/download/day23.tar.gz";
        hash = "sha256-rzmEOfUAuq9oyPD0AEXR+4YGh++vV7KxZnrxvzhzLUs=";
      };
      day24 = stdInstall {
        name = "day24";
        url = "https://www.qemu-advent-calendar.org/2020/download/hippo.tar.gz";
        hash = "sha256-I1GEAUEpq4BnWwQDpexBGVBGuuB/IGSgR5zFfoNyfEg=";
      };

    in {
      checks."${system}" = { inherit day01; };

      apps.${system} = {
        qemusnap = {
          type = "app";
          program = "${qemusnap}/bin/yo";
        };
        day01 = makeapp "${day01}";
        # day02 intentionally missing
        day03 = makeapp "${day03}";
        day04 = makeapp "${day04}";
        day05 = makeapp "${day05}";
        day06 = makeapp "${day06}";
        day07 = makeapp "${day07}";
        day08 = makeapp "${day08}";
        day09 = makeapp "${day09}";
        # day10 intentionally missing
        day11 = makeapp "${day11}";
        day12 = makeapp "${day12}";
        day13 = makeapp "${day13}";
        day14 = makeapp "${day14}";
        day15 = makeapp "${day15}";
        day16 = makeapp "${day16}"; # broken
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
