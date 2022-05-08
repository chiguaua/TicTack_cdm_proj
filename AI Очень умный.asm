asect 0x00

changeROM: #We change ROM
ldi r0, 0xf4
st r0,r1
ldi r0,0
ld r0,r1
if
	tst r1
is nz
	bz ReadingData	
fi

ReadingData:

ldi r0,0
ldi r2,8

#First We check whether two zeroes are next
#to each other
TacticForZeroes:
ld r0,r3 
inc r0
ld r0,r1
add r1,r3
inc r0 
ld r0,r1
if 
	tst r1
is gt
	ldi r1,-8
	if #if the sum of two cells is -8
		cmp r3,r1 #then we put zero
	is eq #in the third cell and AI wins
		ld r0,r1
		br PlacingZero
	fi
fi

ld r0,r3
dec r0 
dec r0 
ld r0,r1
add r1,r3
inc r0 
ld r0,r1
if 
	tst r1
is gt
	ldi r1,-8
	if 
		cmp r3,r1
	is eq 
		ld r0,r1
		br PlacingZero
	fi
fi

ld r0,r3 
inc r0 
ld r0,r1
add r1,r3
dec r0 
dec r0
ld r0,r1
if 
	tst r1
is gt
	ldi r1,-8
	if 
		cmp r3,r1
	is eq 
		ld r0,r1
		br PlacingZero
	fi
fi

inc r0
inc r0 
inc r0 
dec r2
bnz TacticForZeroes

ldi r0,0
ldi r2,8

#Secondly,we check whether two crosses are next
#to each other
TacticForCrosses:
ld r0,r3
inc r0 
ld r0,r1
add r1,r3
inc r0 
ld r0,r1
if 
	tst r1
is gt
	if 
		tst r3
	is eq 			
		br PlacingZero
	fi
fi

ld r0,r3
dec r0 
dec r0 
ld r0,r1
add r1,r3
inc r0 
ld r0,r1
if 
	tst r1
is gt
	if 
		tst r3
	is eq 
		br PlacingZero
	fi
fi

ld r0,r3 
inc r0 
ld r0,r1
add r1,r3
dec r0 
dec r0
ld r0,r1
if 
	tst r1
is gt
	if 
		tst r3
	is eq 
		br PlacingZero
	fi
fi

inc r0 
inc r0 
inc r0 
dec r2
bnz TacticForCrosses

#Then, we check if the central cell is free
CentralCell: 
ldi r0,0 
ldi r1,4
add r1,r0
ld r0,r2
if
	tst r2
is gt
	ld r0,r1
	br PlacingZero
fi

#If everything is fine with the previous checks
#We just put a zero in the first free cell
FirstFree: 
ldi r0,0  
dec r0 
while  
 inc r0 
 ld r0,r1 
 tst r1 
stays le

wend
	
#We change the values in the table to put
#a zero there
PlacingZero:

ldi r2, 24 
ldi r0, 0
 
ZeroInTable:
ld r0, r3	
if 
	cmp r3, r1
is eq
	ldi r3, -4
	st r0, r3
fi
inc r0
dec r2 
bnz ZeroInTable

shla r1
shla r1
inc r1
ldi r2,0xf3
st r2,r1


ldi r2, 8 
ldi r0, 0 


#if summ of the numbers in triplet is -12
#then it is a triplet of zeroes
LoseCheck:
ld r0, r1 
inc r0
ld r0, r3 
inc r0
add r1, r3
ld r0, r1
add r1, r3
ldi r1,-12
if
	cmp r3, r1
is eq
	ldi r0,0xf3 
	ldi r1, 0b10000000 
	st r0, r1 
	halt
fi
inc r0
dec r2
bnz LoseCheck

ldi r1 , 0b00000000
br changeROM
end 