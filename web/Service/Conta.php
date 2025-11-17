
<?php

        require_once 'Titular.php';
        abstract class Conta{
        protected int $id;
        protected Titular $titular;
        protected float $saldo;
        protected float $limite;


        public function Conta(int $id, Titular $titular, float $saldo, float $limite)
        {
            $this->setId($id);
            $this->titular = $titular;
            $this->saldo = $saldo;
            $this->limite = $limite;
        }

        public function setId(int $id): void
        {
         if ($id <= 0)
            {
                throw new Exception("O número da conta deve ser positivo.");
            }
            $this->id = $id;
        }

         public function setTitular(Titular $titular)
        {
            if (titular == null)
            {
            throw new Exception("O titular da conta não pode ser nulo.");
            }
            $this->titular = $titular;
        }
        
        public function getnumero(): int
        {
            return $this->id;
        }
        
        public function getTitular(): Titular
        {
            return $this->titular;
        }

        public function getSaldo(): float
        {
            return $this->saldo;
        }

        abstract function sacar(float $valor): array;
        abstract function depositar(float $valor): array;
        public function transferir(float $valor, Conta $contaDestino): array{
            if($contaDestino == null){
                throw new Exception("A conta destino não pode ser nula.");
            }
            return [];

            this->sacar($valor);
            $contaDestino->depositar($valor);
            return [
                "conta_origem_saldo" => $this->getSaldo(),
                "conta_destino_saldo" => $contaDestino->getSaldo()
            ];

            $return [];

         }
}