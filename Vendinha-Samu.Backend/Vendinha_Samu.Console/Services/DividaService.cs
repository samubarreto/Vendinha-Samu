using NHibernate;
using System.ComponentModel.DataAnnotations;
using Vendinha_Samu.Console.Entidades;

namespace Vendinha_Samu.Console.Services
{
    public class DividaService
    {
        private readonly ISessionFactory session;
        public DividaService(ISessionFactory session)
        {
            this.session = session;
        }

        public bool Criar(Divida divida, out List<ValidationResult> erros)
        {
            if (GeneralServices.Validacao(divida, out erros))
            {
                using var sessao = session.OpenSession();
                using var transaction = sessao.BeginTransaction();
                try
                {
                    sessao.Save(divida);
                    transaction.Commit();
                    return true;
                }
                catch (Exception ex)
                {
                    string memberName = "";
                    if (ex.InnerException != null)
                    {
                        if (ex.InnerException.Message.Contains("descricao"))
                        {
                            memberName = nameof(divida.Descricao);
                        }
                        else if (ex.InnerException.Message.Contains("Total de dívidas do cliente é maior que 200"))
                        {
                            memberName = nameof(divida.Valor);
                        }
                    }
                    HandleException(ex, erros, memberName);
                    return false;
                }
            }
            return false;
        }

        public bool Editar(Divida divida, out List<ValidationResult> erros)
        {
            if (GeneralServices.Validacao(divida, out erros))
            {
                using var sessao = session.OpenSession();
                using var transaction = sessao.BeginTransaction();

                try
                {
                    var dividaExistente = sessao.Get<Divida>(divida.IdDivida);
                    if (dividaExistente == null)
                    {
                        erros.Add(new ValidationResult("Esta Dívida não existe!", new[] { nameof(divida.IdDivida) }));
                        return false;
                    }

                    sessao.Merge(divida);
                    transaction.Commit();
                    return true;
                }
                catch (Exception ex)
                {
                    string memberName = "";
                    if (ex.InnerException != null)
                    {
                        if (ex.InnerException.Message.Contains("descricao"))
                        {
                            memberName = nameof(divida.Descricao);
                        }
                        else if (ex.InnerException.Message.Contains("Total de dívidas do cliente é maior que 200"))
                        {
                            memberName = nameof(divida.Valor);
                        }
                    }
                    HandleException(ex, erros, memberName);
                    return false;
                }
            }
            return false;
        }

        public bool Excluir(int id, out List<ValidationResult> erros)
        {
            erros = new List<ValidationResult>();

            using var sessao = session.OpenSession();
            using var transaction = sessao.BeginTransaction();

            var divida = sessao
                .Query<Divida>()
                .Where(d => d.IdDivida == id)
                .FirstOrDefault();
            if (divida == null)
            {
                erros.Add(new ValidationResult($"Registro de dívida [{id}] não encontrado", new[] { "id" }));
                return false;
            }

            try
            {
                sessao.Delete(divida);
                transaction.Commit();
                return true;
            }
            catch (Exception ex)
            {
                erros.Add(new ValidationResult($"Não foi possível apagar a Dívida [{divida.IdDivida}].", new[] { "id" }));
                return false;
            }
        }

        public List<Divida> Listar(int idClienteDivida)
        {
            using var sessao = session.OpenSession();
            try
            {
                var dividas = sessao
                    .Query<Divida>()
                    .Where(d => d.IdCliente == idClienteDivida)
                    .OrderBy(d => d.Situacao)
                    .OrderByDescending(d => d.Valor)
                    .ToList();
                return dividas;
            }
            catch (Exception)
            {
                return [];
            }
        }

        private void HandleException(Exception ex, List<ValidationResult> erros, string memberName = "")
        {
            if (ex.InnerException != null)
            {
                if (ex.InnerException.Message.Contains("descricao"))
                {
                    erros.Add(new ValidationResult("Insira uma Descrição para a Dívida!", new[] { memberName }));
                }
                else if (ex.InnerException.Message.Contains("Total de dívidas do cliente é maior que 200"))
                {
                    erros.Add(new ValidationResult("O total da dívida não pode ser maior que 200 Reais!", new[] { memberName }));
                }
                else
                {
                    erros.Add(new ValidationResult("Erro ao processar a operação.", new[] { memberName }));
                }
            }
            else
            {
                erros.Add(new ValidationResult("Erro ao processar a operação.", new[] { memberName }));
            }
        }

    }
}
