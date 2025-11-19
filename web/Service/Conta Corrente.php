<?php
    require_once 'Conta.php';

    class ContaCorrente extends Conta{

    #[Override]
    public function Depositar(float $valor): array{
        if ($valor <= 0){
            throw new InvalidArgumentException("O valor do depósito deve ser positivo.");

            $this->saldo += $valor * 0.99;
            return[
                "tipo" => "depósito",
                "valor_depositado" => $valor,
                "saldo_atual" => $this->saldo,
                "taxa" => $valor * 0.01 
            ];
        }
    }

    #[override]
    public function sacar(float $valor):array{
        
        if($valor <= 0){
            throw new ArgumentException("O valor do saque deve ser positivo.");
        }
        if ($valorcomtaxa > $this->saldo){
            throw new InvalidOperationException("Saldo insuficiente para o saque.");

            $valorcomtaxa = $valor * 1.01;

            $this->saldo -= $valorcomtaxa;

                return[
                "tipo" => "saque",
                "valor_sacado" => $valor,
                "saldo_atual" => $this->saldo,
                "taxa" => $valor * 0.01 
            ];
        }
    }

}


