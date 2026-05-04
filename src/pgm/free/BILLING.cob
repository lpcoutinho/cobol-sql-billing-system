      *>>SOURCE FORMAT IS FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. BILLING-SQL.
       AUTHOR. LPCOUTINHO.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       *> Host Variables para o Bridge C
       01  DB-FATURA-ID       PIC S9(09) COMP-5.
       01  DB-CLIENTE-NOME    PIC X(51).
       01  DB-VALOR-BRUTO     COMP-2.
       
       *> Variáveis de Lógica de Negócio
       01  WS-VALOR-IMPOSTO   COMP-2.
       01  WS-VALOR-LIQUIDO   COMP-2.
       01  WS-PERCENT-IMP     COMP-2 VALUE 0.10.
       
       01  WS-RETORNO         PIC S9(04) COMP-5.
       01  WS-DB-NAME         PIC X(20) VALUE Z"db/billing.db".
       01  WS-STATUS-PROC     PIC X(11) VALUE Z"PROCESSADO".
       
       *> Contadores e Controle
       01  WS-CONT-PROC       PIC 9(04) VALUE 0.
       01  WS-TOTAL-GERAL     COMP-2 VALUE 0.
       01  WS-ENCONTROU-DADO  PIC X(01) VALUE 'N'.
       
       *> Variáveis de Exibição
       01  WS-DISP-ID         PIC Z(09).
       01  WS-DISP-VALOR      PIC ZZZZZ9,99.
       01  WS-DISP-TOTAL      PIC ZZZZZZ9,99.
       01  WS-DISP-CONT       PIC ZZZ9.

       PROCEDURE DIVISION.
       INICIO.
           DISPLAY "========================================"
           DISPLAY "SISTEMA DE PROCESSAMENTO DE FATURAS SQL"
           DISPLAY "========================================"
           DISPLAY "Conectando ao banco de dados..."
           
           CALL "db_connect" USING BY REFERENCE WS-DB-NAME
                             RETURNING WS-RETORNO.

           IF WS-RETORNO NOT = 0
               DISPLAY "ERRO CRITICO: Nao foi possivel conectar ao banco."
               STOP RUN
           END-IF.

           DISPLAY "Buscando faturas com status 'PENDENTE'..."
           CALL "db_prepare_faturas_pendentes" RETURNING WS-RETORNO.

           IF WS-RETORNO NOT = 0
               DISPLAY "INFO: Nenhuma fatura pendente para processar hoje."
               PERFORM FINALIZAR
           END-IF.

           MOVE 0 TO WS-RETORNO.
           PERFORM UNTIL WS-RETORNO NOT = 0
               CALL "db_fetch_fatura" USING BY REFERENCE DB-FATURA-ID
                                            BY REFERENCE DB-CLIENTE-NOME
                                            BY REFERENCE DB-VALOR-BRUTO
                                      RETURNING WS-RETORNO
               
               IF WS-RETORNO = 0
                   IF WS-ENCONTROU-DADO = 'N'
                       DISPLAY "ID      | CLIENTE              | LIQUIDO (+10% IMP)"
                       DISPLAY "----------------------------------------------------"
                       MOVE 'S' TO WS-ENCONTROU-DADO
                   END-IF

                   *> Lógica de Negócio
                   COMPUTE WS-VALOR-IMPOSTO = DB-VALOR-BRUTO * WS-PERCENT-IMP
                   COMPUTE WS-VALOR-LIQUIDO = DB-VALOR-BRUTO + WS-VALOR-IMPOSTO
                   
                   *> Acumuladores
                   ADD 1 TO WS-CONT-PROC
                   ADD WS-VALOR-LIQUIDO TO WS-TOTAL-GERAL
                   
                   *> Exibição
                   MOVE DB-FATURA-ID TO WS-DISP-ID
                   MOVE WS-VALOR-LIQUIDO TO WS-DISP-VALOR
                   DISPLAY WS-DISP-ID " | " DB-CLIENTE-NOME " | R$ " WS-DISP-VALOR
                   
                   *> Atualizar Status
                   CALL "db_atualizar_status" USING BY VALUE DB-FATURA-ID
                                                    BY REFERENCE WS-STATUS-PROC
                                          RETURNING WS-RETORNO
                   
                   IF WS-RETORNO NOT = 0
                       DISPLAY "ERRO: Falha ao atualizar fatura " DB-FATURA-ID
                   END-IF
                   
                   MOVE 0 TO WS-RETORNO
               END-IF
           END-PERFORM.

           IF WS-ENCONTROU-DADO = 'N'
               DISPLAY "RESULTADO: O banco de dados retornou zero registros."
           ELSE
               PERFORM MOSTRA-RESUMO
           END-IF.

       FINALIZAR.
           CALL "db_finalize_query".
           CALL "db_disconnect".
           DISPLAY "----------------------------------------------------"
           DISPLAY "SESSAO FINALIZADA."
           STOP RUN.

       MOSTRA-RESUMO.
           MOVE WS-CONT-PROC TO WS-DISP-CONT
           MOVE WS-TOTAL-GERAL TO WS-DISP-TOTAL
           DISPLAY "----------------------------------------------------"
           DISPLAY "RESUMO DO PROCESSAMENTO:"
           DISPLAY "Total de faturas processadas: " WS-DISP-CONT
           DISPLAY "Valor total liquidado       : R$ " WS-DISP-TOTAL.
