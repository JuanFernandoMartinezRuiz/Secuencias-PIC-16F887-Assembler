#include "p16f887.inc"

; CONFIG1
 __CONFIG _CONFIG1, _FOSC_INTRC_CLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_ON & _LVP_OFF
; CONFIG2
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF

 LIST p=16F887

TEMP    EQU 0x20  ; Variable temporal para almacenar el patrón
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

    ; Iniciar la secuencia cargando 10000000
    MOVLW   0x80    ; Fila 0: 10000000
    MOVWF   TEMP    ; Guardar en TEMP

SECUENCIA:
    MOVF    TEMP, 0
    MOVWF   PORTB   ; Mostrar el valor en PORTB
    CALL    RETARDO

    ; Agregar un bit encendido en la siguiente posición a la derecha
    RRF     TEMP, F ; Rotar TEMP a la derecha
    MOVLW   0x80    ; Cargar 10000000 en W
    IORWF   TEMP, F ; Agregar un 1 en el bit más significativo (B7)

    ; Verificar si todos los bits están encendidos (TEMP = 11111111)
    MOVF    TEMP, W
    XORLW   0xFF    ; Comparar TEMP con 11111111
    BTFSC   STATUS, Z ; Si son iguales, mostrar y luego reiniciar la secuencia
    GOTO    MOSTRAR_FINAL

    GOTO    SECUENCIA

MOSTRAR_FINAL:
    MOVF    TEMP, 0
    MOVWF   PORTB   ; Asegurarse de mostrar 11111111
    CALL    RETARDO
    GOTO    REINICIAR

REINICIAR:
    MOVLW   0x80    ; Reiniciar la secuencia con 10000000
    MOVWF   TEMP
    GOTO    SECUENCIA

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
