using System.ComponentModel.DataAnnotations;

namespace Vendinha_Samu.Console.Entidades
{
    public class Divida
    {
        [Required(ErrorMessage = "O IdDivida é obrigatório")]
        public int IdDivida { get; set; }

        [Required(ErrorMessage = "O IdCliente é obrigatório")]
        public required int IdCliente { get; set; }

        [Required(ErrorMessage = "O Valor da dívida é obrigatório")]
        public required Decimal Valor { get; set; }

        [Required(ErrorMessage = "A Data de Criação da dívida é obrigatória")]
        public DateTime DataCriacao { get; set; } = DateTime.Now;

        [Required(ErrorMessage = "A situação da dívida é obrigatória")]
        public required bool Situacao { get; set; }
        public DateTime? DataPagamento { get; set; }

        [Required(ErrorMessage = "A Descrição da dívida é obrigatória")]
        [StringLength(255, ErrorMessage = "A descrição não pode passar de 255 caractéres")]
        public required string Descricao { get; set; }
    }
}
