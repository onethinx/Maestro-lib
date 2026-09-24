project('stm32f303-firmware', 'c', version: '1.0.0',
    meson_version: '>=0.60.0',
    default_options: ['buildtype=debug', 'c_std=gnu11', 'b_staticpic=false'])

# STM32F303RB: keep startup, memory layout and device define consistent.
linker_file = 'STM32F303RB_FLASH.ld'
startup_file = 'startup/startup_stm32f303xc.s'
cpu_args = ['-mcpu=cortex-m4', '-mthumb', '-mfpu=fpv4-sp-d16', '-mfloat-abi=hard']
compiler_args = cpu_args + ['-DUSE_HAL_DRIVER', '-DSTM32F303xC', '-ffunction-sections', '-fdata-sections']

include_dirs = [
# OTX_Extension_HeaderFiles_Start
# OTX_Extension_HeaderFiles_End
]

scanned_sources = [
# OTX_Extension_SourceFiles_Start
# OTX_Extension_SourceFiles_End
]

sourcefiles = [startup_file]
foreach source : scanned_sources
    # Cube's HAL templates are alternatives to application implementations.
    # Do not compile the legacy CAN driver alongside the current CAN driver.
    if not source.endswith('_template.c') and not source.startswith('Drivers/STM32F3xx_HAL_Driver/Src/Legacy/')
        sourcefiles += [source]
    endif
endforeach

firmware = executable('firmware', sourcefiles,
    name_suffix: 'elf',
    c_args: compiler_args,
    include_directories: include_dirs,
    link_args: cpu_args + [
        '-T' + meson.project_source_root() / linker_file,
        '--specs=nano.specs', '--specs=nosys.specs',
        '-Wl,--gc-sections', '-Wl,-Map=firmware.map', '-Wl,--print-memory-usage'
    ],
    link_depends: linker_file)

objcopy = find_program('arm-none-eabi-objcopy')
custom_target('firmware-hex', input: firmware, output: 'firmware.hex',
    command: [objcopy, '-O', 'ihex', '@INPUT@', '@OUTPUT@'], build_by_default: true)
custom_target('firmware-bin', input: firmware, output: 'firmware.bin',
    command: [objcopy, '-O', 'binary', '@INPUT@', '@OUTPUT@'], build_by_default: true)
