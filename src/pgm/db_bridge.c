#include <stdio.h>
#include <sqlite3.h>
#include <string.h>

sqlite3 *db;
sqlite3_stmt *res;

int db_connect(const char *db_name) {
    return sqlite3_open(db_name, &db);
}

// Busca TODAS as faturas para o relatório de visão geral
int db_prepare_todas_faturas() {
    const char *sql = "SELECT f.id, c.nome, f.valor_total, f.status FROM faturas f "
                      "JOIN clientes c ON f.cliente_id = c.id ORDER BY f.id";
    return sqlite3_prepare_v2(db, sql, -1, &res, 0);
}

int db_prepare_faturas_pendentes() {
    const char *sql = "SELECT f.id, c.nome, f.valor_total FROM faturas f "
                      "JOIN clientes c ON f.cliente_id = c.id "
                      "WHERE f.status = 'PENDENTE'";
    return sqlite3_prepare_v2(db, sql, -1, &res, 0);
}

int db_fetch_fatura_completa(int *id, char *nome, double *valor, char *status) {
    int step = sqlite3_step(res);
    if (step == SQLITE_ROW) {
        *id = sqlite3_column_int(res, 0);
        strcpy(nome, (const char *)sqlite3_column_text(res, 1));
        *valor = sqlite3_column_double(res, 2);
        strcpy(status, (const char *)sqlite3_column_text(res, 3));
        return 0;
    }
    return 1;
}

int db_fetch_fatura(int *id, char *nome_cliente, double *valor) {
    int step = sqlite3_step(res);
    if (step == SQLITE_ROW) {
        *id = sqlite3_column_int(res, 0);
        strcpy(nome_cliente, (const char *)sqlite3_column_text(res, 1));
        *valor = sqlite3_column_double(res, 2);
        return 0;
    }
    return 1;
}

int db_atualizar_status(int id, const char *novo_status) {
    sqlite3_stmt *upd_stmt;
    const char *sql = "UPDATE faturas SET status = ? WHERE id = ?";
    sqlite3_prepare_v2(db, sql, -1, &upd_stmt, 0);
    sqlite3_bind_text(upd_stmt, 1, novo_status, -1, SQLITE_STATIC);
    sqlite3_bind_int(upd_stmt, 2, id);
    int rc = sqlite3_step(upd_stmt);
    sqlite3_finalize(upd_stmt);
    return (rc == SQLITE_DONE) ? 0 : 1;
}

void db_finalize_query() {
    sqlite3_finalize(res);
}

void db_disconnect() {
    sqlite3_close(db);
}
