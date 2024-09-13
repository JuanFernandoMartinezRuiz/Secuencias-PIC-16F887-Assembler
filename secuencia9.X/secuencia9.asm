; PIC16F887 Configuration Bit Settings
; Assembly source line config statements
#include "p16f887.inc"
; CONFIG1
; __config 0x20D5
 __CONFIG _CONFIG1, _FOSC_INTRC_CLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0x3FFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
 
    LIST P=16F887

N EQU 0xD0      ; constante (EQU palabra reservada para guardar valores en espacios)
cont1 EQU 0x20  ;RETARDO 
cont2 EQU 0x21  ;RETARDO
cont3 EQU 0x22  ;CONTADOR

V1 EQU 0x23
V2 EQU 0x24

    ORG 0x00
    GOTO INICIO  ; GOTO comando para ir hacia
    
INICIO
   
    BSF STATUS,RP0 ;Bank1
    MOVLW 0x71
    MOVWF OSCCON ;Fcsc Interna 8MHz
    CLRF TRISB ; TrisB = 0 salida
 
    BSF STATUS,RP1
    CLRF ANSELH
 
    BCF STATUS,RP0 ;Bank0
    BCF STATUS,RP1
 
SECUENCIA9
    
    MOVLW 0x80
    MOVWF V1 
    
    MOVLW 0x01
    MOVWF V2
   
    MOVLW 0x04
    MOVWF cont3   
        
LOOP1
    
    MOVF V1,0
    IORWF V2,0
    MOVWF PORTB
    
    CALL DELAY
    
    BCF STATUS,C ;Verifica si hay un carry y lo elimina
    RRF V1 ;Mover a la derecha
    MOVLW 0x02
    ADDWF V2,1 ; Suma W del contenido de V1 y almacena el resultado en V2
    
    DECFSZ cont3,1
    
    GOTO LOOP1
  
    MOVLW 0x10
    MOVWF V1
  
    MOVLW 0x04
    MOVWF cont3
 
LOOP2

    MOVF V1,0 
    IORWF V2,0
    MOVWF PORTB
    
    CALL DELAY
    
    BCF STATUS,C ; Eliminar Carry
    RLF V1 ;Mover a la izquierda
    
    MOVLW 0x02
    ADDWF V2,1 ; Suma W del contenido de V1 y almacena el resultado en V2
    
    DECFSZ cont3,1
    GOTO LOOP2 
    GOTO SECUENCIA9	    

DELAY
  CALL RETARDO  ; Un retardo
  RETURN 

RETARDO
    MOVLW N
    MOVWF cont1
    
RETARDO1
    MOVLW N
    MOVWF cont2
    
RETARDO2
    DECFSZ cont2,1
    GOTO RETARDO2
    
    DECFSZ cont1,1
    GOTO RETARDO1
    
    RETURN
    
 End
