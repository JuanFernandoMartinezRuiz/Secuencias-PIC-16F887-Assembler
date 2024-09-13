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
    CLRF    PORTA       ; Limpiar PORTA
    CLRF    PORTB       ; Limpiar PORTB
    BSF     STATUS, RP0  ; Seleccionar Banco 1
    CLRF    TRISA       ; Configurar PORTA como salida
    CLRF    TRISB       ; Configurar PORTB como salida
    BSF     STATUS, RP1
    CLRF    ANSEL       ; Configurar pines como digitales
    BCF     STATUS, RP0  ; Seleccionar Banco 0
    BCF     STATUS, RP1

    ; Cargar el valor inicial para la primera parte de la secuencia
    MOVLW   0x80    ; Fila 0: 10000000
    MOVWF   TEMP    ; Guardar en TEMP

SECUENCIA1:
    MOVF    TEMP, 0
    MOVWF   PORTB   ; Mostrar el valor en PORTB
    CALL    DELAY

    ; Incrementar bits encendidos a la izquierda
    RRF     TEMP, F ; Rotar derecha
    BTFSC   TEMP, 3 ; Si el bit 3 está en 1 (TEMP = 00001000), saltar a la segunda parte
    GOTO    SECUENCIA1_CONTINUA

    ; Para las primeras tres filas:
    MOVLW   0x80    ; Cargar 10000000 en W
    IORWF   TEMP, F ; OR lógico con TEMP para agregar un bit a la izquierda
    GOTO    SECUENCIA1

SECUENCIA1_CONTINUA:
    ; Pasar a la segunda parte de la secuencia
    MOVLW   0x08    ; Fila 4: 00001000
    MOVWF   TEMP    ; Guardar en TEMP

SECUENCIA2:
    MOVF    TEMP, 0
    MOVWF   PORTB   ; Mostrar el valor en PORTB
    CALL    DELAY

    ; Desplazar bits encendidos a la derecha
    RRF     TEMP, F ; Rotar derecha para desplazar los bits
    BTFSC   TEMP, 0 ; Verificar si el bit 0 está en 1 (00000001)
    GOTO    REINICIAR
    GOTO    SECUENCIA2

REINICIAR:
    MOVF    TEMP, 0
    MOVWF   PORTB   ; Mostrar la última fila 00000001
    CALL    DELAY
    MOVLW   0x80    ; Reiniciar la secuencia con 10000000
    MOVWF   TEMP    ; Preparar para la siguiente secuencia
    GOTO    SECUENCIA1  ; Volver al inicio de la secuencia

DELAY
    CALL    RETARDO  ; Llamar al primer retardo
    CALL    RETARDO  ; Llamar al segundo retardo
    RETURN

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
