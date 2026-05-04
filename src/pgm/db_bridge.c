#include <stdio.h>
#include <sqlite3.h>
#include <string.h>

sqlite3 *db;
sqlite3_stmt *res;

// Função para conectar ao banco
int db_connect(const char *db_name) {
    int rc = sqlite3_open(db_name, &db);
    return rc;
}

// Função para preparar a consulta de clientes
int db_prepare_clientes() {
    const char *sql = "SELECT id, nome, email FROM clientes";
    return sqlite3_prepare_v2(db, sql, -1, &res, 0);
}

// Função para buscar o próximo registro (FETCH)
int db_fetch_cliente(int *id, char *nome, char *email) {
    int step = sqlite3_step(res);
    if (step == SQLITE_ROW) {
        *id = sqlite3_column_int(res, 0);
        strcpy(nome, (const char *)sqlite3_column_text(res, 1));
        strcpy(email, (const char *)sqlite3_column_text(res, 2));
        return 0; // Sucesso
    }
    return 1; // Fim dos dados ou erro
}

// Função para fechar conexão
void db_disconnect() {
    sqlite3_finalize(res);
    sqlite3_close(db);
}
