-- Script de inicialização do banco de dados de faturamento
CREATE TABLE IF NOT EXISTS clientes (
    id INTEGER PRIMARY KEY,
    nome TEXT NOT NULL,
    email TEXT
);

CREATE TABLE IF NOT EXISTS faturas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    cliente_id INTEGER,
    data_emissao TEXT,
    valor_total REAL,
    status TEXT DEFAULT 'PENDENTE',
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

-- Inserindo dados iniciais para teste
INSERT INTO clientes (id, nome, email) VALUES (1, 'Empresa Alpha', 'contato@alpha.com');
INSERT INTO clientes (id, nome, email) VALUES (2, 'Tecnologia Beta', 'financeiro@beta.com');
