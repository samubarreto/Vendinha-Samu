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
        public bool CriarDivida(Divida divida, out List<ValidationResult> erros)
        {
            if (GeneralServices.Validacao(divida, out erros))
            {
                using var sessao = session.OpenSession();
                using var transaction = sessao.BeginTransaction();
                sessao.Save(divida);
                transaction.Commit();
                return true;
            }
            return false;
        }

        public bool Editar(Divida divida, out List<ValidationResult> erros)
        {
            if (GeneralServices.Validacao(divida, out erros))
            {
                using var sessao = session.OpenSession();
                using var transaction = sessao.BeginTransaction();
                sessao.Merge(divida);
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
            var divida = sessao.Query<Divida>().Where(d => d.IdDivida == id).FirstOrDefault();
            if (divida == null)
            {
                erros.Add(new ValidationResult("Registro não encontrado", new[] { "id" }));
                return false;
            }

            sessao.Delete(divida);
            transaction.Commit();
            return true;
        }

        public virtual List<Divida> Listar()
        {
            using var sessao = session.OpenSession();
            var dividas = sessao.Query<Divida>().ToList();
            return dividas;
        }

        public virtual List<Divida> Listar(string busca)
        {
            using var sessao = session.OpenSession();
            var dividas = sessao.Query<Divida>().Where(d => d.Descricao.Contains(busca)).OrderBy(d => d.IdDivida).ToList();
            return dividas;
        }
    }
}
