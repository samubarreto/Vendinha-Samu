using NHibernate;
using System.ComponentModel.DataAnnotations;
using Vendinha_Samu.Console.Entidades;
using System;
using System.Collections.Generic;
using System.Linq;
using static System.Runtime.InteropServices.JavaScript.JSType;

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
                    HandleException(ex, erros);
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
                    erros.Add(new ValidationResult("Este Cliente não existe!"));
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
                    HandleException(ex, erros);
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

        private void HandleException(Exception ex, List<ValidationResult> erros)
        {
            if (ex.InnerException != null)
            {
                if (ex.InnerException.Message.Contains("unique_cpf"))
                {
                    erros.Add(new ValidationResult("Este CPF já está cadastrado!"));
                }
                else if (ex.InnerException.Message.Contains("unique_email"))
                {
                    erros.Add(new ValidationResult("Este Email já está cadastrado!"));
                }
                else
                {
                    erros.Add(new ValidationResult("Erro ao processar a operação."));
                }
            }
            else
            {
                erros.Add(new ValidationResult("Erro ao processar a operação."));
            }
        }
    }
}
