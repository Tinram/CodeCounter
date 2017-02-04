
# makefile for Code Counter

CC = fbc
CFLAGS = -gen gcc -O max -w all
NAME = codecounter
INPUTLIST = codecounter.bas


codecounter:
	$(CC) $(CFLAGS) $(INPUTLIST) -x $(NAME)

install:
	sudo cp $(NAME) /usr/local/bin/$(NAME)
	@echo "Attempted to copy $(NAME) to /usr/local/bin"
