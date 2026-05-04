      *>>SOURCE FORMAT IS FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. BILLING-SQL.
       AUTHOR. LPCOUTINHO.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       
       EXEC SQL INCLUDE SQLCA END-EXEC.

       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01  DB-CLIENTE-ID      PIC S9(09) COMP-5.
       01  DB-CLIENTE-NOME    PIC X(50).
       01  DB-CLIENTE-EMAIL   PIC X(50).
       EXEC SQL END DECLARE SECTION END-EXEC.

       01  WS-DISPLAY-ID      PIC Z(09).

       PROCEDURE DIVISION.
       INICIO.
           DISPLAY "SISTEMA DE FATURAMENTO - CONECTANDO AO SQLITE..."
           
           EXEC SQL 
               CONNECT TO 'db/billing.db'
           END-EXEC.

           IF SQLCODE NOT = 0
               DISPLAY "ERRO AO CONECTAR AO BANCO: " SQLCODE
               STOP RUN
           END-IF.

           DISPLAY "LISTA DE CLIENTES CADASTRADOS:"
           DISPLAY "----------------------------------------"

           EXEC SQL
               DECLARE CUR_CLI CURSOR FOR
               SELECT id, nome, email FROM clientes
           END-EXEC.

           EXEC SQL OPEN CUR_CLI END-EXEC.

           PERFORM UNTIL SQLCODE NOT = 0
               EXEC SQL
                   FETCH CUR_CLI INTO :DB-CLIENTE-ID, :DB-CLIENTE-NOME, :DB-CLIENTE-EMAIL
               END-EXEC
               
               IF SQLCODE = 0
                   MOVE DB-CLIENTE-ID TO WS-DISPLAY-ID
                   DISPLAY "ID: " WS-DISPLAY-ID " | NOME: " DB-CLIENTE-NOME
               END-IF
           END-PERFORM.

           EXEC SQL CLOSE CUR_CLI END-EXEC.
           
           EXEC SQL DISCONNECT CURRENT END-EXEC.

           DISPLAY "----------------------------------------"
           DISPLAY "PROCESSAMENTO CONCLUIDO."
           STOP RUN.
