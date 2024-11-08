# Building

The application uses Meson as the build system.
To build the elf image you can execute following commands:
```
meson setup --cross-file cross_file.build build
cd build
ninja
```
