﻿using System.ComponentModel.DataAnnotations;

namespace Vendinha_Samu.Console.Entidades
{
    public class Cliente
    {
        public int Id { get; set; }

        [Required(ErrorMessage = "O Nome é obrigatório")]
        [StringLength(50, ErrorMessage = "O Nome não pode passar de 50 caractéres")]
        public required string NomeCompleto { get; set; }

        [Required(ErrorMessage = "O CPF é obrigatório")]
        [RegularExpression(@"\d{11}", ErrorMessage = "O CPF deve conter exatamente 11 dígitos")]
        public required string Cpf { get; set; }

        [Required(ErrorMessage = "A data de nascimento é obrigatória")]
        public required DateTime DataNascimento { get; set; }

        [Required(ErrorMessage = "O E-mail é obrigatório")]
        [EmailAddress(ErrorMessage = "O E-mail não é válido")]
        [StringLength(50, ErrorMessage = "O email não pode passar de 50 caractéres")]
        public required string Email { get; set; }
    }
}