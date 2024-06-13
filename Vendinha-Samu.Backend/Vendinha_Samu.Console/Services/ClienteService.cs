using NHibernate;
using System.ComponentModel.DataAnnotations;
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
            if (GeneralServices.Validacao(cliente, out erros))
            {
                using var sessao = session.OpenSession();
                using var transaction = sessao.BeginTransaction();
                sessao.Save(cliente);
                transaction.Commit();
                return true;
            }
            return false;
        }

        public bool Editar(Cliente cliente, out List<ValidationResult> erros)
        {
            if (GeneralServices.Validacao(cliente, out erros))
            {
                using var sessao = session.OpenSession();
                using var transaction = sessao.BeginTransaction();
                sessao.Merge(cliente);
                transaction.Commit();
                return true;
            }
            return false;
        }

        public bool Excluir(int id, out List<ValidationResult> erros)
        {
            erros = new List<ValidationResult>();
            using var sessao = session.OpenSession();
            using var transaction = sessao.BeginTransaction();
            var cliente = sessao.Query<Cliente>().Where(c => c.Id == id).FirstOrDefault();
            if (cliente == null)
            {
                erros.Add(new ValidationResult("Registro não encontrado", new[] { "id" }));
                return false;
            }

            sessao.Delete(cliente);
            transaction.Commit();
            return true;
        }

        public virtual List<Cliente> Listar()
        {
            using var sessao = session.OpenSession();
            var clientes = sessao.Query<Cliente>().OrderBy(c => c.Id).ToList();
            return clientes;
        }

        public virtual List<Cliente> Listar(string buscaCliente, int skip = 0, int pageSize = 0)
        {
            using var sessao = session.OpenSession();
            var clientes = sessao.Query<Cliente>().Where(c => c.NomeCompleto.Contains(buscaCliente) ||
                                                              c.Email.Contains(buscaCliente)).OrderBy(cliente => cliente.Id).ToList();
            return clientes;
        }
    }
}