#Author: Xuyang ZHang

	.file	"lab7.s"
		.data
sizeIntArrays:
	.long 5
IntArray1:
	.long 69
	.long 95
	.long 107
	.long 12
	.long 332
IntArray2:
	.long 27
	.long -87
	.long 331
	.long -49
	.long -88
PrintString:
	.string "Brutus\n"

.section	.rodata			
.LC0:
	.string	"Elements in IntArray1:\n"
.LC1:
	.string	"Elements in IntArray2:\n"
.LC2:
	.string	"Integer Sums\n"
.LC3: 
	.string	"Individual Characters\n"
.LC4:
	.string	"%d\n"
.LC5:
	.string "\n"
.LC6:
	.string "%c\n"

.text

#addInts(int size, int *array1, int *array2)
.globl addInt
	.type	addInt, @function
addInt:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	pushq	%r12
	movslq 	(%rdi), %r12		#store size in %ebx
	movq	$0, %rbx
	movl	$.LC2, %edi
	movl 	$0, %eax
	call 	printf		
	jmp 	test			#use a while loop
.L1:	
	movq	$IntArray1, %rsi	#restore array pointer
	movq	$IntArray2, %rdi
	movl	(%rsi, %rbx, 4), %r8d	#copy element in array1
	decq	%r12
	movl	(%rdi, %r12,4), %r9d	#copy element in array2
	add	%r8d, %r9d		#add two elements
					#print the sum
	movq	$.LC4, %rdi			
	movl 	%r9d, %esi
	movq 	$0, %rax
	call 	printf	
	incq	%rbx		
	
test: 	
	cmp	$0, %r12d
	jg	.L1
Done:
	movq	$.LC5, %rdi		#print a blank line 
	movq 	$0, %rax
	call 	printf
	popq %r12			#restore callee-saved register
	popq %rbx
	leave
	ret
	.size	addInt, .-addInt




#void printIntArray(int size, int *array1, char *string1)
.globl printIntArray
	.type	printIntArray, @function
printIntArray:
	pushq	%rbp
	movq	%rsp, %rbp
					#push callee-saved register
	pushq	%rbx
	pushq	%r12
	pushq   %r13
	movslq	(%rdi), %r12
	movq 	$0, %rbx		#index=0
	movq 	%rsi, %r13		#array pointer
	movq	%rdx, %rdi
	movq 	$0, %rax
	call 	printf	
.L2:	
	cmp	%r12, %rbx		#check if it's array end
	jge	Done2
	movl	(%r13, %rbx, 4), %eax	#copy array element
	incq 	%rbx			#index++
	movq	$.LC4, %rdi			
	movl 	%eax, %esi
	movq 	$0, %rax
	call 	printf
	jmp	.L2
	
Done2:
	movq	$.LC5, %rdi		#print a blank line 
	movq 	$0, %rax
	call 	printf
	popq %r13
	popq %r12			#restore call-saved register
	popq %rbx
	leave
	ret
	.size	printIntArray, .-printIntArray




#void printChars(char *string1)
.globl printChars
	.type	printChars, @function
printChars:
	pushq 	%rbp							
	movq	%rsp, %rbp
	pushq	%rbx
	pushq	%r12
	movq	%rsi, %rbx	#string pointer
	movq	$0, %r12
	movq	$.LC3, %rdi
	movq 	$0, %rax
	call 	printf	
.L3:	
	movb	(%rbx, %r12,1), %sil
	cmp	$0, %sil
	je	Done3
	movsbq	%sil, %rsi
	movq	$.LC6, %rdi
	movq 	$0, %rax
	call 	printf
	incq	%r12
	jmp	.L3

Done3:
	popq %r12			#restore call-saved register
	popq %rbx
	leave
	ret
	.size	printChars, .-printIntChars


.globl main
	.type	main, @function
main:
	pushq 	%rbp							
	movq	%rsp, %rbp
					# not pushing any caller saved  registers
					# because no saved data in any of them
					# for any call below
					# caller saved registers for X86 are:
					# %rax, %rdi, %rsi, %rdx, %rcx
					# %r8, %r9, %r10, %r11
	movq	$sizeIntArrays, %rdi
	movq	$IntArray1, %rsi
	movq	$.LC0, %rdx
	call printIntArray
	movq	$sizeIntArrays, %rdi
	movq	$IntArray2, %rsi
	movq	$.LC1, %rdx	
	call	printIntArray
	movq	$sizeIntArrays, %rdi
	movq	$IntArray1, %rsi
	movq	$IntArray2, %rdx
	call	addInt
	movq	$PrintString, %rsi
	call	printChars
	leave
	ret
	.size	main, .-main
