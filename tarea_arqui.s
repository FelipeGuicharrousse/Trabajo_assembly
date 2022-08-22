@Los valores de entrada (modo, largo y el arreglo) se trabajan como integers
		.data

modo: 		.int 4
largo:		.int 6
arreglo: 	.int 6,2,4,2,3,8 	
buffer:		.space	100		
text_cateto:	.asciz "El valor del cateto es: "
text_hipotenusa:.asciz "El valor de la hipotenusa es: "
text_distancia:	.asciz "El valor de la distancia es: "
text_promedio:	.asciz "El valor del promedio es: "


	.text

@Condicionales para realizar el modo señalado
	mov r0, #0
	ldr r0, =modo
	ldr r0, [r0,#0]
	cmp r0,#1
	beq modo_1

	cmp r0,#2
	beq modo_2

	cmp r0,#3
	beq modo_3

	cmp r0,#4
	beq modo_4

	b end



modo_1: @Inicio modo 1: Se obtiene el valor del primer cateto y se eleva al cuadrado y se guarda en un regsitro, 
	@luego el mismo procedimiento para el otro cateto, finalmente se suman los valores y se saca la raíz para obtener la hipotenusa.
	mov	r0, #0
	ldr	r7, =arreglo
	ldr	r0, [r7, #0]	
	bl	qfp_int2float   
	mov	r1, r0 		
	bl	qfp_fmu		
	mov	r4, r0		
	ldr	r0, [r7, #4]	
	bl	qfp_int2float
	mov	r1, r0
	bl	qfp_fmul	  
	mov	r1, r4		
	bl	qfp_fadd	
	bl	qfp_fsqrt
	bl	qfp_float2int
	bl	qfp_int2float	
	str	r0, [r7, #8] @Se guarda el resultado(hipotenusa) para después mostrarlo en pantalla	

@Print del valor por pantalla 
	mov	r0, #0		
	mov	r1, #2
	ldr	r2, =text_hipotenusa
	bl	printString
	add	r4, r0, #1	
	ldr	r0, [r7, #8]	
	ldr	r1, =buffer
	mov	r2, #0
	bl 	qfp_float2str
	mov	r0, r4		
	mov	r1, #2
	ldr	r2, =buffer
	bl	printString
	b	end

modo_2: @Inicio modo 2: Se obtiene el valor de la hipotenusa y se eleva al cuadrado y se guarda en un regsitro, 
	@luego el mismo procedimiento para el cateto, finalmente se restan los valores y se saca la raíz para obtener el cateto.
	ldr	r7, =arreglo
	ldr	r0, [r7, #0]	
	bl	qfp_int2float
	mov	r1, r0
	bl	qfp_fmul
	mov	r4, r0		
	ldr	r0, [r7, #4]	
	bl	qfp_int2float
	mov	r1, r0
	bl	qfp_fmul	
	mov	r1, r4		
	bl	qfp_fsub	
	bl	qfp_fsqrt
	bl	qfp_float2int
	bl	qfp_int2float	
	str	r0, [r7, #8] 	@Se guarda el resultado (cateto) para después mostrarlo en pantalla
	
@Print del valor por pantalla
	mov	r0, #0		
	mov	r1, #2
	ldr	r2, =text_cateto
	bl	printString
	add	r4, r0, #1	
	ldr	r0, [r7, #8]	
	ldr	r1, =buffer
	mov	r2, #0
	bl 	qfp_float2str
	mov	r0, r4		
	mov	r1, #2
	ldr	r2, =buffer
	bl	printString
	b 	end

modo_3: @Inicio modo 3: primero se obtienen x2 e x1, se restan y elevan al cuadrado, luego el mismo procedimiento para y2 e y1.
	@Finalmente, se suman los valores que fueron elevados al cuadrado y se saca la raiz para obtener el resultado.
	mov 	r0, #0
    	ldr	r6, =arreglo
    	ldr 	r1, [r6,#8]	 
  	ldr 	r2, [r6, #0]  	
    	sub 	r0, r1, r2  
    	mov 	r7, r0
    	mul 	r0,r7,r0 	
    	mov 	r4, r0 
    	ldr 	r1, [r6,#12]  	
    	ldr 	r2, [r6, #4]  	
    	sub 	r0, r1, r2 
        mov 	r7, r0 
    	mul 	r0,r7,r0	 
    	mov 	r5, r0 		
    	add 	r0, r4,r5
	bl 	qfp_int2float
    	bl 	qfp_fsqrt 
	bl 	qfp_float2int
	bl 	qfp_int2float
    	str 	r0,[r6,#16] @Se guarda el resultado para después mostrarlo en pantalla

@Print del valor por pantalla
    	mov 	r0, #0 
    	mov 	r1, #2 
    	ldr 	r2, =text_distancia
    	bl 	printString
    	add 	r4,r0,#1
    	ldr 	r0, [r6, #16]
    	ldr 	r1, =buffer
    	mov    	r2, #0
    	bl     	qfp_float2str
    	mov    	r0, r4        
        mov    	r1, #2
        ldr    	r2, =buffer
        bl    	printString
	b 	end


modo_4: @Inicio modo 4
@Inicialización de los registros con sus respectivas variables
	mov 	r0, #0
	ldr 	r7, =largo
	ldr 	r7, [r7, #0]
	sub 	r7, r7, #1
	ldr 	r6, =arreglo
	mov	r5, #4
	mul	r5, r7, r5
	ldr	r0, [r6, r5]
		
loop_modo_4: @Loop para sumar todos los valores
	cmp 	r7, #0
	beq 	solucion_modo_4
	mov 	r5, #4
	sub	r7, r7, #1
	mul 	r5, r7, r5
	ldr 	r1, [r6, r5]
	add 	r0, r0, r1
	b 	loop_modo_4

solucion_modo_4:  @Obtención del promedio 
	bl	qfp_int2float
	mov	r3, r0
	ldr 	r0, =largo
	ldr 	r0, [r0, #0]
	bl	qfp_int2float
	mov 	r1, r0
	mov 	r0, r3
	bl 	qfp_fdiv
	bl 	qfp_float2int
	bl 	qfp_int2float
	mov	r7, r0

@Print del valor por pantalla
	mov 	r0, #0 
    	mov 	r1, #2 
    	ldr 	r2, =text_promedio
    	bl 	printString
    	add 	r4,r0,#1
    	mov 	r0, r7
    	ldr 	r1, =buffer
    	mov    	r2, #0
    	bl     	qfp_float2str
    	mov    	r0, r4        
        mov    	r1, #2
        ldr    	r2, =buffer
        bl    	printString
	b 	end
	
@Finalización del programa
end:	wfi

	.end
