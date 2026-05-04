      *>>SOURCE FORMAT IS FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. BILLING-SQL.
       AUTHOR. LPCOUTINHO.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       *> Variáveis para receber dados do C
       01  DB-CLIENTE-ID      PIC S9(09) COMP-5.
       01  DB-CLIENTE-NOME    PIC X(51). *> +1 para o null terminator do C
       01  DB-CLIENTE-EMAIL   PIC X(51).
       
       01  WS-RETORNO         PIC S9(04) COMP-5.
       01  WS-DB-NAME         PIC X(20) VALUE Z"db/billing.db".
       01  WS-DISPLAY-ID      PIC Z(09).

       PROCEDURE DIVISION.
       INICIO.
           DISPLAY "SISTEMA DE FATURAMENTO - INTEGRACAO COBOL/C/SQLITE"
           
           *> Conectar ao banco
           CALL "db_connect" USING BY REFERENCE WS-DB-NAME
                             RETURNING WS-RETORNO.

           IF WS-RETORNO NOT = 0
               DISPLAY "ERRO AO CONECTAR AO BANCO: " WS-RETORNO
               STOP RUN
           END-IF.

           *> Preparar Consulta
           CALL "db_prepare_clientes" RETURNING WS-RETORNO.

           DISPLAY "LISTA DE CLIENTES CADASTRADOS (VIA SQL):"
           DISPLAY "----------------------------------------"

           MOVE 0 TO WS-RETORNO.
           PERFORM UNTIL WS-RETORNO NOT = 0
               CALL "db_fetch_cliente" USING BY REFERENCE DB-CLIENTE-ID
                                             BY REFERENCE DB-CLIENTE-NOME
                                             BY REFERENCE DB-CLIENTE-EMAIL
                                       RETURNING WS-RETORNO
               
               IF WS-RETORNO = 0
                   MOVE DB-CLIENTE-ID TO WS-DISPLAY-ID
                   DISPLAY "ID: " WS-DISPLAY-ID " | NOME: " DB-CLIENTE-NOME
               END-IF
           END-PERFORM.

           *> Desconectar
           CALL "db_disconnect".

           DISPLAY "----------------------------------------"
           DISPLAY "PROCESSAMENTO SQL CONCLUIDO COM SUCESSO."
           STOP RUN.
