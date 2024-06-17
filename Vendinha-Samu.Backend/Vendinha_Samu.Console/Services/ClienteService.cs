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
                try
                {
                    sessao.Save(cliente);
                    transaction.Commit();
                    return true;
                }
                catch (Exception ex)
                {
                    string memberName = "";
                    if (ex.InnerException != null)
                    {
                        if (ex.InnerException.Message.Contains("unique_cpf"))
                        {
                            memberName = nameof(cliente.Cpf);
                        }
                        else if (ex.InnerException.Message.Contains("unique_email"))
                        {
                            memberName = nameof(cliente.Email);
                        }
                        else if (ex.InnerException.Message.Contains("data de nascimento"))
                        {
                            memberName = nameof(cliente.DataNascimento);
                        }
                    }
                    HandleException(ex, erros, memberName);
                    return false;
                }
            }
            return false;
        }

        public bool Editar(Cliente cliente, out List<ValidationResult> erros)
        {
            if (GeneralServices.Validacao(cliente, out erros))
            {
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
                    string memberName = "";
                    if (ex.InnerException != null)
                    {
                        if (ex.InnerException.Message.Contains("unique_cpf"))
                        {
                            memberName = nameof(cliente.Cpf);
                        }
                        else if (ex.InnerException.Message.Contains("unique_email"))
                        {
                            memberName = nameof(cliente.Email);
                        }
                        else if (ex.InnerException.Message.Contains("data de nascimento"))
                        {
                            memberName = nameof(cliente.DataNascimento);
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
            try
            {
                var clientes = sessao.Query<Cliente>().OrderBy(c => c.Id).ToList();
                return clientes;
            }
            catch (Exception)
            {
                return [];
            }
        }

        public virtual List<Cliente> Listar(string buscaCliente, int skip = 0, int pageSize = 0)
        {
            using var sessao = session.OpenSession();
            var consulta = sessao.Query<Cliente>().Where(c => c.NomeCompleto.Contains(buscaCliente) ||
                                                              c.Email.Contains(buscaCliente) ||
                                                              c.Cpf.Contains(buscaCliente))
                                                              .OrderBy(cliente => cliente.Id)
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

        //public virtual List<ClienteComDividaDTO> ListarClientesDividaTotal(string buscaCliente = null, int skip = 0, int pageSize = 0)
        //{
        //    using var sessao = session.OpenSession();

        //    var consulta = sessao.Query<Cliente>()
        //                         .GroupJoin(sessao.Query<Divida>(),
        //                                    cliente => cliente.Id,
        //                                    divida => divida.IdCliente,
        //                                    (cliente, dividas) => new { Cliente = cliente, Dividas = dividas.DefaultIfEmpty() })
        //                         .Select(group => new ClienteComDividaDTO
        //                         {
        //                             IdCliente = group.Cliente.Id,
        //                             NomeCompleto = group.Cliente.NomeCompleto,
        //                             CPF = group.Cliente.Cpf,
        //                             Idade = DateTime.Now.Year - group.Cliente.DataNascimento.Year,
        //                             Email = group.Cliente.Email,
        //                             TotalDivida = group.Dividas.DefaultIfEmpty().Sum(d => d != null ? d.Valor : 0)
        //                         });

        //    if (!string.IsNullOrEmpty(buscaCliente))
        //    {
        //        consulta = consulta.Where(dto => dto.NomeCompleto.Contains(buscaCliente) ||
        //                                         dto.Email.Contains(buscaCliente) ||
        //                                         dto.CPF.Contains(buscaCliente));
        //    }

        //    consulta = consulta.OrderBy(dto => dto.TotalDivida);

        //    if (skip > 0)
        //    {
        //        consulta = consulta.Skip(skip);
        //    }
        //    if (pageSize > 0)
        //    {
        //        consulta = consulta.Take(pageSize);
        //    }

        //    return consulta.ToList();
        //}


        private void HandleException(Exception ex, List<ValidationResult> erros, string memberName = "")
        {
            if (ex.InnerException != null)
            {
                if (ex.InnerException.Message.Contains("unique_cpf"))
                {
                    erros.Add(new ValidationResult("Este CPF já está cadastrado!", new[] { memberName }));
                }
                else if (ex.InnerException.Message.Contains("unique_email"))
                {
                    erros.Add(new ValidationResult("Este Email já está cadastrado!", new[] { memberName }));
                }
                else if (ex.InnerException.Message.Contains("data de nascimento"))
                {
                    erros.Add(new ValidationResult("Insira uma Data de Nascimento válida!", new[] { memberName }));
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
