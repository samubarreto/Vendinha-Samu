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
                } catch (Exception ex)
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
            var divida = sessao.Query<Divida>().Where(d => d.IdDivida == id).FirstOrDefault();
            if (divida == null)
            {
                erros.Add(new ValidationResult("Registro não encontrado", new[] { "id" }));
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

        public virtual List<Divida> Listar()
        {
            using var sessao = session.OpenSession();
            try
            {
                var dividas = sessao.Query<Divida>().OrderBy(d => d.IdDivida).ToList();
                return dividas;
            }
            catch (Exception)
            {
                return [];
            }
        }

        public virtual List<Divida> Listar(string buscaCliente, int skip = 0, int pageSize = 0)
        {
            using var sessao = session.OpenSession();
            var consulta = sessao.Query<Divida>().Where(d => d.Descricao.Contains(buscaCliente) ||
                                                             d.Valor.ToString().Contains(buscaCliente) ||
                                                             d.DataCriacao.ToString().Contains(buscaCliente) ||
                                                             d.DataPagamento.ToString().Contains(buscaCliente) ||
                                                             d.IdDivida.ToString().Contains(buscaCliente))
                                                             .OrderBy(divida => divida.IdDivida)
                                                             .AsEnumerable();
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
