
; PIC16F887 Configuration Bit Settings

; Assembly source line config statements

#include "p16f887.inc"

; CONFIG1
; __config 0x28D5
 __CONFIG _CONFIG1, _FOSC_INTRC_CLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_ON & _LVP_OFF
; CONFIG2
; __config 0x3FFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF

    LIST p=16F887
    
N EQU 0xD0
cont1 EQU 0x20 
cont2 EQU 0x21 
fila EQU 0x22 ; Variable para la fila en la secuencia

    ORG	0x00

    ;BANCO 1
    BSF STATUS, RP0
    MOVLW 0x71
    MOVWF OSCCON ; Configurar la frecuencia de oscilación
    CLRF TRISB ; Configurar todo el puerto B como salida
    
    ;BANCO 3 / PUERTO DIGITAL CON CLRF PARA ANSELH
    BSF STATUS, RP1
    CLRF ANSELH ; Configurar puerto B como digital
    
    ;BANCO 0
    BCF STATUS, RP0
    BCF STATUS, RP1

LOOP
    MOVLW b'10000000' ; Inicia con la primera LED encendido en B7
    MOVWF fila       ; Guardar en la variable fila

    MOVLW 0x08       ; Número de LEDs a encender (8 pasos)
    MOVWF cont1
    
SECUENCIA
    MOVF fila, W     ; Cargar el valor de fila en W
    MOVWF PORTB      ; Escribir el valor en PORTB para encender los LEDs
    CALL RETARDO     ; Llamar al retardo
    
    RRF fila, 1      ; Desplazar fila a la derecha para el siguiente LED
    DECFSZ cont1,1   ; Decrementar contador de pasos
    GOTO SECUENCIA   ; Si no ha terminado, repetir la secuencia

    GOTO LOOP        ; Volver a empezar la secuencia

RETARDO
    MOVLW N
    MOVWF cont2
    
REP_1
    DECFSZ cont2,1
    GOTO REP_1
    
    RETURN
    
    END
