;*******************************************
; Sorting Algorithm Comparator
; Name: Rida Mir | Reg: 24-CS-61 | Sec: C
;*******************************************

.include "m32def.inc"
.dseg
array:    .byte 10          ; array of 10 elements in SRAM
temp_arr: .byte 10          ; temp copy for each sort

.cseg
.org 0x00
    rjmp MAIN
;-------------------------------------------
; MAIN
;-------------------------------------------
MAIN:
    ldi r16, LOW(RAMEND)
    out SPL, r16
    ldi r16, HIGH(RAMEND)
    out SPH, r16

    rcall LOAD_ARRAY        ; load original data
    rcall BUBBLE_SORT       ; run bubble sort

    rcall LOAD_ARRAY        ; reload original data
    rcall SELECTION_SORT    ; run selection sort

    rcall LOAD_ARRAY        ; reload original data
    rcall INSERTION_SORT    ; run insertion sort

DONE:
    rjmp DONE               ; loop forever


;-------------------------------------------
; LOAD_ARRAY - loads unsorted data into SRAM
; Array: {9, 3, 7, 1, 5, 8, 2, 6, 4, 0}
;-------------------------------------------
LOAD_ARRAY:
    ldi XH, HIGH(array)
    ldi XL, LOW(array)

    ldi r16, 9
    st X+, r16
    ldi r16, 3
    st X+, r16
    ldi r16, 7
    st X+, r16
    ldi r16, 1
    st X+, r16
    ldi r16, 5
    st X+, r16
    ldi r16, 8
    st X+, r16
    ldi r16, 2
    st X+, r16
    ldi r16, 6
    st X+, r16
    ldi r16, 4
    st X+, r16
    ldi r16, 0
    st X+, r16

    ret

;-------------------------------------------
; BUBBLE SORT
; Outer loop: r20 = pass counter (N-1 = 9)
; Inner loop: r21 = comparison counter
;-------------------------------------------
BUBBLE_SORT:
    ldi r20, 9              ; outer loop count = N-1

BS_OUTER:
    tst r20
    breq BS_DONE

    ldi r21, 9              ; inner loop count = N-1
    ldi XH, HIGH(array)
    ldi XL, LOW(array)

BS_INNER:
    tst r21
    breq BS_NEXT_PASS

    ld r16, X+              ; load arr[i]
    ld r17, X               ; load arr[i+1]

    cp r16, r17             ; compare
    brlo BS_NO_SWAP         ; if arr[i] < arr[i+1], no swap

    ; SWAP
    st X, r16               ; arr[i+1] = r16
    ld r18, -X              ; go back
    st X, r17               ; arr[i] = r17
    adiw XL, 1              ; move forward again

BS_NO_SWAP:
    dec r21
    rjmp BS_INNER

BS_NEXT_PASS:
    dec r20
    rjmp BS_OUTER

BS_DONE:
    ret

;-------------------------------------------
; SELECTION SORT
; r20 = outer index i (0 to N-2)
; r21 = inner index j (i+1 to N-1)
; r22 = min index
;-------------------------------------------
SELECTION_SORT:
    ldi r20, 0              ; i = 0

SS_OUTER:
    cpi r20, 9              ; i < N-1 ?
    brge SS_DONE

    mov r22, r20            ; min_index = i

    ; load array[i] into r23
    ldi XH, HIGH(array)
    ldi XL, LOW(array)
    add XL, r20
    brcc SS_NO_CARRY1
    inc XH
SS_NO_CARRY1:
    ld r23, X               ; r23 = array[min_index]

    mov r21, r20
    inc r21                 ; j = i + 1

SS_INNER:
    cpi r21, 10             ; j < N ?
    brge SS_DO_SWAP

    ldi XH, HIGH(array)
    ldi XL, LOW(array)
    add XL, r21
    brcc SS_NO_CARRY2
    inc XH
SS_NO_CARRY2:
    ld r24, X               ; r24 = array[j]

    cp r24, r23             ; array[j] < min ?
    brge SS_NO_NEW_MIN

    mov r22, r21            ; min_index = j
    mov r23, r24            ; update min value

SS_NO_NEW_MIN:
    inc r21
    rjmp SS_INNER

SS_DO_SWAP:
    cp r22, r20             ; if min_index == i, no swap
    breq SS_NEXT

    ; load array[i]
    ldi XH, HIGH(array)
    ldi XL, LOW(array)
    add XL, r20
    brcc SS_NC3
    inc XH
SS_NC3:
    ld r24, X               ; r24 = array[i]

    ; load array[min_index]
    ldi YH, HIGH(array)
    ldi YL, LOW(array)
    add YL, r22
    brcc SS_NC4
    inc YH
SS_NC4:
    ld r25, Y               ; r25 = array[min_index]

    ; swap
    st X, r25               ; array[i] = array[min_index]
    st Y, r24               ; array[min_index] = array[i]

SS_NEXT:
    inc r20
    rjmp SS_OUTER

SS_DONE:
    ret

;-------------------------------------------
; INSERTION SORT
; r20 = outer index i (1 to N-1)
; r21 = key value
; r22 = j (inner index)
;-------------------------------------------
INSERTION_SORT:
    ldi r20, 1              ; i = 1

IS_OUTER:
    cpi r20, 10             ; i < N ?
    brge IS_DONE

    ; key = array[i]
    ldi XH, HIGH(array)
    ldi XL, LOW(array)
    add XL, r20
    brcc IS_NC1
    inc XH
IS_NC1:
    ld r21, X               ; r21 = key

    mov r22, r20
    dec r22                 ; j = i - 1

IS_INNER:
    cpi r22, 0xFF           ; j < 0 ? (0xFF = -1 in unsigned)
    breq IS_INSERT

    ; load array[j]
    ldi XH, HIGH(array)
    ldi XL, LOW(array)
    add XL, r22
    brcc IS_NC2
    inc XH
IS_NC2:
    ld r23, X               ; r23 = array[j]

    cp r23, r21             ; array[j] > key ?
    brlo IS_INSERT          ; if array[j] <= key, insert here

    ; array[j+1] = array[j]
    ldi YH, HIGH(array)
    ldi YL, LOW(array)
    mov r24, r22
    inc r24
    add YL, r24
    brcc IS_NC3
    inc YH
IS_NC3:
    st Y, r23               ; array[j+1] = array[j]

    dec r22
    rjmp IS_INNER

IS_INSERT:
    ; array[j+1] = key
    ldi YH, HIGH(array)
    ldi YL, LOW(array)
    mov r24, r22
    inc r24
    add YL, r24
    brcc IS_NC4
    inc YH
IS_NC4:
    st Y, r21               ; place key

    inc r20
    rjmp IS_OUTER

IS_DONE:
    ret