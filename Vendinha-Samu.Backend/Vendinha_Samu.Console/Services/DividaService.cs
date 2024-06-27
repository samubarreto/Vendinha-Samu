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
            erros = new List<ValidationResult>();

            if (!GeneralServices.Validacao(divida, out erros))
                return false;

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
                transaction.Rollback();
                HandleException(ex, erros);
                return false;
            }
        }

        public bool Editar(Divida divida, out List<ValidationResult> erros)
        {
            erros = new List<ValidationResult>();

            if (!GeneralServices.Validacao(divida, out erros))
                return false;

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
                transaction.Rollback();
                HandleException(ex, erros);
                return false;
            }
        }

        public bool Excluir(int id, out List<ValidationResult> erros)
        {
            erros = new List<ValidationResult>();

            using var sessao = session.OpenSession();
            using var transaction = sessao.BeginTransaction();

            var divida = sessao.Query<Divida>().FirstOrDefault(d => d.IdDivida == id);
            if (divida == null)
            {
                erros.Add(new ValidationResult($"Registro de dívida [{id}] não encontrado", new[] { nameof(id) }));
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
                transaction.Rollback();
                erros.Add(new ValidationResult($"Não foi possível apagar a Dívida [{divida.IdDivida}]. {ex.Message}", new[] { nameof(id) }));
                return false;
            }
        }

        public List<Divida> ListarDividasDeUmCliente(int idClienteDivida, int skip = 0, int pageSize = 0)
        {
            using var sessao = session.OpenSession();
            var consulta = sessao.Query<Divida>();
            try
            {
                consulta = consulta.Where(d => d.IdCliente == idClienteDivida).OrderBy(d => d.Situacao).ThenByDescending(d => d.Valor);

                if (skip > 0)
                {
                    consulta = consulta.Skip(skip);
                }

                if (pageSize > 0)
                {
                    consulta = consulta.Take(pageSize);
                }

                return consulta.ToList();
            }
            catch (Exception)
            {
                return new List<Divida>();
            }
        }

        private void HandleException(Exception ex, List<ValidationResult> erros, string memberName = "")
        {
            var message = ex.InnerException?.Message ?? ex.Message;

            if (message.Contains("descricao"))
            {
                erros.Add(new ValidationResult("Insira uma Descrição para a Dívida", new[] { nameof(Divida.Descricao) }));
            }
            else if (message.Contains("Total de dívidas do cliente é maior que 200"))
            {
                erros.Add(new ValidationResult("O total de dívidas em aberto não pode ser maior que 200 Reais. Inserção impedida", new[] { nameof(Divida.Valor) }));
            }
            else
            {
                erros.Add(new ValidationResult("Erro ao processar a operação", new[] { memberName }));
            }
        }
    }
}
