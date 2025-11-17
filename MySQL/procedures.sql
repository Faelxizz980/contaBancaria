USE sistema_bancario;

DELIMITER $$

-- ------------------------------- clientePF -------------------------------------
CREATE PROCEDURE p_consultarPFisica(IN p_nome VARCHAR(255))
BEGIN
    SELECT * FROM Clientes_PF JOIN Clientes ON Clientes.nome = Clientes_PF.cliente_id
    WHERE Clientes.nome = p_nome;
END $$

CREATE PROCEDURE p_consultarPFisicaByCPF (IN p_cpf VARCHAR(14))
BEGIN
    SELECT * FROM Clientes_PF WHERE cpf = p_cpf;
END $$

CREATE PROCEDURE p_consultarPFisicaById (IN p_id INT)
BEGIN
    SELECT * FROM Clientes_PF WHERE cliente_id = p_id;
END $$ 

CREATE PROCEDURE p_consultarPFisicaByEmail (IN p_email VARCHAR(255))
BEGIN
    SELECT Clientes_PF.*
    FROM Clientes_PF
    JOIN Clientes ON Clientes.id = Clientes_PF.cliente_id
    WHERE Clientes.email = p_email;
END $$

CREATE PROCEDURE p_cadastrarClientePF (
    IN _nome VARCHAR(255),
    IN _email VARCHAR(255),
    IN _telefone VARCHAR(15),
    IN _endereco VARCHAR(255),
    IN _username VARCHAR(50),
    IN _password VARCHAR(255),
    IN _cpf VARCHAR(14),
    IN _data_nascimento DATE
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    INSERT INTO Clientes (nome, email, telefone, endereco, username, password)
    VALUES (_nome, _email, _telefone, _endereco, _username, _password);

    SET @last_id = LAST_INSERT_ID();

    INSERT INTO Clientes_PF (cliente_id, cpf, data_nascimento)
    VALUES (@last_id, _cpf, _data_nascimento);

    COMMIT;
END $$

CREATE PROCEDURE ClientePF_Alterar(
    IN _cliente_Id INT,
    IN _nome VARCHAR(255),
    IN _email VARCHAR(255),
    IN _telefone VARCHAR(15),
    IN _endereco VARCHAR(255),
    IN _username VARCHAR(50),
    IN _password VARCHAR(255),
    IN _cpf VARCHAR(14),
    IN _data_nascimento DATE
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE Clientes
    SET
        nome = _nome,
        email = _email,
        telefone = _telefone,
        endereco = _endereco,
        username = _username,
        password = _password
    WHERE id = _cliente_Id;

    UPDATE Clientes_PF
    SET
        cpf = _cpf,
        data_nascimento = _data_nascimento
    WHERE cliente_id = _cliente_Id;

    COMMIT;
END $$

CREATE PROCEDURE p_deletarClientePF(
    IN _cliente_Id INT
)
BEGIN
    DELETE FROM Clientes_PF WHERE cliente_id = _cliente_Id;
    DELETE FROM Clientes WHERE id = _cliente_Id;
END $$

-- ------------------------------- clientePJ -------------------------------------
CREATE PROCEDURE p_consultarPJuridica()
BEGIN
    SELECT * FROM Clientes_PJ JOIN Clientes ON Clientes.nome = Clientes_PJ.cliente_id
    WHERE Clientes.nome = p_nome;
END $$

CREATE PROCEDURE p_consultarPJuridicaByCNPJ (IN p_cnpj VARCHAR(18))
BEGIN
    SELECT * FROM Clientes_PJ WHERE cnpj = p_cnpj;
END $$

CREATE PROCEDURE p_consultarPJuridicaById (IN p_id INT)
BEGIN
    SELECT * FROM Clientes_PJ WHERE cliente_id = p_id;
END $$ 

CREATE PROCEDURE p_consultarPJuridicaByEmail (IN p_email VARCHAR(255))
BEGIN
    SELECT Clientes_PJ.*
    FROM Clientes_PJ
    JOIN Clientes ON Clientes.id = Clientes_PJ.cliente_id
    WHERE Clientes.email = p_email;
END $$

CREATE PROCEDURE p_cadastrarClientePJ (
    IN _nome VARCHAR(255),
    IN _email VARCHAR(255),
    IN _telefone VARCHAR(15),
    IN _endereco VARCHAR(255),
    IN _username VARCHAR(50),
    IN _password VARCHAR(255),
    IN _cnpj VARCHAR(18),
    IN _data_nascimento DATE,
    IN _razao_social VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    INSERT INTO Clientes (nome, email, telefone, endereco, username, password)
    VALUES (_nome, _email, _telefone, _endereco, _username, _password);

    SET @last_id = LAST_INSERT_ID();

    INSERT INTO Clientes_PJ (cliente_id, cnpj, data_nascimento, razao_social)
    VALUES (@last_id, _cnpj, _data_nascimento, _razao_social);

    COMMIT;
END $$

CREATE PROCEDURE ClientePJ_Alterar(
    IN _cliente_Id INT,
    IN _nome VARCHAR(255),
    IN _email VARCHAR(255),
    IN _telefone VARCHAR(15),
    IN _endereco VARCHAR(255),
    IN _username VARCHAR(50),
    IN _password VARCHAR(255),
    IN _cnpj VARCHAR(18),
    IN _razao_social VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE Clientes
    SET
        nome = _nome,
        email = _email,
        telefone = _telefone,
        endereco = _endereco,
        username = _username,
        password = _password
    WHERE id = _cliente_Id;

    UPDATE Clientes_PJ
    SET
        cnpj = _cnpj,
        razao_social = _razao_social
    WHERE cliente_id = _cliente_Id;

    COMMIT;
END $$

CREATE PROCEDURE p_deletarClientePJ(
    IN _cliente_Id INT
)
BEGIN
    DELETE FROM Clientes_PJ WHERE cliente_id = _cliente_Id;
    DELETE FROM Clientes WHERE id = _cliente_Id;
END $$

-- ------------------------------- Transação -------------------------------------
CREATE PROCEDURE p_consultarTransacoes()
BEGIN
    SELECT * FROM Transacoes;
END $$

CREATE PROCEDURE p_consultarTransacoesByID (IN p_transacao_id INT)
BEGIN
    SELECT * FROM Transacoes WHERE id = p_transacao_id;
END $$

CREATE PROCEDURE p_sacar(
    IN _conta_Id INT,
    IN _valor DECIMAL(15,2),
    IN _descricao VARCHAR(255)
)
BEGIN
    UPDATE Contas
    SET saldo = saldo - _valor
    WHERE id = _conta_Id;
    
    INSERT INTO Transacoes(conta_id, tipo, valor, descricao)
    VALUES(_conta_Id, 'saque', _valor, _descricao);
END $$

CREATE PROCEDURE p_depositar(
    IN _conta_Id INT,
    IN _valor DECIMAL(15,2),
    IN _descricao VARCHAR(255)
)
BEGIN
    UPDATE Contas
    SET saldo = saldo + _valor
    WHERE id = _conta_Id;

    INSERT INTO Transacoes(conta_id, tipo, valor, descricao)
    VALUES(_conta_Id, 'deposito', _valor, _descricao);
END $$

CREATE PROCEDURE p_Transferir(
    IN _contaOrigemId INT,
    IN _contaDestinoId INT,
    IN _valor DECIMAL(15,2),
    IN _descricao VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    CALL p_sacar(_contaOrigemId, _valor, _descricao);
    CALL p_depositar(_contaDestinoId, _valor, _descricao);

    INSERT INTO Transacoes(conta_id, tipo, valor, descricao)
    VALUES(_contaOrigemId, 'transferencia_saida', _valor, _descricao);

    INSERT INTO Transacoes(conta_id, tipo, valor, descricao)
    VALUES(_contaDestinoId, 'transferencia_entrada', _valor, _descricao);

    COMMIT;
END $$

-- ------------------------------- Cliente ---------------------------------------
CREATE PROCEDURE p_consultaCliente ()
BEGIN
    SELECT * FROM Clientes;
END $$

CREATE PROCEDURE p_consultarClienteByID (IN p_clienteID INT)
BEGIN
    SELECT * FROM Clientes WHERE id = p_clienteID;
END $$

-- ------------------------------- Conta -----------------------------------------
CREATE PROCEDURE p_cadastrarConta (
    IN _cliente_Id INT,
    IN _tipo_conta ENUM('Conta Corrente','Conta Poupança'),
    IN _saldo DECIMAL(15,2),
    IN _limite DECIMAL(15,2)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;
    INSERT INTO Contas (cliente_id, tipo_conta, saldo, limite)
    VALUES (_cliente_Id,  _tipo_conta, _saldo, _limite);
    COMMIT;
END $$

CREATE PROCEDURE p_consultarConta ()
BEGIN
    SELECT * FROM Contas;
END $$

CREATE PROCEDURE p_consultarContaByID(IN p_ContaID INT)
BEGIN
    SELECT * FROM Contas WHERE id = p_ContaID;
END $$

CREATE PROCEDURE p_criarcontaPoupanca(
    IN _cliente_Id INT
)
BEGIN
    INSERT INTO Contas(cliente_id, tipo_conta, saldo, limite)
    VALUES (_cliente_Id, 'Conta Poupança', 0.00, 0.00);
END $$

CREATE PROCEDURE p_criarcontaCorrente(
    IN _cliente_Id INT,
    IN _limite DECIMAL(15,2)
)
BEGIN
    INSERT INTO Contas(cliente_id, tipo_conta, saldo, limite)
    VALUES (_cliente_Id, 'Conta Corrente', 0.00, _limite);
END $$

CREATE PROCEDURE p_AlterarConta(
    IN _conta_Id INT,
    IN _cliente_Id INT,
    IN _tipo_conta ENUM('Conta Corrente','Conta Poupança'),
    IN _saldo DECIMAL(15,2),
    IN _limite DECIMAL(15,2)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE Contas
    SET
        tipo_conta = _tipo_conta,
        saldo = _saldo,
        limite = _limite,
        cliente_id = _cliente_Id
    WHERE id = _conta_Id;

    COMMIT;
END $$

CREATE PROCEDURE p_deletarConta(
    IN _conta_Id INT,
    IN _cliente_Id INT
)
BEGIN
    DELETE FROM Contas WHERE id = _conta_Id;
    DELETE FROM Clientes WHERE id = _cliente_Id;
END $$

DELIMITER ;