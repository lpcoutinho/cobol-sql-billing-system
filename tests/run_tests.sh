#!/bin/bash

# Cores
GREEN='\033[0;32m'
NC='\033[0m'

echo "Limpando e Reinicializando Banco de Dados..."
rm -f db/billing.db
sqlite3 db/billing.db < db/init.sql
sqlite3 db/billing.db < db/pedidos.sql

echo "Executando Sistema de Faturamento COBOL..."
./bin/billing

echo -e "\n${GREEN}Verificando se os status foram atualizados no SQLITE:${NC}"
sqlite3 db/billing.db "SELECT id, status FROM faturas;"

echo -e "\n${GREEN}Teste concluído.${NC}"
