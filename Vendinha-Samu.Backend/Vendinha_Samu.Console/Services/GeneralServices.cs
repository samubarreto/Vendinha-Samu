﻿using System.ComponentModel.DataAnnotations;
using CpfCnpjLibrary;

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