using System.ComponentModel.DataAnnotations;

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
    }
}