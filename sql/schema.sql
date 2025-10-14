CREATE DATABASE IF NOT EXISTS sistema_bancario;
USE sistema_bancario;
CREATE TABLE IF NOT EXISTS Clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    telefone VARCHAR(15),
    endereco VARCHAR(255),
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS Clientes_PF (
    cliente_id INT PRIMARY KEY,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    data_nascimento DATE,
    FOREIGN KEY (cliente_id) REFERENCES Clientes(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Clientes_PJ (
    cliente_id INT PRIMARY KEY,
    cnpj VARCHAR(18) NOT NULL UNIQUE,
    razao_social VARCHAR(100),
    FOREIGN KEY (cliente_id) REFERENCES Clientes(id) ON DELETE CASCADE
);

CREATE TABLE if not exists Contas (
    Id INT PRIMARY KEY UNSIGNED AUTO_INCREMENT ,
    cliente_Id INT UNSIGNED,
    tipo_conta ENUM('Conta Corrente', 'Conta Poupança'),
    saldo DECIMAL (15, 2) DEFAULT 0.00,
    limite DECIMAL (15, 2) DEFAULT 0.00,
    status ENUM ('Ativa', 'Inativa') DEFAULT 'Ativa',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente) REFERENCES cliente(id) ON DELETE CASCADE
);

CREATE TABLE if NOT exists Transacoes (
    Id BIGINT  PRIMARY KEY AUTO_INCREMENT,
    conta_Id INT,
    data_transacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tipo ENUM ('Deposito', 'Saque', 'Transferencia') NOT NULL,
    valor DECIMAL (15, 2) NOT NULL,
    descricao VARCHAR(255),
    Foreign Key (conta_Id) REFERENCES Contas(Id) ON DELETE CASCADE
);

CREATE INDEX idx_cliente_id ON Contas(cliente_Id);
CREATE INDEX idx_conta_id ON Transacoes(conta_Id);