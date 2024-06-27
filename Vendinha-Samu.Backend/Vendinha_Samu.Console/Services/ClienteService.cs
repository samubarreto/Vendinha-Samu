using NHibernate;
using NHibernate.Linq;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using Vendinha_Samu.Console.Entidades;

namespace Vendinha_Samu.Console.Services
{
    public class ClienteService
    {
        private readonly ISessionFactory session;

        public ClienteService(ISessionFactory session)
        {
            this.session = session;
        }

        public bool Criar(Cliente cliente, out List<ValidationResult> erros)
        {
            erros = new List<ValidationResult>();

            if (!GeneralServices.Validacao(cliente, out erros))
                return false;

            using var sessao = session.OpenSession();
            using var transaction = sessao.BeginTransaction();
            try
            {
                sessao.Save(cliente);
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

        public bool Editar(Cliente cliente, out List<ValidationResult> erros)
        {
            erros = new List<ValidationResult>();

            if (!GeneralServices.Validacao(cliente, out erros))
            {
                return false;
            }

            using var sessao = session.OpenSession();
            using var transaction = sessao.BeginTransaction();

            var clienteExistente = sessao.Get<Cliente>(cliente.Id);
            if (clienteExistente == null)
            {
                erros.Add(new ValidationResult("Este Cliente não existe!", new[] { nameof(cliente.Id) }));
                return false;
            }

            try
            {
                sessao.Merge(cliente);
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
            var cliente = sessao.Query<Cliente>().FirstOrDefault(c => c.Id == id);
            if (cliente == null)
            {
                erros.Add(new ValidationResult("Registro não encontrado", new[] { nameof(id) }));
                return false;
            }

            try
            {
                sessao.Delete(cliente);
                transaction.Commit();
                return true;
            }
            catch (Exception)
            {
                transaction.Rollback();
                erros.Add(new ValidationResult($"Ocorreu um erro ao Excluir o Cliente [{cliente.Id}] {cliente.NomeCompleto} ", new[] { nameof(id) }));
                return false;
            }
        }

        public List<Cliente> Listar(string pesquisa = "", int skip = 0, int pageSize = 0)
        {
            using var sessao = session.OpenSession();
            var consulta = sessao.Query<Cliente>();

            if (!string.IsNullOrEmpty(pesquisa))
            {
                consulta = consulta.Where(c => c.NomeCompleto.ToUpper().Contains(pesquisa.ToUpper()));
            }

            consulta = consulta.OrderByDescending(c => c.SomatorioDividasEmAberto).OrderBy(c => c.NomeCompleto);

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

        public Cliente RetornaPeloId(int id_cliente)
        {
            return session.OpenSession().Get<Cliente>(id_cliente);
        }

        private void HandleException(Exception ex, List<ValidationResult> erros, string memberName = "")
        {
            var message = ex.InnerException?.Message ?? ex.Message;

            if (message.Contains("unique_cpf"))
            {
                erros.Add(new ValidationResult("Este CPF já está cadastrado", new[] { nameof(Cliente.Cpf) }));
            }
            else if (message.Contains("unique_email"))
            {
                erros.Add(new ValidationResult("Este Email já está cadastrado", new[] { nameof(Cliente.Email) }));
            }
            else if (message.Contains("data de nascimento"))
            {
                erros.Add(new ValidationResult("Insira uma Data de Nascimento válida", new[] { nameof(Cliente.DataNascimento) }));
            }
            else
            {
                erros.Add(new ValidationResult("Erro ao processar a operação", new[] { memberName }));
            }
        }
    }
}
