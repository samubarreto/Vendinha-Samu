using System.ComponentModel.DataAnnotations;
using CpfCnpjLibrary;

#pragma warning disable CS8765, CS8604, CS8603, CS8620

namespace Vendinha_Samu.Console.Services
{
    public class GeneralServices
    {
        public static bool Validacao<ClienteOuDivida>(ClienteOuDivida Obj, out List<ValidationResult> erros)
        {
            erros = new List<ValidationResult>();
            var valido = Validator.TryValidateObject(Obj, new ValidationContext(Obj), erros, true);
            return valido;
        }
        public class ValidacaoCpf : ValidationAttribute
        {
            protected override ValidationResult IsValid(object CPF, ValidationContext validationContext)
            {
                if (Cpf.Validar(CPF.ToString()))
                {
                    return ValidationResult.Success;
                }
                return new ValidationResult("O CPF informado é inválido.", new[] { validationContext.MemberName });
            }
        }
    }
}

#pragma warning restore CS8765, CS8604, CS8603, CS8620