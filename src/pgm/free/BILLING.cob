      *>>SOURCE FORMAT IS FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. BILLING-SQL.
       AUTHOR. LPCOUTINHO.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       *> Host Variables para o Bridge C
       01  DB-FATURA-ID       PIC S9(09) COMP-5.
       01  DB-CLIENTE-NOME    PIC X(51).
       01  DB-VALOR-BRUTO     COMP-2. *> Double Precision Float
       
       *> Variáveis de Lógica de Negócio
       01  WS-VALOR-IMPOSTO   COMP-2.
       01  WS-VALOR-LIQUIDO   COMP-2.
       01  WS-PERCENT-IMP     COMP-2 VALUE 0.10. *> 10% de Imposto
       
       01  WS-RETORNO         PIC S9(04) COMP-5.
       01  WS-DB-NAME         PIC X(20) VALUE Z"db/billing.db".
       01  WS-STATUS-PROC     PIC X(11) VALUE Z"PROCESSADO".
       
       *> Variáveis de Exibição
       01  WS-DISP-ID         PIC Z(09).
       01  WS-DISP-VALOR      PIC ZZZZZ9,99.

       PROCEDURE DIVISION.
       INICIO.
           DISPLAY "========================================"
           DISPLAY "SISTEMA DE PROCESSAMENTO DE FATURAS SQL"
           DISPLAY "========================================"
           
           CALL "db_connect" USING BY REFERENCE WS-DB-NAME
                             RETURNING WS-RETORNO.

           IF WS-RETORNO NOT = 0
               DISPLAY "ERRO DE CONEXAO: " WS-RETORNO
               STOP RUN
           END-IF.

           *> Preparar Consulta de Pendentes
           CALL "db_prepare_faturas_pendentes" RETURNING WS-RETORNO.

           IF WS-RETORNO NOT = 0
               DISPLAY "NENHUMA FATURA PENDENTE OU ERRO SQL."
               PERFORM FINALIZAR
           END-IF.

           DISPLAY "ID      | CLIENTE              | LIQUIDO (+10% IMP)"
           DISPLAY "----------------------------------------------------"

           PERFORM UNTIL WS-RETORNO NOT = 0
               CALL "db_fetch_fatura" USING BY REFERENCE DB-FATURA-ID
                                            BY REFERENCE DB-CLIENTE-NOME
                                            BY REFERENCE DB-VALOR-BRUTO
                                      RETURNING WS-RETORNO
               
               IF WS-RETORNO = 0
                   *> Lógica de Negócio em COBOL
                   COMPUTE WS-VALOR-IMPOSTO = DB-VALOR-BRUTO * WS-PERCENT-IMP
                   COMPUTE WS-VALOR-LIQUIDO = DB-VALOR-BRUTO + WS-VALOR-IMPOSTO
                   
                   *> Exibição
                   MOVE DB-FATURA-ID TO WS-DISP-ID
                   MOVE WS-VALOR-LIQUIDO TO WS-DISP-VALOR
                   DISPLAY WS-DISP-ID " | " DB-CLIENTE-NOME " | R$ " WS-DISP-VALOR
                   
                   *> Atualizar Status no Banco
                   CALL "db_atualizar_status" USING BY VALUE DB-FATURA-ID
                                                    BY REFERENCE WS-STATUS-PROC
                                          RETURNING WS-RETORNO
                   
                   IF WS-RETORNO NOT = 0
                       DISPLAY "AVISO: ERRO AO ATUALIZAR STATUS DA FATURA " DB-FATURA-ID
                   END-IF
                   
                   *> Resetar retorno para continuar o loop
                   MOVE 0 TO WS-RETORNO
               END-IF
           END-PERFORM.

       FINALIZAR.
           CALL "db_finalize_query".
           CALL "db_disconnect".
           DISPLAY "----------------------------------------------------"
           DISPLAY "FATURAMENTO CONCLUIDO COM SUCESSO."
           STOP RUN.
