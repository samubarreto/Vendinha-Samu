using Vendinha_Samu.Console.Entidades;
using Vendinha_Samu.Console.DTOs;
using Vendinha_Samu.Console.Services;
using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;

namespace Vendinha_Samu.Api.Controllers
{
    [Route("api/clientes")]
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

        //[HttpGet("divida")]
        //public IActionResult ListarClientesDividaTotal(string pesquisa, int skip = 0, int pageSize = 0)
        //{
        //    var clientes = string.IsNullOrEmpty(pesquisa) ? clienteService.ListarClientesDividaTotal() : clienteService.ListarClientesDividaTotal(pesquisa, skip, pageSize);
        //    return Ok(clientes);
        //}

        [HttpPost]
        public IActionResult Criar([FromBody] Cliente cliente)
        {
            if (cliente == null)
            {
                return BadRequest(ModelState);
            }

            var sucesso = clienteService.Criar(cliente, out List<ValidationResult> erros);
            if (sucesso)
            {
                return Ok($"Cliente {cliente.NomeCompleto} cadastrado!");
            }
            else
            {
                return UnprocessableEntity(erros);
            }
        }

        [HttpPut]
        public IActionResult Editar([FromBody] Cliente cliente)
        {
            if (cliente == null)
            {
                return BadRequest(ModelState);
            }

            var sucesso = clienteService.Editar(cliente, out List<ValidationResult> erros);
            if (sucesso)
            {
                return Ok($"Cliente {cliente.NomeCompleto} editado!");
            }
            else
            {
                return UnprocessableEntity(erros);
            }
        }

        [HttpDelete("{idcliente}")]
        public IActionResult Remover(int idcliente)
        {
            var sucesso = clienteService.Excluir(idcliente, out List<ValidationResult> erros);
            if (sucesso)
            {
                return Ok($"Cliente com id {idcliente} removido com sucesso.");
            }
            else
            {
                return NotFound(erros);
            }
        }
    }
}
