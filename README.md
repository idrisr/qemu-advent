# QEMU

qemu advent calendar, powered by Nix flakes

https://www.qemu-advent-calendar.org/2020/

# Running QEMU images
To run one of the images, you'll need nix installed with flakes.

Then

```
" nix run github:idrisr/qemu-advent#day<day number>
nix run github:idrisr/qemu-advent#day01
```

replace `<day-number>` with one of the supported images. Note, not all images
are included as part of this flake.  To see which ones are available, run

```
nix flake show github:idrisr/qemu-advent
```

## lessons learned
* use patches
* use prior nixpkgs for deprecated things
* download shas make things feel safer
* use nix expression language to simplify
* share nix flakes to allow easy reproduction of issue
* autoconf is a beast, but makes things easier
* read derivation expressions to find the tweak you need. often via overrides
* use `nix develop` to debug and trial run
* grep nixpkgs to find examples
* nixos discourse and nix irc is a friendly place
* get good (better) with bash as it's a strong prereq for going deeper
* watch out for shebangs. theyll blow up your build.
* even `nix develop --ignore-environment --command bash --norc` is not a pure sandbox
* beware false positives. i had qemu running as a service on my machine
    * without that it was broken
    * see makewrapper?
* string escaping between nix and bash is treacherous
* always stay aware of what's happening with $PATH. that's the whole game
* you can know nothing about a project and its language ecosystem
    * and still make a package for it
* to get command line helpers, write yet another package
