# Makefile Profissional - COBOL + C + SQLITE

COBC = cobc
CC = gcc
BIN_DIR = bin
SRC_DIR = src/pgm

all: setup build

setup:
	mkdir -p $(BIN_DIR)

build: setup
	# 1. Compilar o Bridge em C (gerando código objeto)
	$(CC) -c $(SRC_DIR)/db_bridge.c -o $(BIN_DIR)/db_bridge.o -lsqlite3
	
	# 2. Compilar o COBOL e linkar com o objeto C e a libsqlite3
	$(COBC) -x -free -O2 -o $(BIN_DIR)/billing $(SRC_DIR)/free/BILLING.cob $(BIN_DIR)/db_bridge.o -lsqlite3

run:
	./$(BIN_DIR)/billing

clean:
	rm -rf $(BIN_DIR)
