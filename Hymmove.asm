asect 0x00
changepzu:
ldi r0, 0xf4
st r0,r1
ldi r0,0xf7
ld r0,r1
if	
	ldi r2,1
	cmp r1,r2
is eq
	bz readbutton	
fi

table:     # each triplet below represents a line of three cells
dc 5,9,13   # horizontal lines
dc 6,10,14   #
dc 7,11,15 #
dc 5,6,7   # vertical lines
dc 9,10,11  #
dc 13,14,15  #
dc 5,10,15  # diagonal lines
dc 7,10,13   #


ldi r0, table # Загружаем таблицу и счётчик
ldi r3,0
ldi r1, 24 

initNext:
ldc r0, r2 # Загружаем из таблицы
st r3, r2 # данные в ОЗУ
inc r0
inc r3
dec r1
bnz initNext

ldi r0,0xf7# проверка таблицы на существование
ldi r1,1
st r0,r1

readbutton:
ldi r0, 0xf3 # Load the button id in r0
while
	ld r0, r1
	tst r1
	stays pl
wend

ldi r2, 0b01111111
and r2, r1

shra r1
shra r1

ldi r2, 24 #счёtчик
ldi r0, 0 #обращение к tаблице
 
CrossOnField:
ld r0, r3	
if 
	cmp r3, r1
is eq
	ldi r3, 0
	st r0, r3
fi
inc r0
dec r2 #обнуление счётчика
bnz CrossOnField

shla r1
shla r1
inc r1
inc r1
ldi r0, 0xf3
st r0, r1

ldi r2, 8 #счёtчик
ldi r0, 0 #обращение к tаблице

win:
ld r0, r1 #1
inc r0
ld r0, r3 #2
inc r0
add r1, r3
ld r0, r1 #3
add r1, r3
if
	tst r3
is z	
	ldi r0,0xf3 #итог - игрок победил
	ldi r1, 0b01000000 #значит полученное значение пойдёт на шину I/Odat, а после в разветвитель и в чип
	st r0, r1 #выводим победу
	wait #конец игре
	halt
fi
inc r0
dec r2
bnz win


ldi r0, 0
ldi r2, 9
ldi r3, 0

draw:
ld r0, r1
add r1, r3
inc r0
dec r2
bnz draw
ldi r1,-16
if
	cmp r3,r1
is eq
	ldi r0,0xf3 
	ldi r1, 0b11000000 
	st r0, r1
	halt 
fi

ldi r1, 0b00000000
br changepzu
end