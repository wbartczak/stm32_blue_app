.syntax unified
.thumb
.cpu cortex-m3


/* Functions provided from C */
.global main

.section .text.startup

.global _sdata
.global _edata
.global _data_ladr
.global _sbss
.global _ebss
.global _stack_top

.thumb_func
.global _reset
.type _reset, %function
_reset:
/* Ensure no interrupts during initialization */
    cpsid i

/* Copy data section initialization from flash */
    ldr     r0, =_data_ladr  /* Address of data initializers in FLASH */
    ldr     r1, =_sdata      /* Start address of data section in SRAM */
    ldr     r2, =_edata      /* End address of data section in SRAM */

_data_copy_loop:
    /* Data section has to be aligned (4 bytes) in linker script */
    cmp     r2, r1
    beq     _data_copy_loop_end
    ldr     r3, [r0]
    adds    r0, r0, #4
    str     r3, [r1]
    adds    r1, r1, #4
    cmp     r2, r1
    bne     _data_copy_loop

_data_copy_loop_end:
/* Zero bss section */
    ldr     r0, =_sbss
    ldr     r1, =_ebss
    movs    r2, #0
    cmp     r1, r0
    beq     _bss_zero_loop_end

_bss_zero_loop:
    str     r2, [r0]
    adds    r0, r0, #4
    cmp     r1, r0
    bne     _bss_zero_loop

_bss_zero_loop_end:
/* Setup system stack */
    ldr     r1, =_stack_top
    mov     r1, sp

/* Now we can freely call C code */
    bl      main        /* Call application */

_dead_loop:  /* Just in case we ever leaved main() */
    b       _dead_loop
.size _reset, . - _reset


/** Default handler for interrupts */
.thumb_func
.global DefHandler
.type DefHandler, %function
DefHandler:
    b       DefHandler

.size DefHandler, . - DefHandler


.section .text.isr, "ax", %progbits

.type _vectors, %object
.global _vectors
_vectors:
    .long   _stack_top
    .long   _reset
    .long   HandlerNMI           /* NMI exception */
    .long   HandlerHardFault     /* HardFault exception */
    .long   HandlerMMFault       /* Memory management fault */
    .long   HandlerBusFault      /* Bus fault */
    .long   HandlerUsageFault    /* Usage fault */
    .long   0
    .long   0
    .long   0
    .long   0
    .long   HandlerSVC          /* SVC exception */
    .long   HandlerDBGMon        /* Debug monitor */
    .long   0
    .long   HandlerPendSV       /* PendSV exceotion */
    .long   HandlerSysTick      /* Systick intr */

/* Peripherals interrupts, offset 0x40 */
    .long   HandlerWDG         /* WDG intr */
    .long   HandlerPVD         /* PVD intr */
    .long   HandlerTST         /* Tamper and TimeStamp intr */
    .long   HandlerRTC         /* RTC intr */
    .long   HandlerFlash       /* FLASH intr */
    .long   HandlerRCC         /* RCC intr */
    .long   HandlerEXTI0       /* EXTI0 */
    .long   HandlerEXTI1       /* EXTI1 */
    .long   HandlerEXTI2       /* EXTI2 */
    .long   HandlerEXTI3       /* EXTI3 */
    .long   HandlerEXTI4       /* EXTI4 */
    .long   HandlerDMA11       /* DMA1 ch1 */
    .long   HandlerDMA12       /* DMA1 ch2 */
    .long   HandlerDMA13       /* DMA1 ch3 */
    .long   HandlerDMA14       /* DMA1 ch4 */
    .long   HandlerDMA15       /* DMA1 ch5 */
    .long   HandlerDMA16       /* DMA1 ch6 */
    .long   HandlerDMA17       /* DMA1 ch7 */
    .long   HandlerADC         /* ADC */
    .long   HandlerCANTx       /* CAN_TX intr */
    .long   HandlerCANRx0      /* CAN_RX0 intr */
    .long   HandlerCANRx1      /* CAN_RX1 intr */
    .long   HandlerCANSCE      /* CAN_SCE intr */
    .long   HandlerEXTI9_5     /* EXTI line [9:5] */
    .long   HandlerTIM1_BRK    /* TIM1_BRK / TIM15 */
    .long   HandlerTIM1_UP     /* TIM1_UP  / TIM16 */
    .long   HandlerTIM1_COM    /* TIM1_COM  / TIM17 */
    .long   HandlerTIM1_CC     /* TIM1_CC */
    .long   HandlerTIM2        /* TIM2 */
    .long   HandlerTIM3        /* TIM3 */
    .long   HandlerTIM4        /* TIM4 */
    .long   HandlerI2C1_EV     /* I2C1 event intr & exti line 23 intr  */
    .long   HandlerI2C1_ER     /* I2C1 error intr */
    .long   HandlerI2C2_EV
    .long   HandlerI2C2_ER
    .long   HandlerSPI1        /* SPI1  */
    .long   HandlerSPI2        /* SPI2  */
    .long   HandlerUSART1      /* USART1 */
    .long   HandlerUSART2      /* USART2 */
    .long   HandlerUSART3      /* USART3 */
    .long   HandlerEXTI15_10   /* EXTI line [15:10] */
    .long   HandlerRTCAlarm    /* RTC Alarm */
    .long   HandlerOTG_FS_WKUP  /* USB On-the-Go FS wakeup */
    .long   0
    .long   0
    .long   0
    .long   0
    .long   0
    .long   0
    .long   0
    .long   HandlerTIM5
    .long   HandlerSPI3
    .long   HandlerUART4
    .long   HandlerUART5
    .long   HandlerTIM6         /* TIM6 */
    .long   HandlerTIM7         /* TIM7 */
    .long   HandlerDMA21
    .long   HandlerDMA22
    .long   HandlerDMA23
    .long   HandlerDMA24
    .long   HandlerDMA25
    .long   HandlerETH
    .long   HandlerETH_WKUP
    .long   HandlerCAN2TX
    .long   HandlerCAN2RX0
    .long   HandlerCAN2RX1
    .long   HandlerCAN2SCE
    .long   HandlerOTG_FS
.size _vectors, . - _vectors

/* Define default handler for all handlers */

    /* NMI exception */
    .weak HandlerNMI
    .set  HandlerNMI, DefHandler

    /* Hard fault exceprion */
    .weak HandlerHardFault
    .set  HandlerHardFault, DefHandler

    /* Memory management fault exception */
    .weak   HandlerMMFault
    .set  HandlerMMFault, DefHandler

    /* Bus fault exception */
    .weak   HandlerBusFault
    .set  HandlerBusFault, DefHandler

    /* Usage fault exception */
    .weak   HandlerUsageFault
    .set  HandlerUsageFault, DefHandler

    /* SVC */
    .weak HandlerSVC
    .set  HandlerSVC, DefHandler

    /* Debug monitor */
    .weak HandlerDBGMon
    .set HandlerDBGMon,DefHandler

    /* PendSV */
    .weak HandlerPendSV
    .set  HandlerPendSV, DefHandler

    /* SysTick */
    .weak HandlerSysTick
    .set  HandlerSysTick, DefHandler

/* General peripherals */

    /* Windows Watchdog */
    .weak HandlerWDG
    .set  HandlerWDG, DefHandler

    /* PVD */
    .weak HandlerPVD
    .set  HandlerPVD, DefHandler

    /* Tamper and TimeStamp */
    .weak HandlerTST
    .set  HandlerTST, DefHandler

    /* Real-time clock */
    .weak HandlerRTC
    .set  HandlerRTC, DefHandler

    /* Flash memory and EEPROM */
    .weak HandlerFlash
    .set  HandlerFlash, DefHandler

    /* Reset control and Clock, Clock recovery system */
    .weak HandlerRCC
    .set  HandlerRCC, DefHandler

    /* Extended interrupt and event controller, line 0 and line 1 */
    .weak HandlerEXTI0
    .set  HandlerEXTI0, DefHandler

    /* Extended interrupt and event controller, line 2 and line 3 */
    .weak HandlerEXTI1
    .set  HandlerEXTI1, DefHandler

    /* Extended interrupt and event controller, line 4 to line 15 */
    .weak HandlerEXTI2
    .set  HandlerEXTI2, DefHandler

    /* Extended interrupt and event controller */
    .weak HandlerEXTI3
    .set  HandlerEXTI3, DefHandler

    /* Extended interrupt and event controller */
    .weak HandlerEXTI4
    .set  HandlerEXTI4, DefHandler

    /* Direct memory access controller, Channel 1 */
    .weak HandlerDMA11
    .set  HandlerDMA11, DefHandler

    /* Direct memory access controller, Channel 2 */
    .weak HandlerDMA12
    .set  HandlerDMA12, DefHandler

    /* Direct memory access controller, Channel 3 */
    .weak HandlerDMA13
    .set  HandlerDMA13, DefHandler

    /* Direct memory access controller, Channel 4 */
    .weak HandlerDMA14
    .set  HandlerDMA14, DefHandler

    /* Direct memory access controller, Channel 5 */
    .weak HandlerDMA15
    .set  HandlerDMA15, DefHandler

    /* Direct memory access controller, Channel 6 */
    .weak HandlerDMA16
    .set  HandlerDMA16, DefHandler

    /* Direct memory access controller, Channel 7 */
    .weak HandlerDMA17
    .set  HandlerDMA17, DefHandler

    /* ADC */
    .weak HandlerADC
    .set  HandlerADC, DefHandler

    /* CAN Tx */
    .weak HandlerCANTx
    .set  HandlerCANTx, DefHandler

    /* CAN Rx0 */
    .weak HandlerCANRx0
    .set  HandlerCANRx0, DefHandler

    /* CAN RX1 */
    .weak HandlerCANRx1
    .set  HandlerCANRx1, DefHandler

    /* CAN SCE */
    .weak HandlerCANSCE
    .set  HandlerCANSCE, DefHandler

    /* Extended interrupt and event controller */
    .weak HandlerEXTI9_5
    .set  HandlerEXTI9_5, DefHandler

    /* Timer1 BRK or TIM15 */
    .weak HandlerTIM1_BRK
    .set  HandlerTIM1_BRK, DefHandler

    /* Timer1 UP or TIM16 */
    .weak HandlerTIM1_UP
    .set  HandlerTIM1_UP, DefHandler

    /* Timer1 COM or TIM17 */
    .weak HandlerTIM1_COM
    .set  HandlerTIM1_COM, DefHandler

    /* Timer1 CC */
    .weak HandlerTIM1_CC
    .set  HandlerTIM1_CC, DefHandler

    /* General purpose timer 2 */
    .weak HandlerTIM2
    .set  HandlerTIM2, DefHandler

    /* General purpose timer 3 */
    .weak HandlerTIM3
    .set  HandlerTIM3, DefHandler

    /* General purpose timer 4 */
    .weak HandlerTIM4
    .set  HandlerTIM4, DefHandler

    /* I2C1 event */
    .weak HandlerI2C1_EV
    .set  HandlerI2C1_EV, DefHandler

    /* I2C1 error */
    .weak HandlerI2C1_ER
    .set  HandlerI2C1_ER, DefHandler

    /* I2C2 event */
    .weak HandlerI2C2_EV
    .set  HandlerI2C2_EV, DefHandler

    /* I2C2 error */
    .weak HandlerI2C2_ER
    .set  HandlerI2C2_ER, DefHandler

    /* SPI interface 1 */
    .weak HandlerSPI1
    .set  HandlerSPI1, DefHandler

    /* SPI interface 2 */
    .weak HandlerSPI2
    .set  HandlerSPI2, DefHandler

    /* USART1 */
    .weak HandlerUSART1
    .set  HandlerUSART1, DefHandler

    /* USART2 */
    .weak HandlerUSART2
    .set  HandlerUSART2, DefHandler

    /* USART3 */
    .weak HandlerUSART3
    .set  HandlerUSART3, DefHandler

    /* Extended interrupt and event controller */
    .weak HandlerEXTI15_10
    .set  HandlerEXTI15_10, DefHandler

    /* Real-time clock alarm */
    .weak HandlerRTCAlarm
    .set  HandlerRTCAlarm, DefHandler

    /* USB On-the-Go wakeup */
    .weak HandlerOTG_FS_WKUP
    .set  HandlerOTG_FS_WKUP, DefHandler

    /* General purpose timer 5 */
    .weak HandlerTIM5
    .set  HandlerTIM5, DefHandler

    /* SPI interface 3 */
    .weak HandlerSPI3
    .set  HandlerSPI3, DefHandler

    /* UART4 */
    .weak HandlerUART4
    .set  HandlerUART4, DefHandler

    /* UART5 */
    .weak HandlerUART5
    .set  HandlerUART5, DefHandler

    /* Basic timer 6 */
    .weak HandlerTIM6
    .set  HandlerTIM6, DefHandler

    /* Basic timer 7 */
    .weak HandlerTIM7
    .set  HandlerTIM7, DefHandler

    /* DMA 2 Ch 1 */
    .weak HandlerDMA21
    .set  HandlerDMA21, DefHandler

    /* DMA 2 Ch 2 */
    .weak HandlerDMA22
    .set  HandlerDMA22, DefHandler

    /* DMA 2 Ch 3 */
    .weak HandlerDMA23
    .set  HandlerDMA23, DefHandler

    /* DMA 2 Ch 4 */
    .weak HandlerDMA24
    .set  HandlerDMA24, DefHandler

    /* DMA 2 Ch 5 */
    .weak HandlerDMA25
    .set  HandlerDMA25, DefHandler

    /* ETH MAC */
    .weak HandlerETH
    .set  HandlerETH, DefHandler

    /* ETH MAC Wakeup*/
    .weak HandlerETH_WKUP
    .set  HandlerETH_WKUP, DefHandler

    /* CAN2 Tx */
    .weak HandlerCAN2TX
    .set  HandlerCAN2TX, DefHandler

    /* CAN 2 Rx0 */
    .weak HandlerCAN2RX0
    .set  HandlerCAN2RX0, DefHandler

    /* CAN 2 RX1 */
    .weak HandlerCAN2RX1
    .set  HandlerCAN2RX1, DefHandler

    /* CAN 2 SCE */
    .weak HandlerCAN2SCE
    .set  HandlerCAN2SCE, DefHandler

    /* USB OTG FS  */
    .weak HandlerOTG_FS
    .set  HandlerOTG_FS, DefHandler

//.section .text
//.thumb_func
//.global _get_control
//.type _get_control, %function
//_get_control:
//    mrs     r0, CONTROL
//    bx      lr
//.size _get_control, . - _get_control
