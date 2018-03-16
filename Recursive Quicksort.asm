#	Lucas Rappette
#	MIPS: QuickSort

#	Begin Data Segment
	.data
	
array: 	.space	80												#int[] array = new int[20];	
size:	.word 	0												#int size = 0;
comsp:	.asciiz ", "											#comma-space segment for array print out
		.align	2												#align data segment after each String
msg1:	.asciiz	"The elements sorted in ascending order are: "	#Message Output 1
		.align	2												#align data segment after each String


#		Begin Text Segment
	.text
	
MAIN:	la $s0, array											#Load address of array into memory
		la $s1, size											#Load address of size to memory
		lw $s1, 0($s1)											#size = 0
		addi $v0, $zero, 5										#Set syscall to read an int from the user
		syscall													#Get int "n"
		add $s1, $v0, $zero										#size = n;
		beq $s1, $zero, QUIT									#quit program if array size is 0.
		jal INIAR												#Initialize Array()
		add $a0, $s0, $zero										#Pass array[] address to argument 0 for QS
		add $a1, $zero, $zero									#Pass first index to arg. 1 for QS
		addi $a2, $s1, -1										#Pass second; index to arg. 2 for QS
		jal QS													#quickSort(array, 0, size -1);
		add $s2, $zero, $zero									#i = 0;
		addi $v0, $zero, 4										#Set syscall to print
		la $a0, msg1											#Pass message to print
		syscall													#Print
		jal PRINT												#PrintArray()
		j QUIT													#Exit Program
	
QUIT:	addi $v0, $zero, 10										# system call for exit
		syscall													# clean termination of program

#--------------------------------Void Initialize Array()-----------------------------------------------------

INIAR:	slt $t0, $s2, $s1										#i < size
		beq $t0, $zero, INIEX									#exit when !(i < size)
		addi $v0, $zero, 5										#Set syscall to read an int from the user
		syscall													#Get new int "n"
		add $t1, $s2, $zero										#Set i to a temp variable
		sll $t1, $t1, 2											#i * 4 
		add $t1, $t1, $s0										#Address of array[i];
		sw $v0, ($t1)											#ar[i] = n;
		addi $s2, $s2, 1										#i++;
		j INIAR													#Loop
INIEX:
		jr $ra													#return
#-------------------------------End Initialize Array------------------------------------------------------------


#-----------------------int Partition Sort (int arr[], left, right)---------------------------------------------

PR:	addi $sp, $sp, -24											#Reserve space on stack for variables needed
		sw $s0, 0($sp)											#add s register to stack
		sw $s1, 4($sp)											#add s register to stack
		sw $s2, 8($sp)											#add s register to stack
		sw $s3, 12($sp)											#add s register to stack
		sw $s4, 16($sp)											#add s register to stack
		sw $s5, 20($sp)											#add s register to stack
		add $s0, $a1, $zero 									#i = left
		add $s1, $a2, $zero										#j = right
		add $s2, $zero, $zero									#int tmp;
		add $t0, $s0, $s1										#left + right
		srl $t0, $t0, 1											#left + right / 2
		sll $t0, $t0, 2											#(left +right) /2 * 4
		add $t0, $t0, $a0										#address of arr[(left + right) /2)
		lw $s3, 0($t0)											#int pivot = arr[left + right / 2];
	
WHILE1:	slt $t1, $s1, $s0										#j < i
		bne $t1, $zero, RETURN									#while(i <= j)
	
WHILE2:	add $t0, $s0, $zero 									#set i to a temp variable
		sll $t0, $t0, 2											#i * 4
		add $t0, $a0, $t0										#arr[i] address
		lw $s4, 0($t0)											#arr[i] value
		slt $t2, $s4, $s3										#(arr[i] < pivot)
		beq $t2, $zero, WHILE3 									#while(arr[i] < pivot)
		addi $s0, $s0, 1										#i++;
		j WHILE2												#Inner Loop
WHILE3:	add $t0, $s1, $zero 									#set j to a temp variable
		sll $t0, $t0, 2											#j * 4
		add $t0, $a0, $t0										#arr[j] address
		lw $s5, 0($t0)											#arr[j] value
		slt $t2, $s3, $s5										#(pivot < arr[j])
		beq $t2, $zero, WCONDI									#while(pivot < arr[j])
		addi $s1, $s1, -1										#j--;
		j WHILE3												#Inner Loop
			
WCONDI:	slt $t1, $s1, $s0										#j < i
		bne $t1, $zero, WHILE1									#if (i <= j), else loop
		add $s2, $s4, $zero										#temp = arr[i];
		add $t0, $s0, $zero 									#set i to a temp variable
		sll $t0, $t0, 2											#i * 4
		add $t0, $a0, $t0										#arr[i] address
		sw $s5, 0($t0)											#arr[i] = arr[j]
		add $t0, $s1, $zero 									#set j to a temp variable
		sll $t0, $t0, 2											#j * 4
		add $t0, $a0, $t0										#arr[j] address
		sw $s4, 0($t0)											#arr[j] = tmp;
		addi $s0, $s0, 1										#i++;
		addi $s1, $s1, -1										#j--
		j WHILE1												#loop
		
RETURN:	add $v0, $s0, $zero										#Set the value of i to be returned
		lw $s0, 0($sp)											#Restore s register from stack
		lw $s1, 4($sp)											#Restore s register from stack
		lw $s2, 8($sp)											#Restore s register from stack
		lw $s3, 12($sp)											#Restore s register from stack
		lw $s4, 16($sp)											#Restore s register from stack
		lw $s5, 20($sp)											#Restore s register from stack
		addi $sp, $sp, 24										#Restore Stack Pointer
		jr $ra													#return
		
#-------------------------End Partition Sort ------------------------------------------------------------------


#-------------------------void quickSort(int arr[], int left, int right)------------------------------------------

QS:		addi $sp, $sp, -20										#Reserve space on stack for variables needed
		sw $a0, 0($sp)											#Save a0 to stack for recursive call
		sw $a1, 4($sp)											#Save a1 to stack for recursive call
		sw $a2, 8($sp)											#Save a2 to stack for recursive call
		sw $ra, 12($sp)											#Save ra to stack for recursive call
		sw $s0, 16($sp)											#Save s register to stack
		jal PR													#partition(arr, left, right);
		add $s0, $v0, $zero										#index = partition(arr, left, right);
		slt $t0, $s0, $a2										#index < right
		bne $t0, $zero, QS1										#if (index < right), recursive call
QS2INQ:	addi $s0, $s0, -1										#index -1
		slt $t1, $a1, $s0										#(left < index -1)
		bne $t1, $zero, QS2										#if (left < index - 1), recursive call
		j QSEND													#end if neither case reached
QS1:	add $a1, $s0, $zero										#set Argument for quickSort
		jal QS													#quickSort(arr, index, right)
		lw $a1, 4($sp)											#Reset Argument 1
		j QS2INQ												#GOTO conditional #2
QS2:	add $a2, $s0, $zero										#Set argument for quickSort
		jal QS													#quickSort(arr, left, index - 1)
		j QSEND													#End method
QSEND:	lw $a0, 0($sp)											#Restore a0 from stack
		lw $a1, 4($sp)											#Restore a1 from stack
		lw $a2, 8($sp)											#Restore a2 from stack
		lw $ra, 12($sp)											#Restore ra from stack
		lw $s0, 16($sp)											#Restore s register from stack
		addi $sp, $sp, 20										#Restore stack pointer
		jr $ra													#Return nothing
		
#---------------------------End Recursive Quick Sort--------------------------------------------------------------

#-----------------------void PrintArray()------------------------------------------------------------------------

PRINT:	add $t1, $s2, $zero 									#Set i to a temp variable
		sll $t1, $t1, 2											#i * 4 
		add $t1, $t1, $s0										#Address of array[i];
		lw $t2, 0($t1)											#Load int into t2
		addi $v0, $zero, 1										#Set syscall to print an int.
		la $a0, ($t2)											#Set int to be printed
		syscall													#Print int
		addi $v0, $zero, 4										#Set syscall to print
		la $a0, comsp											#Pass comma/space to print
		addi $t3, $s1, -1										#t3 = size - 1
		beq $t3, $s2 PEXIT										#if i == size - 1, exit.
		syscall													#Print ", "
		addi $s2, $s2, 1										#i++
		j PRINT													#Loop
PEXIT:	jr $ra													#return

#----------------------End PrintArray--------------------------------------------------------------------------------
#End Text Segment
