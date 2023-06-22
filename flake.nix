{
  inputs.nixpkgs.url = "nixpkgs";
  description = "2020 qemu advent calendar";
  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
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

    in {
      apps.${system} = {
        day01 = {
          program = "${day01}/run.sh";
          type = "app";
          description = "snake game";
        };
        day03 = {
          program = "${day03}/run.sh";
          type = "app";
        };
      };

      devShells.${system} = { inherit day01 day03; };
    };
}
