#!/bin/bash

# Identifica a raiz do projeto (um nível acima da pasta tests)
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

# Cores
GREEN='\033[0;32m'
NC='\033[0m'

echo "Caminho do Projeto: $PROJECT_ROOT"
echo "Limpando e Reinicializando Banco de Dados..."

# Garante que as pastas existem
mkdir -p db bin

rm -f db/billing.db
sqlite3 db/billing.db < db/init.sql
sqlite3 db/billing.db < db/pedidos.sql

echo "Compilando (garantindo que o binário existe)..."
make build > /dev/null

echo "Executando Sistema de Faturamento COBOL..."
./bin/billing

echo -e "\n${GREEN}Verificando se os status foram atualizados no SQLITE:${NC}"
sqlite3 db/billing.db "SELECT id, status FROM faturas;"

echo -e "\n${GREEN}Teste concluído.${NC}"
