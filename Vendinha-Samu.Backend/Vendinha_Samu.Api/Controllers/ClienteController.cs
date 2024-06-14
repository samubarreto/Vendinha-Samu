using Vendinha_Samu.Console.Entidades;
using Vendinha_Samu.Console.Services;
using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;

namespace Vendinha_Samu.Api.Controllers
{
    [Route("api/[controller]")]
    public class ClienteController : ControllerBase
    {
        private readonly ClienteService clienteService;

        public ClienteController(ClienteService clienteService)
        {
            this.clienteService = clienteService;
        }

        [HttpGet]
        public IActionResult Listar(string pesquisa, int skip = 0, int pageSize = 0)
        {
            var clientes = string.IsNullOrEmpty(pesquisa) ? clienteService.Listar() : clienteService.Listar(pesquisa, skip, pageSize);
            return Ok(clientes);
        }

        [HttpPost]
        public IActionResult Criar([FromBody] Cliente cliente)
        {
            if (cliente == null)
            {
                return BadRequest(ModelState);
            }

            var retornoCriacao = clienteService.Criar(cliente, out List<ValidationResult> erros);
            if (retornoCriacao == "Ok")
            {
                return Ok($"Cliente {cliente.NomeCompleto} cadastrado!");
            }
            else
            {
                return UnprocessableEntity($"Erro ao cadastrar: {retornoCriacao}");
            }
        }

        [HttpPut]
        public IActionResult Editar([FromBody] Cliente cliente)
        {
            if (cliente == null)
            {
                return BadRequest(ModelState);
            }

            var retornoEdicao = clienteService.Editar(cliente, out List<ValidationResult> erros);
            if (retornoEdicao == "Ok")
            {
                return Ok($"Cliente {cliente.NomeCompleto} editado!");
            }
            else
            {
                return UnprocessableEntity($"Erro ao editar: {retornoEdicao}");
            }
        }

        [HttpDelete("{idcliente}")]
        public IActionResult Remover(int idcliente)
        {
            var cliente = clienteService.Excluir(idcliente, out List<ValidationResult> erros);
            if (erros.Count == 0)
            {
                return Ok(cliente);
            }
            else
            {
                return NotFound(cliente);
            }
        }
    }
}
