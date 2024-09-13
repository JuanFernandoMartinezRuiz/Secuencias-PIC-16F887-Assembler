
#include "p16f887.inc"

; CONFIG1
 __CONFIG _CONFIG1, _FOSC_INTRC_CLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_ON & _LVP_OFF
; CONFIG2
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF

 LIST p=16F887

TEMP    EQU 0x20  ; Variable temporal
CONT1   EQU 0x21  ; Contador 1
CONT2   EQU 0x22  ; Contador 2
N       EQU 0xD0  ; Constante para retardo

    ORG 0x00
    GOTO INICIO

INICIO
    BCF     STATUS, RP0  ; Seleccionar Banco 0
    BCF     STATUS, RP1
    CLRF    PORTA        ; Limpiar PORTA
    CLRF    PORTB        ; Limpiar PORTB
    BSF     STATUS, RP0  ; Seleccionar Banco 1
    CLRF    TRISA        ; Configurar PORTA como salida
    CLRF    TRISB        ; Configurar PORTB como salida
    BSF     STATUS, RP1
    CLRF    ANSEL        ; Configurar pines como digitales
    BCF     STATUS, RP0  ; Seleccionar Banco 0
    BCF     STATUS, RP1

SECUENCIA:
    ; Fila 0: 11000110
    MOVLW   0xC0    ; Cargar 11000000 en W
    MOVWF   TEMP    ; Guardar en TEMP
    MOVLW   0x06    ; Cargar 00000110 en W
    IORWF   TEMP, F ; TEMP = 11000110
    MOVF    TEMP, 0
    MOVWF   PORTB   ; Mostrar el valor en PORTB
    CALL    RETARDO

    ; Fila 1: 01101100
    MOVLW   0x60    ; Cargar 01100000 en W
    MOVWF   TEMP    ; Guardar en TEMP
    MOVLW   0x0C    ; Cargar 00001100 en W
    IORWF   TEMP, F ; TEMP = 01101100
    MOVF    TEMP, 0
    MOVWF   PORTB   ; Mostrar el valor en PORTB
    CALL    RETARDO

    ; Fila 2: 00111000
    MOVLW   0x38    ; Cargar 00111000 en W
    MOVWF   TEMP    ; Guardar en TEMP
    MOVF    TEMP, 0
    MOVWF   PORTB   ; Mostrar el valor en PORTB
    CALL    RETARDO

    ; Fila 3: 01111000
    RLF     TEMP, F ; Rotar izquierda para obtener 01110000
    MOVLW   0x08    ; Cargar 00001000 en W
    IORWF   TEMP, F ; TEMP = 01111000
    MOVF    TEMP, 0
    MOVWF   PORTB   ; Mostrar el valor en PORTB
    CALL    RETARDO

    ; Fila 4: 11001100
    MOVLW   0xC0    ; Cargar 11000000 en W
    MOVWF   TEMP    ; Guardar en TEMP
    MOVLW   0x0C    ; Cargar 00001100 en W
    IORWF   TEMP, F ; TEMP = 11001100
    MOVF    TEMP, 0
    MOVWF   PORTB   ; Mostrar el valor en PORTB
    CALL    RETARDO

    ; Fila 5: 10000110
    MOVLW   0x80    ; Cargar 10000000 en W
    MOVWF   TEMP    ; Guardar en TEMP
    MOVLW   0x06    ; Cargar 00000110 en W
    IORWF   TEMP, F ; TEMP = 10000110
    MOVF    TEMP, 0
    MOVWF   PORTB   ; Mostrar el valor en PORTB
    CALL    RETARDO

    ; Fila 6: 00000011
    MOVLW   0x03    ; Cargar 00000011 en W
    MOVWF   TEMP    ; Guardar en TEMP
    MOVF    TEMP, 0
    MOVWF   PORTB   ; Mostrar el valor en PORTB
    CALL    RETARDO

    ; Fila 7: 00000011 (Repetir)
    MOVF    TEMP, 0   ; Reutilizar TEMP para mostrar nuevamente 00000011
    MOVWF   PORTB     ; Mostrar el valor en PORTB
    CALL    RETARDO

    GOTO    SECUENCIA ; Repetir la secuencia desde el principio

RETARDO
    MOVLW   N       ; Cargar el valor de N en CONT1
    MOVWF   CONT1   ; Guardar en CONT1

REP_1
    MOVLW   N       ; Cargar N en CONT2
    MOVWF   CONT2   ; Guardar en CONT2

REP_2
    DECFSZ  CONT2, 1
    GOTO    REP_2

    DECFSZ  CONT1, 1
    GOTO    REP_1

    RETURN

    END
