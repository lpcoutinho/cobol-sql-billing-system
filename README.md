# COBOL SQL Billing System

[English](#english) | [Português (Brasil)](#português-brasil) | [Español](#español)

---

## English

A high-level billing system that integrates **COBOL** with a **Relational Database (SQLite)** using a professional **C Bridge** architecture. This project demonstrates how to bridge legacy logic with modern data storage.

### Engineering Highlights
- **Hybrid Architecture**: Implements a COBOL-to-C bridge to interface with `libsqlite3`, showcasing advanced interoperability skills.
- **Relational Data Processing**: Handles SQL Joins, Cursors, and Updates directly from COBOL logic.
- **Business Logic**: Performs tax calculations and financial rounding using COBOL's computational types (`COMP-2`, `COMP-5`).
- **Data Integrity**: Manages database connection lifecycles, statement finalization, and SQL error handling.

### How it Works
1. The **C Bridge** (`src/pgm/db_bridge.c`) manages the low-level SQLite API calls.
2. The **COBOL Program** (`src/pgm/free/BILLING.cob`) invokes the C functions to fetch pending invoices.
3. COBOL applies tax rules and updates the invoice status back to the database.

### How to Run
```bash
make build   # Compiles C Bridge and COBOL code
make run     # Executes the billing cycle
```

---

## Português (Brasil)

Um sistema de faturamento de alto nível que integra **COBOL** com um **Banco de Dados Relacional (SQLite)** utilizando uma arquitetura profissional de **C Bridge**. Este projeto demonstra como unir a lógica legada com armazenamento de dados moderno.

### Diferenciais de Engenharia
- **Arquitetura Híbrida**: Implementa uma ponte COBOL-C para interfacear com a `libsqlite3`, demonstrando habilidades avançadas de interoperabilidade.
- **Processamento Relacional**: Manipula SQL Joins, Cursores e Updates diretamente da lógica COBOL.
- **Lógica de Negócio**: Realiza cálculos de impostos e arredondamentos financeiros usando tipos computacionais do COBOL (`COMP-2`, `COMP-5`).
- **Integridade de Dados**: Gerencia o ciclo de vida da conexão, finalização de statements e tratamento de erros SQL.

### Como Executar
```bash
make build   # Compila o Bridge C e o código COBOL
make run     # Executa o ciclo de faturamento
```

---

## Español

Un sistema de facturación de alto nivel que integra **COBOL** con una **Base de Datos Relacional (SQLite)** utilizando una arquitectura profesional de **C Bridge**. Este proyecto demuestra cómo unir la lógica heredada con el almacenamiento de datos moderno.

### Aspectos Destacados de Ingeniería
- **Arquitectura Híbrida**: Implementa un puente COBOL-C para interactuar con `libsqlite3`, mostrando habilidades avanzadas de interoperabilidad.
- **Procesamiento de Datos Relacionales**: Gestiona SQL Joins, Cursores y Updates directamente desde la lógica COBOL.
- **Lógica de Negocios**: Realiza cálculos de impuestos y redondeos financieros utilizando tipos computacionales de COBOL (`COMP-2`, `COMP-5`).
- **Integridad de Datos**: Gestiona el ciclo de vida de la conexión, la finalización de sentencias y el manejo de errores SQL.

### Cómo Ejecutar
```bash
make build   # Compila el Bridge C y el código COBOL
make run     # Ejecuta el ciclo de facturación
```
