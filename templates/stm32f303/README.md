# STM32F303RB template for OTX Maestro

Uses Meson, ARM GCC and OpenOCD. Requires the OTX Maestro extension changes
for optional `Creator: postbuild` and `project.sourceFolders`.

## Project configuration

Existing metadata stays at the top level of `.vscode/project.json`. Scan settings
are grouped under `project`:

```json
{
    "version": "1.0.0",
    "updatePackage": "https://raw.githubusercontent.com/onethinx/Maestro-lib/main/templates/stm32f303/.vscode/update.json",
    "excludeFiles": ["meson.build", ".vscode/tasks.json", ".vscode/brd.cfg", ".vscode/settings.json"],
    "project": {
        "sourceFolders": [
            "Core",
            "Drivers/STM32F3xx_HAL_Driver",
            "Drivers/CMSIS/Include",
            "Drivers/CMSIS/Device/ST/STM32F3xx/Include"
        ]
    }
}
```

Paths are relative to the workspace, include subfolders and are literal paths,
not glob patterns. Every configured folder must exist. The existing scanner
collects `.c` files and directories containing `.h` files; overlapping roots are
deduplicated. Without `project.sourceFolders`, it uses `["source"]` as before.
Both Clean-Reconfigure and Build read the configuration again and update the
existing marker blocks. No project-type switch or new dependency is needed.

Startup assembly remains explicitly listed in `meson.build`. That file also
filters Cube's `*_template.c` files and the alternative legacy HAL driver folder
out of the compiled sources. This template targets C firmware; the scanner does
not automatically include C++ or assembly.

## Migrating a project

1. Install/build the updated OTX Maestro extension with its existing dependencies.
2. Copy this template's `.vscode` directory, `meson.build` and `cross_gcc.build`
   into a copy of your STM32 project. Keep your application, HAL/CMSIS files,
   startup file and linker script. They are not supplied by this template.
3. Adjust `project.sourceFolders` to the existing project layout. For the
   YC068 project, also add `Drivers/ProgrammerLib` to scan that project's library.
4. Check these defaults in `meson.build` against your board:
   - device define `STM32F303xC` (also used for STM32F303RB);
   - startup `startup/startup_stm32f303xc.s`;
   - linker script `STM32F303RB_FLASH.ld` (your project's memory layout);
   - Cortex-M4, `fpv4-sp-d16`, hard-float ABI.
5. Put `meson`, `ninja`, `arm-none-eabi-gcc`, `arm-none-eabi-gdb` and the other
   ARM GNU tools, plus `openocd`, on VS Code's PATH. Restart VS Code after changing
   PATH. The Maestro tools bundle's `bin`, `gcc-arm/bin` and `openocd/bin`
   directories can provide these tools. Absolute executable paths may instead
   be set in `tasks.json`, `cross_gcc.build` and `launch.json`.
6. Run **Configure**, then **Build** from Maestro's status bar. For a changed
   startup file, toolchain or linker settings, run Configure again.
7. Connect the probe and use **Debug** or **Program**. The default is ST-Link
   using OpenOCD's native `stlink-dap.cfg` driver and `target/stm32f3x.cfg`.
   Select another supported SWD probe with **Programmer**. Adapt reset wiring
   in `brd.cfg` as needed; the default does not require NRST.

The template omits `Creator: postbuild`, so the extension skips `.cydsn`
detection and Creator preparation. Outputs are `build/firmware.elf`, `.hex`,
`.bin`, `.map` and `compile_commands.json` for IntelliSense.

**Program** reuses the existing launch command and prelaunch build hook, then
asks OpenOCD to program, verify and reset the target. For command-line programming
of an already built ELF, run:

```sh
openocd -f .vscode/brd.cfg -c "program {build/firmware.elf} verify reset exit"
```

Use matching OpenOCD binaries and scripts. For a separate script installation,
set `searchDir` in both launch configurations (or pass `-s` on the command line).
The native ST-Link driver requires ST-Link/V2 with compatible firmware or newer.

## Updating and validation

Publish the template at `templates/stm32f303` before using its update URL.
The extension now reads the version alongside that template's `update.json`.
The existing updater still requires the Maestro tools bundle. Project-specific
files listed in `excludeFiles` are preserved; the updater only changes the
version in an existing `project.json`, retaining `project.sourceFolders`.

Validated with TypeScript compilation, scanner/configuration regression checks,
and a separate minimal firmware using the F303 project's HAL, CMSIS, startup and
linker script with ARM GCC 13.3.1 and Meson 1.12.1. ELF, HEX and BIN were generated.
That minimal fixture emitted newlib syscall-stub and linker RWX-segment warnings.
The OpenOCD configuration passed parsing with native ST-Link selected and an
immediate shutdown before connecting to hardware. Physical programming and
debugging remain to be tested on the board; the YC068 application was not migrated.
