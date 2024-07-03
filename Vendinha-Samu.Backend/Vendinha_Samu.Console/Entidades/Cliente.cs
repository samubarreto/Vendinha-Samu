using System.ComponentModel.DataAnnotations;
using Vendinha_Samu.Console.Services;

namespace Vendinha_Samu.Console.Entidades
{
    public class Cliente
    {
        public int Id { get; set; }

        [Required(ErrorMessage = "O Nome é obrigatório")]
        [StringLength(50, ErrorMessage = "O Nome não pode passar de 50 caractéres")]
        public required string NomeCompleto { get; set; }

        [Required(ErrorMessage = "O CPF é obrigatório")]
        [GeneralServices.ValidacaoCpf(ErrorMessage = "O CPF informado é inválido")]
        public required string Cpf { get; set; }

        [Required(ErrorMessage = "A data de nascimento é obrigatória")]
        public required DateTime DataNascimento { get; set; }

        [StringLength(50, ErrorMessage = "O E-mail não pode passar de 50 caractéres")]
        public string? Email { get; set; }

        [Required(ErrorMessage = "O Número de Celular é obrigatório")]
        [StringLength(11, MinimumLength = 11, ErrorMessage = "O Número de Celular deve ter exatamente 11 caracteres, apenas o DDD+Número sem quaisquer pontuação")]
        [RegularExpression("^[0-9]{11}$", ErrorMessage = "O Número de Celular deve conter apenas dígitos numéricos.")]
        public required string NumeroCelular { get; set; }

        [Url]
        public string? UrlPerfil { get; set; }
        public Decimal? SomatorioDividasEmAberto { get; set; }
    }
}