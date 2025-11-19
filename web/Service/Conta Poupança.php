<?php
    require_once 'Conta.php';

    class ContaPoupanca extends Conta{

    #[Override]
    public function Depositar(float $valor): array{
        if ($valor <= 0){
            throw new InvalidArgumentException("O valor do depósito deve ser positivo.");

            $this->saldo += $valor * 0.49;
            return[
                "tipo" => "depósito",
                "valor_depositado" => $valor,
                "saldo_atual" => $this->saldo,
                "taxa" => $valor * 0.005
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

            $valorcomtaxa = $valor * 1.005;

            $this->saldo -= $valorcomtaxa;

                return[
                "tipo" => "saque",
                "valor_sacado" => $valor,
                "saldo_atual" => $this->saldo,
                "taxa" => $valor * 0.005
            ];
        }
    }


}


