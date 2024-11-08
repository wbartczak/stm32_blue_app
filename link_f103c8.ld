

ENTRY(_reset)
EXTERN(_vectors)

MEMORY
{
    RAM (rwx)  : ORIGIN = 0x20000000, LENGTH = 20K
    FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 128K
}


SECTIONS
{
    PROVIDE(_stack_top = ORIGIN(RAM) + LENGTH(RAM));
    
    .text : {
        *(.text.isr)
        *(.text.startup)
        *(.text)
        *(.text*)
        *(.glue_7)
        *(.glue_7t)
        *(.eh_frame)

        KEEP(*(.init))
        KEEP(*(.fini))

        PROVIDE(_etext = .);
    } > FLASH

    .rodata : {
        . = ALIGN(4);
        
        *(.rodata)
        *(.rodata*)
        
        . = ALIGN(4);
    } > FLASH

    .preinit_array : {
        . = ALIGN(4);

        PROVIDE(__preinit_array_start = .);
        KEEP(*(.preinit_array))
        PROVIDE(__preinit_array_end = .);
    } > FLASH

    .init_array : {
        . = ALIGN(4);

        PROVIDE(__init_array_start = .);
        KEEP (*(SORT(.init_array.*)))
        KEEP (*(.init_array))
        PROVIDE(__init_array_end = .);
    } > FLASH

    .fini_array : {
        . = ALIGN(4);
  
        PROVIDE(__fini_array_start = .);
        KEEP (*(.fini_array))
        KEEP (*(SORT(.fini_array.*)))
        PROVIDE(__fini_array_end = .);
    } > FLASH


    .ARM.extab : {
        . = ALIGN(4);
        *(.ARM.extab*)
    } > FLASH

    .ARM.exidx : {
        . = ALIGN(4);
        PROVIDE(__exidx_start = .);
        *(.ARM.exidx*)
        PROVIDE(__exidx_end = .);
    } > FLASH

    .shstrtab : {
        *(.shstrtab)
        *(.shstrtab*)
    } > RAM

    .shstrtab (NOLOAD) : {
        *(.shstrtab)
        *(.shstrtab*)
    } > RAM

    .strtab (NOLOAD) : {
        *(.strtab)
        *(.strtab*)
    } > RAM

    .noinit (NOLOAD) : {
        *(.noinit)
    } > RAM

    .data : {
        . = ALIGN(4);
        PROVIDE(_sdata = .);

        *(.data)
        *(.data*)
        *(.ramtext*)

        . = ALIGN(4);
        PROVIDE(_edata = .);
    } > RAM AT> FLASH

    PROVIDE(_data_ladr = LOADADDR(.data));

    .bss (NOLOAD) : {
        . = ALIGN(4);

        PROVIDE(_sbss = .);

        *(.bss)
        *(.bss*)
        *(COMMON)

        . = ALIGN(4);
        PROVIDE(_ebss = .);
    } > RAM

    .ARM.attributes 0 : {
         *(.ARM.attributes)
    }

    /* Guidelines regarding debugging code. */
    .debug 0 : {
        *(.debug)
    }

    .line 0 : {
        *(.line)
    }

    .debug_pubnames 0 : {
        *(.debug_pubnames)
    }

    .debug_aranges 0 : {
        *(.debug_aranges)
    }

    .stab 0 : {
        *(.stab)
    }

    .stabstr 0 : {
        *(.stabstr)
    }

    .debug_info 0 : {
        *(.debug_info)
    }

    .debug_line 0 : {
        *(.debug_line)
    }

    .debug_line_str 0 : {
        *(.debug_line_str)
        *(.debug_line_str*)
    }

    .debug_macinfo 0 : {
        *(.debug_macinfo)
    }

    .debug_frame 0 : {
        *(.debug_frame)
    }

    .debug_abbrev 0 : {
        *(.debug_abbrev)
    }

    .debug_str 0 : {
        *(.debug_str)
    }

    /DISCARD/ : {
        *(*)
    }
}


