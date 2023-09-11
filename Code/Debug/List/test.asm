
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 4.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _ack=R5
	.DEF _midval=R4
	.DEF _state=R7
	.DEF _refreshFlag=R8
	.DEF _refreshFlag_msb=R9
	.DEF _temp=R10
	.DEF _temp_msb=R11
	.DEF _Lval=R12
	.DEF _Lval_msb=R13
	.DEF _rekey=R6

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  _ext_int1_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _ext_int2_isr
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0

_0x3:
	.DB  0x32
_0x4:
	.DB  0x32
_0x5:
	.DB  0x23
_0x0:
	.DB  0x4C,0x3A,0x25,0x32,0x64,0x20,0x52,0x3A
	.DB  0x25,0x32,0x64,0x20,0x54,0x3A,0x25,0x32
	.DB  0x64,0x0,0x2A,0x4C,0x3A,0x25,0x32,0x64
	.DB  0x20,0x52,0x3A,0x25,0x32,0x64,0x20,0x54
	.DB  0x3A,0x25,0x32,0x64,0x20,0x0,0x20,0x4C
	.DB  0x3A,0x25,0x32,0x64,0x2A,0x52,0x3A,0x25
	.DB  0x32,0x64,0x20,0x54,0x3A,0x25,0x32,0x64
	.DB  0x20,0x0,0x20,0x4C,0x3A,0x25,0x32,0x64
	.DB  0x20,0x52,0x3A,0x25,0x32,0x64,0x2A,0x54
	.DB  0x3A,0x25,0x32,0x64,0x20,0x0,0x20,0x4C
	.DB  0x3A,0x25,0x32,0x64,0x20,0x52,0x3A,0x25
	.DB  0x32,0x64,0x20,0x54,0x3A,0x25,0x32,0x64
	.DB  0x20,0x0

__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  0x06
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _setLval
	.DW  _0x3*2

	.DW  0x01
	.DW  _setRval
	.DW  _0x4*2

	.DW  0x01
	.DW  _setTval
	.DW  _0x5*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include "delay.h"
;#include "includes.h"
;#include "stdio.h"
;bit ack;
;unsigned char midval;
;uchar state;
;char disdat[14]; //打印数组初始化
;char disset[16];
;int refreshFlag = 0;
;int temp;
;float temperature = 0;
;float Lv = 0.0;             //光照采集电压
;float Tv = 0.0;             //土壤采集电压
;unsigned int Lval = 0;      //光照强度
;unsigned int Rval = 0;      //土壤湿度
;unsigned int dispTemp;      //显示温度
;unsigned char rekey = 0;    //按键防止重复
;unsigned char setIndex = 0; //设置值
;unsigned char setLval = 50;

	.DSEG
;unsigned char setRval = 50;
;unsigned char setTval = 35;
;void lcd_set_e(void) {
; 0000 0017 void lcd_set_e(void) {

	.CSEG
_lcd_set_e:
; .FSTART _lcd_set_e
; 0000 0018     PORTD.1 |= 1;
	LDI  R26,0
	SBIC 0x12,1
	LDI  R26,1
	LDI  R30,LOW(1)
	OR   R30,R26
	BRNE _0x6
	CBI  0x12,1
	RJMP _0x7
_0x6:
	SBI  0x12,1
_0x7:
; 0000 0019 }
	RET
; .FEND
;void lcd_clear_e(void) {
; 0000 001A void lcd_clear_e(void) {
_lcd_clear_e:
; .FSTART _lcd_clear_e
; 0000 001B     PORTD.1 &= 0;
	LDI  R26,0
	SBIC 0x12,1
	LDI  R26,1
	LDI  R30,LOW(0)
	AND  R30,R26
	BRNE _0x8
	CBI  0x12,1
	RJMP _0x9
_0x8:
	SBI  0x12,1
_0x9:
; 0000 001C }
	RET
; .FEND
;// External Interrupt 0 service routine
;interrupt[EXT_INT0] void ext_int0_isr(void)
; 0000 001F {
_ext_int0_isr:
; .FSTART _ext_int0_isr
	CALL SUBOPT_0x0
; 0000 0020     // Place your code here
; 0000 0021     if (setIndex == 1) //设光照阈值
	BRNE _0xA
; 0000 0022     {
; 0000 0023         if (setLval < 99) //不超过99
	LDS  R26,_setLval
	CPI  R26,LOW(0x63)
	BRSH _0xB
; 0000 0024         {
; 0000 0025             setLval++;
	LDS  R30,_setLval
	SUBI R30,-LOW(1)
	STS  _setLval,R30
; 0000 0026         }
; 0000 0027     }
_0xB:
; 0000 0028     else if (setIndex == 2) //设土壤阈值
	RJMP _0xC
_0xA:
	LDS  R26,_setIndex
	CPI  R26,LOW(0x2)
	BRNE _0xD
; 0000 0029     {
; 0000 002A         if (setRval < 99) //不超过99
	LDS  R26,_setRval
	CPI  R26,LOW(0x63)
	BRSH _0xE
; 0000 002B         {
; 0000 002C             setRval++;
	LDS  R30,_setRval
	SUBI R30,-LOW(1)
	STS  _setRval,R30
; 0000 002D         }
; 0000 002E     }
_0xE:
; 0000 002F     else if (setIndex == 3) //温度设置
	RJMP _0xF
_0xD:
	LDS  R26,_setIndex
	CPI  R26,LOW(0x3)
	BRNE _0x10
; 0000 0030     {
; 0000 0031         if (setTval < 99) //不超过99
	LDS  R26,_setTval
	CPI  R26,LOW(0x63)
	BRSH _0x11
; 0000 0032         {
; 0000 0033             setTval++;
	LDS  R30,_setTval
	SUBI R30,-LOW(1)
	STS  _setTval,R30
; 0000 0034         }
; 0000 0035     }
_0x11:
; 0000 0036 }
_0x10:
_0xF:
_0xC:
	RJMP _0xD5
; .FEND
;// External Interrupt 1 service routine
;interrupt[EXT_INT1] void ext_int1_isr(void)
; 0000 0039 {
_ext_int1_isr:
; .FSTART _ext_int1_isr
	CALL SUBOPT_0x0
; 0000 003A     // Place your code here
; 0000 003B     if (setIndex == 1) //设光照阈值
	BRNE _0x12
; 0000 003C     {
; 0000 003D         if (setLval > 0) //最小为0
	LDS  R26,_setLval
	CPI  R26,LOW(0x1)
	BRLO _0x13
; 0000 003E         {
; 0000 003F             setLval--;
	LDS  R30,_setLval
	SUBI R30,LOW(1)
	STS  _setLval,R30
; 0000 0040         }
; 0000 0041     }
_0x13:
; 0000 0042     else if (setIndex == 2) //设土壤阈值
	RJMP _0x14
_0x12:
	LDS  R26,_setIndex
	CPI  R26,LOW(0x2)
	BRNE _0x15
; 0000 0043     {
; 0000 0044         if (setRval > 0) //最小为0
	LDS  R26,_setRval
	CPI  R26,LOW(0x1)
	BRLO _0x16
; 0000 0045         {
; 0000 0046             setRval--;
	LDS  R30,_setRval
	SUBI R30,LOW(1)
	STS  _setRval,R30
; 0000 0047         }
; 0000 0048     }
_0x16:
; 0000 0049     else if (setIndex == 3) //温度设置
	RJMP _0x17
_0x15:
	LDS  R26,_setIndex
	CPI  R26,LOW(0x3)
	BRNE _0x18
; 0000 004A     {
; 0000 004B         if (setTval > 0) //最小为0
	LDS  R26,_setTval
	CPI  R26,LOW(0x1)
	BRLO _0x19
; 0000 004C         {
; 0000 004D             setTval--;
	LDS  R30,_setTval
	SUBI R30,LOW(1)
	STS  _setTval,R30
; 0000 004E         }
; 0000 004F     }
_0x19:
; 0000 0050 }
_0x18:
_0x17:
_0x14:
	RJMP _0xD5
; .FEND
;// External Interrupt 2 service routine
;interrupt[EXT_INT2] void ext_int2_isr(void)
; 0000 0053 {
_ext_int2_isr:
; .FSTART _ext_int2_isr
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 0054     // Place your code here
; 0000 0055     setIndex++;
	LDS  R30,_setIndex
	SUBI R30,-LOW(1)
	STS  _setIndex,R30
; 0000 0056     if (setIndex > 3)
	LDS  R26,_setIndex
	CPI  R26,LOW(0x4)
	BRLO _0x1A
; 0000 0057     {
; 0000 0058         setIndex = 0; //取消设置
	LDI  R30,LOW(0)
	STS  _setIndex,R30
; 0000 0059     }
; 0000 005A }
_0x1A:
_0xD5:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;int Init_DS18B20(void)
; 0000 005C {
_Init_DS18B20:
; .FSTART _Init_DS18B20
; 0000 005D     int temp;
; 0000 005E     //主机发送480-960us的低电平
; 0000 005F     DQ_DIR_OUT();
	ST   -Y,R17
	ST   -Y,R16
;	temp -> R16,R17
	SBI  0x17,3
; 0000 0060     DQ_SET();
	SBI  0x18,3
; 0000 0061     delay_us(10);
	__DELAY_USB 13
; 0000 0062     DQ_CLEAR();
	CBI  0x18,3
; 0000 0063     delay_us(750);
	__DELAY_USW 750
; 0000 0064     DQ_SET();
	SBI  0x18,3
; 0000 0065     //从机拉低60-240us响应
; 0000 0066     DQ_DIR_IN();
	CBI  0x17,3
; 0000 0067     delay_us(150);
	__DELAY_USB 200
; 0000 0068     temp = DQ_DATA;
	IN   R30,0x16
	ANDI R30,LOW(0x8)
	LDI  R31,0
	CALL __ASRW3
	MOVW R16,R30
; 0000 0069     delay_us(500);
	__DELAY_USW 500
; 0000 006A     return temp;
	RJMP _0x2060004
; 0000 006B }
; .FEND
;
;void LCD_INIT(void)
; 0000 006E {
_LCD_INIT:
; .FSTART _LCD_INIT
; 0000 006F 	DDRD.1 = 1;
	SBI  0x11,1
; 0000 0070 	LCD_DIR_PORT = 0xff; // LCD port output
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0071 	LCD_OP_PORT = 0x30; // Load high-data to port
	LDI  R30,LOW(48)
	CALL SUBOPT_0x1
; 0000 0072 	lcd_clear_rw(); // Set LCD to write
; 0000 0073 	lcd_clear_rs(); // Set LCD to command
; 0000 0074 	lcd_set_e(); // Write data to LCD
; 0000 0075 	delay_us(10);
; 0000 0076 	lcd_clear_e(); // Disable LCD
; 0000 0077 	delay_us(40);
	__DELAY_USB 53
; 0000 0078 	lcd_clear_rw() ; // Set LCD to write
	CBI  0x18,1
; 0000 0079 	lcd_clear_rs(); // Set LCD to command
	CBI  0x18,0
; 0000 007A 	lcd_set_e(); // Write data to LCD
	CALL SUBOPT_0x2
; 0000 007B 	delay_us(10);
; 0000 007C 	lcd_clear_e(); // Disable LCD
; 0000 007D 	delay_us(40);
; 0000 007E 	lcd_set_e(); // Write data to LCD
	CALL SUBOPT_0x2
; 0000 007F 	delay_us(10);
; 0000 0080 	lcd_clear_e(); // Disable LCD
; 0000 0081 	delay_us(40);
; 0000 0082 	LCD_OP_PORT = 0x20;
	LDI  R30,LOW(32)
	OUT  0x18,R30
; 0000 0083 	lcd_set_e(); // Write data to LCD
	CALL SUBOPT_0x2
; 0000 0084 	delay_us(10);
; 0000 0085 	lcd_clear_e(); // Disable LCD
; 0000 0086 	delay_us(40);
; 0000 0087 	DDRB.2 |= 0;
	LDI  R26,0
	SBIC 0x17,2
	LDI  R26,1
	MOV  R30,R26
	CPI  R30,0
	BRNE _0x1D
	CBI  0x17,2
	RJMP _0x1E
_0x1D:
	SBI  0x17,2
_0x1E:
; 0000 0088 }
	RET
; .FEND
;//*****************************************************//
;// This routine will return the busy flag from the LCD //
;//*****************************************************//
;void LCD_Busy ( void )
; 0000 008D {
_LCD_Busy:
; .FSTART _LCD_Busy
; 0000 008E 	unsigned char temp,high;
; 0000 008F 	unsigned char low;
; 0000 0090 	LCD_DIR_PORT = 0x0f; // Make I/O Port input
	CALL __SAVELOCR4
;	temp -> R17
;	high -> R16
;	low -> R19
	LDI  R30,LOW(15)
	OUT  0x17,R30
; 0000 0091 	do
_0x20:
; 0000 0092 	{
; 0000 0093 		temp=LCD_OP_PORT;
	IN   R17,24
; 0000 0094 		temp=temp&BIT3;
	ANDI R17,LOW(8)
; 0000 0095 		LCD_OP_PORT=temp;
	OUT  0x18,R17
; 0000 0096 		lcd_set_rw(); // Set LCD to READ
	SBI  0x18,1
; 0000 0097 		lcd_clear_rs();
	CBI  0x18,0
; 0000 0098 		lcd_set_e();
	RCALL _lcd_set_e
; 0000 0099 		delay_us(3);
	__DELAY_USB 4
; 0000 009A 		high = LCD_IP_PORT; // read the high nibble.
	IN   R16,22
; 0000 009B 		lcd_clear_e(); // Disable LCD
	RCALL _lcd_clear_e
; 0000 009C 		lcd_set_e();
	RCALL _lcd_set_e
; 0000 009D 
; 0000 009E 		low = LCD_IP_PORT; // read the low nibble.
	IN   R19,22
; 0000 009F 		lcd_clear_e(); // Disable LCD
	RCALL _lcd_clear_e
; 0000 00A0 	} while(high & 0x80);
	SBRC R16,7
	RJMP _0x20
; 0000 00A1 	delay_us(20);
	__DELAY_USB 27
; 0000 00A2 }
	RJMP _0x2060006
; .FEND
;// ********************************************** //
;// *** Write a control instruction to the LCD *** //
;// ********************************************** //
;void LCD_WriteControl (unsigned char CMD)
; 0000 00A7 {
_LCD_WriteControl:
; .FSTART _LCD_WriteControl
; 0000 00A8 	char temp;
; 0000 00A9 	LCD_Busy(); // Test if LCD busy
	CALL SUBOPT_0x3
;	CMD -> Y+1
;	temp -> R17
; 0000 00AA 	LCD_DIR_PORT = 0xff; // LCD port output
; 0000 00AB 	temp=LCD_OP_PORT;
; 0000 00AC 	temp=temp&BIT3;
; 0000 00AD 	LCD_OP_PORT =(CMD & 0xf0)|temp; // Load high-data to port
	CALL SUBOPT_0x1
; 0000 00AE 	lcd_clear_rw(); // Set LCD to write
; 0000 00AF 	lcd_clear_rs(); // Set LCD to command
; 0000 00B0 	lcd_set_e(); // Write data to LCD
; 0000 00B1 	delay_us(10);
; 0000 00B2 	lcd_clear_e(); // Disable LCD
; 0000 00B3 	LCD_OP_PORT =(CMD<<4)|temp; // Load low-data to port
	LDD  R30,Y+1
	SWAP R30
	ANDI R30,0xF0
	OR   R30,R17
	CALL SUBOPT_0x1
; 0000 00B4 	lcd_clear_rw(); // Set LCD to write
; 0000 00B5 	lcd_clear_rs(); // Set LCD to command
; 0000 00B6 	lcd_set_e(); // Write data to LCD
; 0000 00B7 	delay_us(10);
; 0000 00B8 	lcd_clear_e(); // Disable LCD
; 0000 00B9 }
	LDD  R17,Y+0
	RJMP _0x2060008
; .FEND
;// ***************************************** //
;// *** Write one byte of data to the LCD *** //
;// ***************************************** //
;void LCD_WriteData (unsigned char Data)
; 0000 00BE {
_LCD_WriteData:
; .FSTART _LCD_WriteData
; 0000 00BF 	char temp;
; 0000 00C0 	LCD_Busy(); // Test if LCD Busy
	CALL SUBOPT_0x3
;	Data -> Y+1
;	temp -> R17
; 0000 00C1 	LCD_DIR_PORT = 0xFF; // LCD port output
; 0000 00C2 	temp=LCD_OP_PORT;
; 0000 00C3 	temp=temp&BIT3;
; 0000 00C4 	LCD_OP_PORT =(Data & 0xf0)|temp; // Load high-data to port
	CALL SUBOPT_0x4
; 0000 00C5 	lcd_clear_rw() ; // Set LCD to write
; 0000 00C6 	lcd_set_rs(); // Set LCD to data
; 0000 00C7 	lcd_set_e(); // Write data to LCD
; 0000 00C8 	delay_us(10);
; 0000 00C9 	lcd_clear_e(); // Disable LCD
; 0000 00CA 	LCD_OP_PORT = (Data << 4)|temp; // Load low-data to port
	LDD  R30,Y+1
	SWAP R30
	ANDI R30,0xF0
	OR   R30,R17
	CALL SUBOPT_0x4
; 0000 00CB 	lcd_clear_rw() ; // Set LCD to write
; 0000 00CC 	lcd_set_rs(); // Set LCD to data
; 0000 00CD 	lcd_set_e(); // Write data to LCD
; 0000 00CE 	delay_us(10);
; 0000 00CF 	lcd_clear_e(); // Disable LCD
; 0000 00D0 }
	LDD  R17,Y+0
	RJMP _0x2060008
; .FEND
;// ********************************* //
;// *** Initialize the LCD driver *** //
;// ********************************* //
;void Init_LCD(void)
; 0000 00D5 {
_Init_LCD:
; .FSTART _Init_LCD
; 0000 00D6 	LCD_INIT();
	RCALL _LCD_INIT
; 0000 00D7 	LCD_WriteControl (LCD_FUNCTION_SET);
	LDI  R26,LOW(40)
	RCALL _LCD_WriteControl
; 0000 00D8 	LCD_WriteControl (LCD_OFF);
	LDI  R26,LOW(8)
	RCALL _LCD_WriteControl
; 0000 00D9 	LCD_WriteControl (LCD_CLEAR);
	LDI  R26,LOW(1)
	RCALL _LCD_WriteControl
; 0000 00DA 	LCD_WriteControl (LCD_MODE_SET);
	LDI  R26,LOW(6)
	RCALL _LCD_WriteControl
; 0000 00DB 	LCD_WriteControl (LCD_ON);
	LDI  R26,LOW(12)
	RCALL _LCD_WriteControl
; 0000 00DC 	LCD_WriteControl (LCD_HOME);
	LDI  R26,LOW(2)
	RJMP _0x2060009
; 0000 00DD }
; .FEND
;// ************************************************ //
;// *** Clear the LCD screen (also homes cursor) *** //
;// ************************************************ //
;void LCD_Clear(void)
; 0000 00E2 {
_LCD_Clear:
; .FSTART _LCD_Clear
; 0000 00E3 	LCD_WriteControl(0x01);
	LDI  R26,LOW(1)
_0x2060009:
	RCALL _LCD_WriteControl
; 0000 00E4 }
	RET
; .FEND
;// *********************************************** //
;// *** Position the LCD cursor at row 1, col 1 *** //
;// *********************************************** //
;void LCD_Home(void)
; 0000 00E9 {
; 0000 00EA 	LCD_WriteControl(0x02);
; 0000 00EB }
;// ****************************************************************** //
;// *** Display a single character, at the current cursor location *** //
;// ****************************************************************** //
;void LCD_DisplayCharacter (char Char)
; 0000 00F0 {
_LCD_DisplayCharacter:
; .FSTART _LCD_DisplayCharacter
; 0000 00F1 	LCD_WriteData (Char);
	ST   -Y,R26
;	Char -> Y+0
	LD   R26,Y
	RCALL _LCD_WriteData
; 0000 00F2 }
	ADIW R28,1
	RET
; .FEND
;// ********************************************************************* //
;// *** Display a string at the specified row and column, using FLASH *** //
;// ********************************************************************* //
;void LCD_DisplayString_F (char row, char column , unsigned char __flash *string)
; 0000 00F7 {
; 0000 00F8 	LCD_Cursor (row, column);
;	row -> Y+3
;	column -> Y+2
;	*string -> Y+0
; 0000 00F9 	while (*string)
; 0000 00FA 	{
; 0000 00FB 	LCD_DisplayCharacter (*string++);
; 0000 00FC 	}
; 0000 00FD }
;// ******************************************************************* //
;// *** Display a string at the specified row and column, using RAM *** //
;// ******************************************************************* //
;void LCD_DisplayString (char row, char column ,unsigned char *string)
; 0000 0102 {
_LCD_DisplayString:
; .FSTART _LCD_DisplayString
; 0000 0103 	LCD_Cursor (row, column);
	ST   -Y,R27
	ST   -Y,R26
;	row -> Y+3
;	column -> Y+2
;	*string -> Y+0
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R26,Y+3
	RCALL _LCD_Cursor
; 0000 0104 	while (*string)
_0x25:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x27
; 0000 0105 		LCD_DisplayCharacter (*string++);
	LD   R30,X+
	ST   Y,R26
	STD  Y+1,R27
	MOV  R26,R30
	RCALL _LCD_DisplayCharacter
	RJMP _0x25
_0x27:
; 0000 0106 }
	RJMP _0x2060007
; .FEND
;// *************************************************** //
;// *** Position the LCD cursor at "row", "column". *** //
;// *************************************************** //
;void LCD_Cursor (char row, char column)
; 0000 010B {
_LCD_Cursor:
; .FSTART _LCD_Cursor
; 0000 010C 	switch (row) {
	ST   -Y,R26
;	row -> Y+1
;	column -> Y+0
	LDD  R30,Y+1
	LDI  R31,0
; 0000 010D 	case 1: LCD_WriteControl (0x80 + column - 1); break;
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2B
	LD   R26,Y
	SUBI R26,-LOW(128)
	SUBI R26,LOW(1)
	RCALL _LCD_WriteControl
	RJMP _0x2A
; 0000 010E 	case 2: LCD_WriteControl (0xc0 + column - 1); break;
_0x2B:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2C
	LD   R26,Y
	SUBI R26,-LOW(192)
	SUBI R26,LOW(1)
	RCALL _LCD_WriteControl
	RJMP _0x2A
; 0000 010F 	case 3: LCD_WriteControl (0x94 + column - 1); break;
_0x2C:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2D
	LD   R26,Y
	SUBI R26,-LOW(148)
	SUBI R26,LOW(1)
	RCALL _LCD_WriteControl
	RJMP _0x2A
; 0000 0110 	case 4: LCD_WriteControl (0xd4 + column - 1); break;
_0x2D:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2F
	LD   R26,Y
	SUBI R26,-LOW(212)
	SUBI R26,LOW(1)
	RCALL _LCD_WriteControl
; 0000 0111 	default: break;
_0x2F:
; 0000 0112 }
_0x2A:
; 0000 0113 }
_0x2060008:
	ADIW R28,2
	RET
; .FEND
;// ************************** //
;// *** Turn the cursor on *** //
;// ************************** //
;void LCD_Cursor_On (void)
; 0000 0118 {
; 0000 0119 	LCD_WriteControl (LCD_CURS_ON);
; 0000 011A }
;// *************************** //
;// *** Turn the cursor off *** //
;// *************************** //
;void LCD_Cursor_Off (void)
; 0000 011F {
; 0000 0120 	LCD_WriteControl (LCD_ON);
; 0000 0121 }
;// ******************** //
;// *** Turn Off LCD *** //
;// ******************** //
;void LCD_Display_Off (void)
; 0000 0126 {
; 0000 0127 	LCD_WriteControl(LCD_OFF);
; 0000 0128 }
;// ******************* //
;// *** Turn On LCD *** //
;// ******************* //
;void LCD_Display_On (void)
; 0000 012D {
; 0000 012E 	LCD_WriteControl(LCD_ON);
; 0000 012F }
;
;uchar Read_DS18B20(void)
; 0000 0132 {
_Read_DS18B20:
; .FSTART _Read_DS18B20
; 0000 0133     uchar value = 0;
; 0000 0134     int i;
; 0000 0135     for(i=0;i<8;i++)
	CALL __SAVELOCR4
;	value -> R17
;	i -> R18,R19
	LDI  R17,0
	__GETWRN 18,19,0
_0x31:
	__CPWRN 18,19,8
	BRGE _0x32
; 0000 0136     {
; 0000 0137         //主机拉低总线并释放
; 0000 0138         DQ_DIR_OUT();
	SBI  0x17,3
; 0000 0139         DQ_SET();
	SBI  0x18,3
; 0000 013A         delay_us(1);
	__DELAY_USB 1
; 0000 013B         DQ_CLEAR();
	CBI  0x18,3
; 0000 013C         delay_us(1);
	__DELAY_USB 1
; 0000 013D         DQ_SET();
	SBI  0x18,3
; 0000 013E         //读数据位
; 0000 013F         DQ_DIR_IN();
	CBI  0x17,3
; 0000 0140         delay_us(7);
	__DELAY_USB 9
; 0000 0141         value |= (DQ_DATA<<i);
	IN   R30,0x16
	ANDI R30,LOW(0x8)
	LDI  R31,0
	CALL __ASRW3
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSLB12
	OR   R17,R30
; 0000 0142         delay_us(70);
	__DELAY_USB 93
; 0000 0143     }
	__ADDWRN 18,19,1
	RJMP _0x31
_0x32:
; 0000 0144     return value;
	MOV  R30,R17
	RJMP _0x2060006
; 0000 0145 }
; .FEND
;
;uchar Write_DS18B20(uchar value)
; 0000 0148 {
_Write_DS18B20:
; .FSTART _Write_DS18B20
; 0000 0149     int i;
; 0000 014A     DQ_DIR_OUT();
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	value -> Y+2
;	i -> R16,R17
	SBI  0x17,3
; 0000 014B     for(i=0;i<8;i++)
	__GETWRN 16,17,0
_0x34:
	__CPWRN 16,17,8
	BRGE _0x35
; 0000 014C     {
; 0000 014D         //主机拉低总线
; 0000 014E         DQ_SET();
	SBI  0x18,3
; 0000 014F         delay_us(1);
	__DELAY_USB 1
; 0000 0150         DQ_CLEAR();
	CBI  0x18,3
; 0000 0151         //写数据位
; 0000 0152         if(((value&(1<<i)))!=0)
	MOV  R30,R16
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __LSLW12
	LDD  R26,Y+2
	LDI  R27,0
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0x36
; 0000 0153         {
; 0000 0154             DQ_SET();
	SBI  0x18,3
; 0000 0155         }
; 0000 0156         else
	RJMP _0x37
_0x36:
; 0000 0157         {
; 0000 0158             DQ_CLEAR();
	CBI  0x18,3
; 0000 0159         }
_0x37:
; 0000 015A         delay_us(70);
	__DELAY_USB 93
; 0000 015B         DQ_SET();
	SBI  0x18,3
; 0000 015C         delay_us(10);
	__DELAY_USB 13
; 0000 015D     }
	__ADDWRN 16,17,1
	RJMP _0x34
_0x35:
; 0000 015E     delay_us(10);
	__DELAY_USB 13
; 0000 015F }
	RJMP _0x2060002
; .FEND
;
;
;
;//读取温度
;int Read_Temperature(void)
; 0000 0165 {
_Read_Temperature:
; .FSTART _Read_Temperature
; 0000 0166     char temp_l, temp_h;
; 0000 0167     int temp;
; 0000 0168     #asm("cli")
	CALL __SAVELOCR4
;	temp_l -> R17
;	temp_h -> R16
;	temp -> R18,R19
	cli
; 0000 0169     Init_DS18B20();
	RCALL _Init_DS18B20
; 0000 016A     Write_DS18B20(0xCC); //跳过ROM
	LDI  R26,LOW(204)
	RCALL _Write_DS18B20
; 0000 016B     Write_DS18B20(0x44); //温度转换
	LDI  R26,LOW(68)
	RCALL _Write_DS18B20
; 0000 016C     #asm("sei");
	sei
; 0000 016D     delay_ms(200); //等待温度转换
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0000 016E     #asm("cli")
	cli
; 0000 016F     Init_DS18B20();
	RCALL _Init_DS18B20
; 0000 0170     Write_DS18B20(0xCC); //跳过ROM
	LDI  R26,LOW(204)
	RCALL _Write_DS18B20
; 0000 0171     Write_DS18B20(0xBE); //读RAM数据
	LDI  R26,LOW(190)
	RCALL _Write_DS18B20
; 0000 0172     temp_l = Read_DS18B20(); //读前两字节数据
	RCALL _Read_DS18B20
	MOV  R17,R30
; 0000 0173     temp_h = Read_DS18B20();
	RCALL _Read_DS18B20
	MOV  R16,R30
; 0000 0174     #asm("sei")
	sei
; 0000 0175     if((temp_h&0xf8)!=0x00)
	MOV  R30,R16
	ANDI R30,LOW(0xF8)
	BREQ _0x38
; 0000 0176     {
; 0000 0177         state=1;         //此时温度为零下，即为负数
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 0178         temp_h=~temp_h;
	COM  R16
; 0000 0179         temp_l=~temp_l;
	COM  R17
; 0000 017A         temp_l +=1;
	SUBI R17,-LOW(1)
; 0000 017B         if(temp_l>255)
	LDI  R30,LOW(255)
	CP   R30,R17
	BRSH _0x39
; 0000 017C             temp_h++;
	SUBI R16,-1
; 0000 017D     }
_0x39:
; 0000 017E         temp=temp_h;
_0x38:
	MOV  R18,R16
	CLR  R19
; 0000 017F         temp&=0x07;
	__ANDWRN 18,19,7
; 0000 0180         temp=((temp_h*256)+temp_l)*0.625+0.5;
	MOV  R26,R16
	LDI  R27,0
	LDI  R30,LOW(256)
	LDI  R31,HIGH(256)
	CALL __MULW12
	MOVW R26,R30
	MOV  R30,R17
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	CALL __CWD1
	CALL __CDF1
	__GETD2N 0x3F200000
	CALL __MULF12
	__GETD2N 0x3F000000
	CALL __ADDF12
	CALL __CFD1
	MOVW R18,R30
; 0000 0181     //处理数据
; 0000 0182     //temp = (temp_h*256+temp_l)*6.25;
; 0000 0183     return temp/10;
	MOVW R26,R18
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
_0x2060006:
	CALL __LOADLOCR4
_0x2060007:
	ADIW R28,4
	RET
; 0000 0184 }
; .FEND
;
;
;
;void main(void)
; 0000 0189 {
_main:
; .FSTART _main
; 0000 018A     #asm("sei")
	sei
; 0000 018B     Init_LCD();
	RCALL _Init_LCD
; 0000 018C     LCD_Clear();
	RCALL _LCD_Clear
; 0000 018D     DDRA=11111000;
	LDI  R30,LOW(88)
	OUT  0x1A,R30
; 0000 018E     PORTA=00000111;
	LDI  R30,LOW(73)
	OUT  0x1B,R30
; 0000 018F     DDRD.6=0;
	CBI  0x11,6
; 0000 0190     PORTD.6=1;
	SBI  0x12,6
; 0000 0191     DDRD.7=0;
	CBI  0x11,7
; 0000 0192     PORTD.7=1;
	SBI  0x12,7
; 0000 0193     DDRD.0=1;
	SBI  0x11,0
; 0000 0194     PORTD.0=1;
	SBI  0x12,0
; 0000 0195     GICR |= 0xE0; //INT2：On；INT1: On；INT0: On
	IN   R30,0x3B
	ORI  R30,LOW(0xE0)
	OUT  0x3B,R30
; 0000 0196     MCUCR = 0x0A; //INT1、INT0下降沿产生中断
	LDI  R30,LOW(10)
	OUT  0x35,R30
; 0000 0197     MCUCSR = 0x00;//INT2：下降沿产生中断
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 0198     GIFR = 0xE0; //清除INT2、INT1、INT0中断标志
	LDI  R30,LOW(224)
	OUT  0x3A,R30
; 0000 0199     LED_WHITE = 0;
	CBI  0x1B,4
; 0000 019A     RELAY = 0;
	CBI  0x12,0
; 0000 019B     LED_YELLOW = 0;
	CBI  0x1B,3
; 0000 019C     FAN = 0; //上电检测下 方便检测硬件
	CBI  0x1B,6
; 0000 019D     delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0000 019E     LED_WHITE = 1;
	SBI  0x1B,4
; 0000 019F     RELAY = 1;
	SBI  0x12,0
; 0000 01A0     LED_YELLOW = 1;
	SBI  0x1B,3
; 0000 01A1     FAN = 0;
	CBI  0x1B,6
; 0000 01A2 
; 0000 01A3     while (1)
_0x56:
; 0000 01A4       {
; 0000 01A5          dispTemp = Read_Temperature();
	RCALL _Read_Temperature
	STS  _dispTemp,R30
	STS  _dispTemp+1,R31
; 0000 01A6          midval = ReadADC(1);                    //转换的结果，在下次，才能读出
	LDI  R26,LOW(1)
	CALL SUBOPT_0x5
; 0000 01A7          Lv = 5.00 - (float)midval * 5.00 / 255; //光照
	STS  _Lv,R30
	STS  _Lv+1,R31
	STS  _Lv+2,R22
	STS  _Lv+3,R23
; 0000 01A8          Lval = (unsigned int)(Lv *99) / 5.00;
	LDS  R26,_Lv
	LDS  R27,_Lv+1
	LDS  R24,_Lv+2
	LDS  R25,_Lv+3
	CALL SUBOPT_0x6
	CALL __CFD1U
	MOVW R12,R30
; 0000 01A9          delay_ms(10); //延时有助于稳定
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
; 0000 01AA          midval = ReadADC(0);                    //读取AD检测到的
	LDI  R26,LOW(0)
	CALL SUBOPT_0x5
; 0000 01AB          Tv = 5.00 - (float)midval * 5.00 / 255; //土壤湿度
	STS  _Tv,R30
	STS  _Tv+1,R31
	STS  _Tv+2,R22
	STS  _Tv+3,R23
; 0000 01AC          Rval = (unsigned int)(Tv *99) / 5.00;
	LDS  R26,_Tv
	LDS  R27,_Tv+1
	LDS  R24,_Tv+2
	LDS  R25,_Tv+3
	CALL SUBOPT_0x6
	LDI  R26,LOW(_Rval)
	LDI  R27,HIGH(_Rval)
	CALL __CFD1U
	ST   X+,R30
	ST   X,R31
; 0000 01AD          delay_ms(20);
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
; 0000 01AE          sprintf(disdat, "L:%2d R:%2d T:%2d", Lval, Rval, dispTemp); //打印电压电流值
	LDI  R30,LOW(_disdat)
	LDI  R31,HIGH(_disdat)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R12
	CALL SUBOPT_0x7
	LDS  R30,_Rval
	LDS  R31,_Rval+1
	CALL SUBOPT_0x7
	LDS  R30,_dispTemp
	LDS  R31,_dispTemp+1
	CALL SUBOPT_0x7
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
; 0000 01AF          LCD_DisplayString(1, 2, disdat);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R26,LOW(_disdat)
	LDI  R27,HIGH(_disdat)
	RCALL _LCD_DisplayString
; 0000 01B0          if (setIndex == 1) //进入设置
	LDS  R26,_setIndex
	CPI  R26,LOW(0x1)
	BRNE _0x59
; 0000 01B1             {
; 0000 01B2                 sprintf(disset, "*L:%2d R:%2d T:%2d ", (unsigned int)setLval, (unsigned int)setRval, (unsigned int)setTv ...
	CALL SUBOPT_0x8
	__POINTW1FN _0x0,18
	RJMP _0xD3
; 0000 01B3             }
; 0000 01B4          else if (setIndex == 2)
_0x59:
	LDS  R26,_setIndex
	CPI  R26,LOW(0x2)
	BRNE _0x5B
; 0000 01B5             {
; 0000 01B6                 sprintf(disset, " L:%2d*R:%2d T:%2d ", (unsigned int)setLval, (unsigned int)setRval, (unsigned int)setTv ...
	CALL SUBOPT_0x8
	__POINTW1FN _0x0,38
	RJMP _0xD3
; 0000 01B7             }
; 0000 01B8          else if (setIndex == 3)
_0x5B:
	LDS  R26,_setIndex
	CPI  R26,LOW(0x3)
	BRNE _0x5D
; 0000 01B9             {
; 0000 01BA                 sprintf(disset, " L:%2d R:%2d*T:%2d ", (unsigned int)setLval, (unsigned int)setRval, (unsigned int)setTv ...
	CALL SUBOPT_0x8
	__POINTW1FN _0x0,58
	RJMP _0xD3
; 0000 01BB             }
; 0000 01BC          else
_0x5D:
; 0000 01BD             {
; 0000 01BE                 sprintf(disset, " L:%2d R:%2d T:%2d ", (unsigned int)setLval, (unsigned int)setRval, (unsigned int)setTv ...
	CALL SUBOPT_0x8
	__POINTW1FN _0x0,78
_0xD3:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_setLval
	LDI  R31,0
	CALL SUBOPT_0x7
	LDS  R30,_setRval
	LDI  R31,0
	CALL SUBOPT_0x7
	LDS  R30,_setTval
	LDI  R31,0
	CALL SUBOPT_0x7
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
; 0000 01BF             }
; 0000 01C0          if (Lval <= setLval) //光照对比
	LDS  R30,_setLval
	MOVW R26,R12
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x5F
; 0000 01C1             {
; 0000 01C2                 LED_WHITE = 0; //打开补光灯
	CBI  0x1B,4
; 0000 01C3             }
; 0000 01C4             else
	RJMP _0x62
_0x5F:
; 0000 01C5             {
; 0000 01C6                 LED_WHITE = 1; //关闭补光灯
	SBI  0x1B,4
; 0000 01C7             }
_0x62:
; 0000 01C8 
; 0000 01C9             if (Rval <= setRval) //土壤对比
	LDS  R30,_setRval
	LDS  R26,_Rval
	LDS  R27,_Rval+1
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x65
; 0000 01CA             {
; 0000 01CB                 RELAY = 0; //打开水泵继电器
	CBI  0x12,0
; 0000 01CC             }
; 0000 01CD             else
	RJMP _0x68
_0x65:
; 0000 01CE             {
; 0000 01CF                 RELAY = 1; //关闭水泵继电器
	SBI  0x12,0
; 0000 01D0             }
_0x68:
; 0000 01D1 
; 0000 01D2 
; 0000 01D3             if (dispTemp < setTval) //温度对比
	CALL SUBOPT_0x9
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x6B
; 0000 01D4             {
; 0000 01D5                 LED_YELLOW = 0; //打开补温灯
	CBI  0x1B,3
; 0000 01D6                 FAN = 1; //关闭风扇
	RJMP _0xD4
; 0000 01D7             }
; 0000 01D8             else if (dispTemp > setTval)
_0x6B:
	CALL SUBOPT_0x9
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x71
; 0000 01D9             {
; 0000 01DA                 LED_YELLOW = 1; //关闭补温灯
	SBI  0x1B,3
; 0000 01DB                 FAN = 0; //打开风扇
	CBI  0x1B,6
; 0000 01DC             }
; 0000 01DD             else
	RJMP _0x76
_0x71:
; 0000 01DE             {
; 0000 01DF                 LED_YELLOW = 1; //关闭补温灯
	SBI  0x1B,3
; 0000 01E0                 FAN = 1; //关闭风扇
_0xD4:
	SBI  0x1B,6
; 0000 01E1             }
_0x76:
; 0000 01E2 
; 0000 01E3 
; 0000 01E4          LCD_DisplayString(2, 1, disset);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(_disset)
	LDI  R27,HIGH(_disset)
	RCALL _LCD_DisplayString
; 0000 01E5 //         KeyProcess();
; 0000 01E6       }
	RJMP _0x56
; 0000 01E7 }
_0x7B:
	RJMP _0x7B
; .FEND
;
;
;void I2C_SCL_IN(void)
; 0000 01EB {
; 0000 01EC     DDRC.0 = 0;
; 0000 01ED     PORTC.0 = 1;
; 0000 01EE     delay_us(5);
; 0000 01EF }
;void I2C_SDA_IN(void)
; 0000 01F1 {
_I2C_SDA_IN:
; .FSTART _I2C_SDA_IN
; 0000 01F2     DDRC.1 = 0;
	CBI  0x14,1
; 0000 01F3     PORTC.1 = 1;
	SBI  0x15,1
; 0000 01F4     delay_ms(5);
	LDI  R26,LOW(5)
	LDI  R27,0
	CALL _delay_ms
; 0000 01F5 }
	RET
; .FEND
;void I2C_SDA_OUT(void)
; 0000 01F7 {
_I2C_SDA_OUT:
; .FSTART _I2C_SDA_OUT
; 0000 01F8     DDRC.1 = 1;
	SBI  0x14,1
; 0000 01F9     delay_us(5);
	RJMP _0x2060005
; 0000 01FA }
; .FEND
;void I2C_SCL_OUT(void)
; 0000 01FC {
_I2C_SCL_OUT:
; .FSTART _I2C_SCL_OUT
; 0000 01FD     DDRC.0 = 1;
	SBI  0x14,0
; 0000 01FE     delay_us(5);
_0x2060005:
	__DELAY_USB 7
; 0000 01FF }
	RET
; .FEND
;
;void StartI2C()
; 0000 0202 {
_StartI2C:
; .FSTART _StartI2C
; 0000 0203     I2C_SCL_OUT();
	CALL SUBOPT_0xA
; 0000 0204     I2C_SDA_OUT();
; 0000 0205     I2C_SDA_PORT = 1;
	SBI  0x15,1
; 0000 0206     I2C_SCL_PORT = 1;
	CALL SUBOPT_0xB
; 0000 0207     delay_us(10);
; 0000 0208     I2C_SDA_PORT = 0;
	CBI  0x15,1
; 0000 0209     delay_us(10);
	CALL SUBOPT_0xC
; 0000 020A     I2C_SCL_PORT = 0;
; 0000 020B }
	RET
; .FEND
;
;void StopI2C()
; 0000 020E {
_StopI2C:
; .FSTART _StopI2C
; 0000 020F     I2C_SCL_OUT();
	CALL SUBOPT_0xA
; 0000 0210     I2C_SDA_OUT();
; 0000 0211     I2C_SDA_PORT = 0;
	CBI  0x15,1
; 0000 0212     I2C_SCL_PORT = 0;
	CBI  0x15,0
; 0000 0213     delay_us(10);
	CALL SUBOPT_0xD
; 0000 0214     I2C_SCL_PORT = 1;
; 0000 0215     delay_us(10);
; 0000 0216     I2C_SDA_PORT = 1;
	SBI  0x15,1
; 0000 0217 }
	RET
; .FEND
;
;bit WriteI2C(unsigned char dat)
; 0000 021A {
_WriteI2C:
; .FSTART _WriteI2C
; 0000 021B     bit ack;
; 0000 021C     unsigned char mask;
; 0000 021D     I2C_SCL_OUT();
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	dat -> Y+2
;	ack -> R17
;	mask -> R16
	CALL SUBOPT_0xA
; 0000 021E     I2C_SDA_OUT();
; 0000 021F     for (mask=0x80; mask!=0; mask>>=1)
	LDI  R16,LOW(128)
_0x99:
	CPI  R16,0
	BREQ _0x9A
; 0000 0220     {
; 0000 0221         if ((mask&dat) == 0)
	LDD  R30,Y+2
	AND  R30,R16
	BRNE _0x9B
; 0000 0222             I2C_SDA_PORT = 0;
	CBI  0x15,1
; 0000 0223         else
	RJMP _0x9E
_0x9B:
; 0000 0224             I2C_SDA_PORT = 1;
	SBI  0x15,1
; 0000 0225         delay_us(10);
_0x9E:
	CALL SUBOPT_0xD
; 0000 0226         I2C_SCL_PORT = 1;
; 0000 0227         delay_us(10);
; 0000 0228         I2C_SCL_PORT = 0;
	CBI  0x15,0
; 0000 0229     }
	LSR  R16
	RJMP _0x99
_0x9A:
; 0000 022A     I2C_SDA_PORT = 1;    //8位数据发送完毕之后，主动释放SDA，以检测从机应答
	SBI  0x15,1
; 0000 022B     delay_us(10);
	__DELAY_USB 13
; 0000 022C     I2C_SDA_IN();
	RCALL _I2C_SDA_IN
; 0000 022D     I2C_SCL_PORT = 1;
	CALL SUBOPT_0xB
; 0000 022E     delay_us(10);
; 0000 022F     ack = I2C_SDA_PIN;  //读取此时的SDA 值，即为从机的应答值
	LDI  R30,0
	SBIC 0x13,1
	LDI  R30,1
	MOV  R17,R30
; 0000 0230     delay_us(10);
	CALL SUBOPT_0xC
; 0000 0231     I2C_SCL_PORT = 0;    //再拉低SCL 完成应答位，并保持住总线
; 0000 0232     return (~ack);  //应答值取反以符合通常的逻辑：0=不存在或忙或写入失败，1=存在且空闲或写入成功
	MOV  R30,R17
	COM  R30
	RJMP _0x2060002
; 0000 0233 }
; .FEND
;
;//读I2C，并应答
;unsigned char ReadI2CAck()
; 0000 0237 {
_ReadI2CAck:
; .FSTART _ReadI2CAck
; 0000 0238     unsigned char mask;
; 0000 0239     unsigned char dat;
; 0000 023A     I2C_SCL_OUT();
	ST   -Y,R17
	ST   -Y,R16
;	mask -> R17
;	dat -> R16
	CALL SUBOPT_0xA
; 0000 023B     I2C_SDA_OUT();
; 0000 023C     I2C_SDA_PORT = 1;
	SBI  0x15,1
; 0000 023D     I2C_SDA_IN();
	RCALL _I2C_SDA_IN
; 0000 023E     for (mask=0x80; mask!=0; mask>>=1)
	LDI  R17,LOW(128)
_0xAE:
	CPI  R17,0
	BREQ _0xAF
; 0000 023F     {
; 0000 0240         delay_us(10);
	CALL SUBOPT_0xD
; 0000 0241         I2C_SCL_PORT = 1;        //拉高SCL
; 0000 0242         delay_us(10);
; 0000 0243         if (I2C_SDA_PIN == 0)   //读取SDA 的值
	SBIC 0x13,1
	RJMP _0xB2
; 0000 0244             dat &= ~mask;   //为0 时，dat 中对应位清零
	MOV  R30,R17
	COM  R30
	AND  R16,R30
; 0000 0245         else
	RJMP _0xB3
_0xB2:
; 0000 0246             dat |= mask;    //为1 时，dat 中对应位置1
	OR   R16,R17
; 0000 0247         delay_us(10);
_0xB3:
	CALL SUBOPT_0xC
; 0000 0248         I2C_SCL_PORT = 0;        //再拉低SCL，以使从机发送出下一位
; 0000 0249         I2C_SDA_OUT();
	RCALL _I2C_SDA_OUT
; 0000 024A         delay_us(10);
	__DELAY_USB 13
; 0000 024B     }
	LSR  R17
	RJMP _0xAE
_0xAF:
; 0000 024C     I2C_SDA_PORT = 0;    //8 位数据发送完后，拉低SDA，发送应答信号
	CBI  0x15,1
; 0000 024D     delay_us(10);
	RJMP _0x2060003
; 0000 024E     I2C_SCL_PORT = 1;    //拉高SCL
; 0000 024F     delay_us(10);
; 0000 0250     I2C_SCL_PORT = 0;    //再拉低SCL 完成应答位，并保持住总线
; 0000 0251     return dat;
; 0000 0252 }
; .FEND
;
;//读I2C，但不应答
;unsigned char ReadI2CNoAck()
; 0000 0256 {
_ReadI2CNoAck:
; .FSTART _ReadI2CNoAck
; 0000 0257     unsigned char mask;
; 0000 0258     unsigned char dat;
; 0000 0259     I2C_SDA_OUT();
	ST   -Y,R17
	ST   -Y,R16
;	mask -> R17
;	dat -> R16
	RCALL _I2C_SDA_OUT
; 0000 025A     I2C_SCL_OUT();
	RCALL _I2C_SCL_OUT
; 0000 025B     I2C_SDA_PORT = 1;
	SBI  0x15,1
; 0000 025C     for (mask=0x80; mask!=0; mask>>=1)
	LDI  R17,LOW(128)
_0xBF:
	CPI  R17,0
	BREQ _0xC0
; 0000 025D     {
; 0000 025E         delay_us(10);
	__DELAY_USB 13
; 0000 025F         I2C_SDA_IN();
	RCALL _I2C_SDA_IN
; 0000 0260         delay_us(10);
	CALL SUBOPT_0xD
; 0000 0261         I2C_SCL_PORT = 1;        //拉高SCL
; 0000 0262         delay_us(10);
; 0000 0263         if (I2C_SDA_PIN == 0)   //读取SDA 的值
	SBIC 0x13,1
	RJMP _0xC3
; 0000 0264             dat &= ~mask;   //为0 时，dat 中对应位清零
	MOV  R30,R17
	COM  R30
	AND  R16,R30
; 0000 0265         else
	RJMP _0xC4
_0xC3:
; 0000 0266             dat |= mask;    //为1 时，dat 中对应位置1
	OR   R16,R17
; 0000 0267         delay_us(10);
_0xC4:
	CALL SUBOPT_0xC
; 0000 0268         I2C_SCL_PORT = 0;        //再拉低SCL，以使从机发送出下一位
; 0000 0269     }
	LSR  R17
	RJMP _0xBF
_0xC0:
; 0000 026A     I2C_SDA_OUT();
	RCALL _I2C_SDA_OUT
; 0000 026B     delay_us(10);
	__DELAY_USB 13
; 0000 026C     I2C_SDA_PORT = 1;    //8 位数据发送完后，拉高SDA，发送非应答信号
	SBI  0x15,1
; 0000 026D     delay_us(10);
_0x2060003:
	__DELAY_USB 13
; 0000 026E     I2C_SCL_PORT = 1;    //拉高SCL
	CALL SUBOPT_0xB
; 0000 026F     delay_us(10);
; 0000 0270     I2C_SCL_PORT = 0;    //再拉低SCL 完成应答位，并保持住总线
	CBI  0x15,0
; 0000 0271     return dat;
	MOV  R30,R16
_0x2060004:
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 0272 }
; .FEND
;
;unsigned char ReadADC(unsigned char channel)
; 0000 0275 {
_ReadADC:
; .FSTART _ReadADC
; 0000 0276     bit ack = 0;
; 0000 0277     unsigned char dat = 0;
; 0000 0278     StartI2C();
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	channel -> Y+2
;	ack -> R17
;	dat -> R16
	LDI  R17,0
	LDI  R16,0
	RCALL _StartI2C
; 0000 0279     do
_0xCE:
; 0000 027A     {
; 0000 027B         ack = WriteI2C(ADDR_WR);
	LDI  R26,LOW(144)
	RCALL _WriteI2C
	MOV  R17,R30
; 0000 027C     }while (!ack);
	CPI  R17,0
	BREQ _0xCE
; 0000 027D     WriteI2C(0x00 | channel);
	LDD  R30,Y+2
	MOV  R26,R30
	RCALL _WriteI2C
; 0000 027E     StopI2C();
	RCALL _StopI2C
; 0000 027F     StartI2C();
	RCALL _StartI2C
; 0000 0280     do
_0xD1:
; 0000 0281     {
; 0000 0282         ack = WriteI2C(ADDR_RD);
	LDI  R26,LOW(145)
	RCALL _WriteI2C
	MOV  R17,R30
; 0000 0283     }while (!ack);
	CPI  R17,0
	BREQ _0xD1
; 0000 0284     ReadI2CAck(); //丢弃上一次的转换值
	RCALL _ReadI2CAck
; 0000 0285     dat = ReadI2CNoAck();  //获取最新的转换值
	RCALL _ReadI2CNoAck
	MOV  R16,R30
; 0000 0286     StopI2C();
	RCALL _StopI2C
; 0000 0287     return dat;
	MOV  R30,R16
_0x2060002:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
; 0000 0288 }
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G100:
; .FSTART _put_buff_G100
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2000013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2000014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2000014:
	RJMP _0x2000015
_0x2000010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	CALL SUBOPT_0xE
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0xE
	RJMP _0x20000CC
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	CALL SUBOPT_0xF
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x10
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0xF
	CALL SUBOPT_0x11
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0xF
	CALL SUBOPT_0x11
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	CALL SUBOPT_0xF
	CALL SUBOPT_0x12
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	CALL SUBOPT_0xF
	CALL SUBOPT_0x12
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	CALL SUBOPT_0xE
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	CALL SUBOPT_0xE
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CD
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x10
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0xE
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x10
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000CC:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x13
	SBIW R30,0
	BRNE _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2060001
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x13
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2060001:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.DSEG
_disdat:
	.BYTE 0xE
_disset:
	.BYTE 0x10
_Lv:
	.BYTE 0x4
_Tv:
	.BYTE 0x4
_Rval:
	.BYTE 0x2
_dispTemp:
	.BYTE 0x2
_setIndex:
	.BYTE 0x1
_setLval:
	.BYTE 0x1
_setRval:
	.BYTE 0x1
_setTval:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
	LDS  R26,_setIndex
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1:
	OUT  0x18,R30
	CBI  0x18,1
	CBI  0x18,0
	CALL _lcd_set_e
	__DELAY_USB 13
	JMP  _lcd_clear_e

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2:
	CALL _lcd_set_e
	__DELAY_USB 13
	CALL _lcd_clear_e
	__DELAY_USB 53
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3:
	ST   -Y,R26
	ST   -Y,R17
	CALL _LCD_Busy
	LDI  R30,LOW(255)
	OUT  0x17,R30
	IN   R17,24
	ANDI R17,LOW(8)
	LDD  R30,Y+1
	ANDI R30,LOW(0xF0)
	OR   R30,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	OUT  0x18,R30
	CBI  0x18,1
	SBI  0x18,0
	CALL _lcd_set_e
	__DELAY_USB 13
	JMP  _lcd_clear_e

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0x5:
	CALL _ReadADC
	MOV  R4,R30
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2N 0x40A00000
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x437F0000
	CALL __DIVF21
	__GETD2N 0x40A00000
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x6:
	__GETD1N 0x42C60000
	CALL __MULF12
	CALL __CFD1U
	CLR  R22
	CLR  R23
	CLR  R22
	CLR  R23
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x40A00000
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7:
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(_disset)
	LDI  R31,HIGH(_disset)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	LDS  R30,_setTval
	LDS  R26,_dispTemp
	LDS  R27,_dispTemp+1
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	CALL _I2C_SCL_OUT
	JMP  _I2C_SDA_OUT

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xB:
	SBI  0x15,0
	__DELAY_USB 13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	__DELAY_USB 13
	CBI  0x15,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xD:
	__DELAY_USB 13
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xE:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xF:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x11:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x3E8
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSLW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
	RET

__ASRW3:
	ASR  R31
	ROR  R30
__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
