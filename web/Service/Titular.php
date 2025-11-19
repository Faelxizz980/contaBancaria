<?php

    require_once 'Conta.php';

    class Titular{
        protected string $nome,
        protected string $cpf,
        protected string $endereco
    

        public function __construct($nome, $cpf, $endereco){
            $this->SetNome($nome);
            $this->SetCpf($cpf);
            $this->SetEndereco($endereco);
        }

        public function SetNome($nome){
            if (nome.Trim().Length < 3)
            {
                throw new ArgumentException("O nome do titular deve ter pelo menos 3 caracteres.");
            }

            if (nome.Any(char.IsDigit))
            {
                throw new ArgumentException("O nome do titular não pode conter números.");
            }

            $this->nome = $nome;       
        }

        public function SetCpf($cpf){
            if (cpf.Length != 11 || !cpf.All(char.IsDigit))
            {
                throw new ArgumentException("O CPF deve conter exatamente 11 dígitos numéricos.");
            }

            $this->cpf = $cpf;

        }

        public function SetEndereco($endereco){
            if (string.IsNullOrWhiteSpace(endereco))
            {
                throw new ArgumentException("O endereço não pode ser vazio.");
            }

            $this->endereco = $endereco;
        }

        public function GetNome():String
        {
            return $this->nome;
        }
        public function GetCpf():String
        {
            return $this->cpf;
        }
        public function GetEndereco():String
        {
         return $this->endereco;
        }

        #[override]
        public function tostring():string{
            return 'Nome:' . $this->nome . ', CPF: ' . $this->cpf . ', Endereço: ' . $this->endereco;
        }
    }   
