USE sistema_bancario; 

DELIMITER $$ 
------------------------------- clinetePF -------------------------------------
CREATE PROCEDURE if not EXISTS p_consultarPFisica()
Begin
    SELECT * FROM Clientes_PF;
End$$

CREATE PROCEDURE if not EXISTS p_consultarPFisicaByCPF (IN cpf varchar(14))
begin
    SELECT * FROM Clientes_PF WHERE cpf = cpf;
END$$

CREATE procedure if not EXISTS  p_cadastrarClientePF (
    IN  _nome varchar(255),
    IN  _email varchar(255),
    IN  _telefone varchar(15),
    IN  _endereco varchar(255),
    IN  _username varchar(50),
    IN _password varchar(255),
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

DROP PROCEDURE if EXISTS Cliente_Alterar;

CREATE PROCEDURE if not EXISTS ClintePf_Alterar(
    IN _conta_Id INT UNSIGNED,
    IN  _nome varchar(255),
    IN  _email varchar(255),
    IN  _telefone varchar(15),
    IN  _endereco varchar(255),
    IN  _username varchar(50),
    IN _password varchar(255),
    IN _cpf VARCHAR(14),
    IN _data_nascimento DATE
);
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE Cliente
    SET
    nome = _nome,
    email = _email,
    telefone = _telefone,
    endereco = _endereco,
    username = _username,
    passeord = _password
    WHERE Conta.'Id' = _conta_Id

    COMMIT;
END$$

------------------------------- clinetePJ -------------------------------------
CREATE PROCEDURE if not EXISTS p_consultarPJuridica()
Begin
    SELECT * FROM Clientes_PJ;
END$$

CREATE PROCEDURE if not EXISTS p_consultarPJuridicaByCNPJ(IN Cnpj varchar(18))
begin
    SELECT * FROM Clientes_PJ where cnpj = Cnpj;
END$$

CREATE procedure if not EXISTS  p_cadastrarClientePJ (
    IN  _nome varchar(255),
    IN  _email varchar(255),
    IN  _telefone varchar(15),
    IN  _endereco varchar(255),
    IN  _username varchar(50),
    IN _password varchar(255),
    IN _cnpj VARCHAR(18),
    IN _data_nascimento DATE,
    IN _razao_social varchar(100)
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


------------------------------- Transação -------------------------------------

CREATE PROCEDURE if not EXISTS p_consultarTransacoes()
begin
    SELECT * FROM Transacoes;
END$$

CREATE PROCEDURE if not EXISTS p_consultarTransacoesByID (IN TransacoesID INT )
begin
    SELECT * FROM Transacoes WHERE id = TransacoesID;
END$$

CREATE PROCEDURE if not EXISTS p_sacar(
    IN _conta_Id Int,
    IN _valor Decimal(15, 2) DEFAULT 0.00,
    IN _descricao varchar(255)
)
BEGIN
    UPDATE Contas
    SET saldo = saldo - _valor
    WHERE id = _conta_Id
    INSERT into Transacoes(conta_Id, tipo, valor, descricao)
    VALUES(_conta_Id, 'saque', _valor, _descricao);
END$$

CREATE PROCEDURE if not EXISTS p_depositar(
    IN _conta_Id Int,
    IN _valor Decimal(15, 2) DEFAULT 0.00,
    IN _descricao varchar(255)
)
BEGIN
    UPDATE Contas
    SET saldo = saldo + _valor
    WHERE id = _conta_Id
    INSERT into Transacoes(conta_Id, tipo, valor, descricao)
    VALUES(_conta_Id, 'Deposito', _valor, _descricao);
END$$

CREATE PROCEDURE if not EXISTS p_Transferir(
    IN _contaOrigemId Int,
    IN _contaDestinoId Int,
    IN _valor Decimal(15, 2) DEFAULT 0.00,
    IN _descricao varchar(255)
)
BEGIN
    CALL p_sacar(_contaOrigemId, _valor, 'Transferencia', _descricao),
    CALL p_depositar(_contaDestinoId, _valor, 'Transferencia', _descricao)

------------------------------- Cliente ---------------------------------------
CREATE PROCEDURE if not EXISTS p_consultaCliente ()
Begin
    SELECT * FROM Clientes;
END$$

CREATE PROCEDURE if not EXISTS p_consultarClienteByID (IN clienteID int)
Begin
    SELECT * FROM Clientes WHERE id = clienteID;
END$$
------------------------------- Conta -----------------------------------------
CREATE PROCEDURE if not EXISTS p_consultarConta ()
Begin
    SELECT * FROM Contas;
END$$

CREATE PROCEDURE if not EXISTS p_consultarContaByID(IN ContaID INT)
Begin
    SELECT * FROM Contas where Id = ContaId;
END$$

CREATE PROCEDURE if not EXISTS p_criarcontaPoupanca(
    IN _cliente_Id INT
)
BEGIN
    INSERT INTO Contas(cliente_Id, tipo_conta, saldo, limite)
    VALUES (_cliente_Id, 'Conta Poupança', 0.00, 0.00);
END$$

CREATE PROCEDURE if not EXISTS p_criarcontaCorrente(
    IN _cliente_Id INT,
    IN _limite DECIMAL (15, 2) DEFAULT 0.00
)
BEGIN
    INSERT INTO Contas(cliente_Id, tipo_conta, saldo, limite)
    VALUES (_cliente_Id, 'Conta Corrente', 0.00, _limite);
END$$


DELIMITER;