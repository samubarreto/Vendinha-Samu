using Vendinha_Samu.Console.Entidades;
using Vendinha_Samu.Console.Services;
using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;

namespace Vendinha_Samu.Api.Controllers
{
    [Route("api/dividas")]
    public class DividaController : ControllerBase
    {
        private readonly DividaService dividaService;
        public DividaController(DividaService dividaService)
        {
            this.dividaService = dividaService;
        }

        [HttpGet("{id_cliente_divida}")]
        public IActionResult Listar(int id_cliente_divida)
        {
            return Ok(dividaService.Listar(id_cliente_divida));
        }

        [HttpPost]
        public IActionResult Criar([FromBody] Divida divida)
        {
            if (divida == null)
            {
                return BadRequest(ModelState);
            }

            var sucesso = dividaService.Criar(divida, out List<ValidationResult> erros);
            if (sucesso)
            {
                return Ok($"Divida {divida.IdDivida} cadastrada!");
            }
            else
            {
                return UnprocessableEntity(erros);
            }
        }

        [HttpPut]
        public IActionResult Editar([FromBody] Divida divida)
        {
            if (divida == null)
            {
                return BadRequest(ModelState);
            }

            var sucesso = dividaService.Editar(divida, out List<ValidationResult> erros);
            if (sucesso)
            {
                return Ok($"Dívida {divida.IdDivida} editada!");
            }
            else
            {
                return UnprocessableEntity(erros);
            }
        }

        [HttpDelete("{id_divida}")]
        public IActionResult Remover(int id_divida)
        {
            var sucesso = dividaService.Excluir(id_divida, out List<ValidationResult> erros);
            if (sucesso)
            {
                return Ok($"Dívida com id {id_divida} removido com sucesso.");
            }
            else
            {
                return NotFound(erros);
            }
        }
    }
}
