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
