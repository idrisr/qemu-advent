{
  inputs.nixpkgs.url = "nixpkgs";
  description = "2020 qemu advent calendar";
  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      prog = with pkgs;
        stdenv.mkDerivation {
          name = "qemu-advent-day01";
          src = fetchurl {
            url =
              "https://www.qemu-advent-calendar.org/2020/download/day01.tar.gz";
            hash = "sha256-joBFhVbCqibSx2r1eb9Tyme5Rgz+MiY9vARK5HnI8VU=";
          };

          buildPhase = "";
          buildInputs = [ qemu ];
          installPhase = ''
            mkdir -p $out
            cp run.sh $out
            cp tweetboot.img $out
            cp adv-cal.txt $out
          '';
        };

    in {
      apps.${system}.day01 = {
        program = "${prog}/run.sh";
        type = "app";
      };
    };
}
