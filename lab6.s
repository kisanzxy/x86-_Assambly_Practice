#Author: Xuyang ZHang

	.file	"lab6.s"
		.data
sizeQArrays:
	.quad	6
QArray1:
	.quad	10
	.quad	25
	.quad	33
	.quad	48
	.quad	125
	.quad	550
QArray2:
	.quad	20
	.quad	-37
	.quad	42
	.quad	-61
	.quad	75
	.quad	117

.section	.rodata			#strings
.LC0:
	.string	"Products\n"
.LC1:
	.string	"%d\n"
.LC2:
	.string	"\n"
.LC3:
	.string	"Elements in QArray1:\n"
	.text

#multQuad(long size, long *array1, long*array2)
.globl multQuad
	.type	multQuad, @function
multQuad:

	pushq	%rbp
	movq	%rsp, %rbp
					#push callee-saved register
	pushq	%rbx
	pushq	%r12
	movq	$sizeQArrays, %r12
	movq 	$0, %rbx		#index=0
	movq	$.LC0, %rdi
	movq 	$0, %rax
	call 	printf	
		
.L2:
	movq	$QArray1, %rsi		# array1 
	movq	$QArray2, %rdi		# array2 
	movq	(%r12), %rax
	cmpq	%rax, %rbx	
	jge	Done
	movq	(%rsi, %rbx, 8), %r8
	movq	(%rdi, %rbx, 8), %r9		
	imulq	%r8, %r9
	incq 	%rbx			#index++
	movq	$.LC1, %rdi			
	movq 	%r9, %rsi
	movq 	$0, %rax
	call 	printf			#print the products
	jmp 	.L2	
	
Done:
	movq	$.LC2, %rdi		#print a blank line 
	movq 	$0, %rax
	call 	printf
	popq %r12			#restore call-saved register
	popq %rbx
	leave
	ret
	.size	multQuad, .-multQuad

#printQArray

.globl printQArray
	.type	printQArray, @function
printQArray:
	pushq	%rbp
	movq	%rsp, %rbp
					#push callee-saved register
	pushq	%rbx
	pushq	%r12
	movq	$sizeQArrays, %r12
	movq 	$0, %rbx		#index=0
	movq	$.LC3, %rdi
	movq 	$0, %rax
	call 	printf	
.L3:
	movq	$QArray1, %rsi		# array1 
	movq	(%r12), %rax		
	cmpq	%rax, %rbx		#check if it's array end
	jge	Done2
	movq	(%rsi, %rbx, 8), %rax	#copy array element
	incq 	%rbx			#index++
	movq	$.LC1, %rdi			
	movq 	%rax, %rsi
	movq 	$0, %rax
	call 	printf
	jmp	.L3
	
Done2:
	movq	$.LC2, %rdi		#print a blank line 
	movq 	$0, %rax
	call 	printf
	popq %r12			#restore call-saved register
	popq %rbx
	leave
	ret
	.size	printQArray, .-printQArray

#invertArray	
.globl invertArray
	.type	invertArray, @function
invertArray:
	pushq	%rbp
	movq	%rsp, %rbp
					#push callee-saved register
	pushq	%r12
	pushq	%rbx
	movq	$sizeQArrays, %r12	
	movq	(%r12), %rbx		# store size, set as back pointer
	decq	%rbx
	movq 	$0, %rax		#front pointer
	movq	$QArray1, %rsi		# array1
	cmpq	%rax, %rbx		# if only have one element, do nothing
	je	Done3	
.L4:
	cmpq	%rax, %rbx
	jl	Done3			
	movq	(%rsi, %rax, 8), %rcx 	#copy array element
	movq	(%rsi, %rbx, 8), %r8
					#swap array1[i]and array[size-1-i]
	leaq	(%rsi, %rax, 8), %r9
	leaq	(%rsi, %rbx, 8), %rdi
	movq    %rcx, (%rdi)
	movq	%r8, (%r9)
	incq	%rax			#front pointer->next		
	decq	%rbx			#back pointer->previous
	jmp	.L4			
	
Done3:
	popq %rbx			#restore call-saved register
	popq %r12
	leave
	ret
	.size	invertArray, .-invertArray

	
	

.globl main
	.type	main, @function
main:
	pushq %rbp							
	movq	%rsp, %rbp
					# not pushing any caller saved  registers
					# because no saved data in any of them
					# for any call below
					# caller saved registers for X86 are:
					# %rax, %rdi, %rsi, %rdx, %rcx
					# %r8, %r9, %r10, %r11
	call	multQuad
	call 	printQArray
	call	invertArray
	call	printQArray
	call	multQuad
	leave
	ret
	.size	main, .-main
