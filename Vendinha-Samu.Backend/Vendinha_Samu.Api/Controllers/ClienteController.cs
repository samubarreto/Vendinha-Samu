using Vendinha_Samu.Console.Entidades;
using Vendinha_Samu.Console.Services;
using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;

namespace Vendinha_Samu.Api.Controllers
{
    [Route("api/clientes")]
    public class ClienteController : ControllerBase
    {
        private readonly ClienteService clienteService;
        private readonly IWebHostEnvironment env;

        public ClienteController(ClienteService clienteService, IWebHostEnvironment env)
        {
            this.clienteService = clienteService;
            this.env = env;
        }

        [HttpGet]
        public IActionResult Listar(string pesquisa, int skip, int pageSize)
        {
            return Ok(clienteService.Listar(pesquisa, skip, pageSize));
        }

        [HttpGet("{idcliente}")]
        public IActionResult RetornaPeloId(int idcliente)
        {
            return Ok(clienteService.RetornaPeloId(idcliente));
        }

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

        [HttpPost("[action]/{id_cliente}")]
        public IActionResult UploadProfilePic(int id_cliente)
        {
            var cliente = clienteService.RetornaPeloId(id_cliente);
            if (cliente == null)
            {
                return NotFound();
            }

            var imagem = Request.Form.Files.FirstOrDefault();
            if (imagem == null)
            {
                return BadRequest("Nenhuma imagem foi enviada.");
            }

            var allowedExtensions = new[] { ".jpg", ".jpeg", ".png", ".gif" };
            var extension = Path.GetExtension(imagem.FileName).ToLower();
            if (!allowedExtensions.Contains(extension))
            {
                return BadRequest("Formato de imagem não suportado.");
            }

            var nomeArquivo = Guid.NewGuid().ToString() + extension;

            var profilePicsPath = Path.Combine(env.WebRootPath, "profile_pics");
            if (!Directory.Exists(profilePicsPath))
            {
                Directory.CreateDirectory(profilePicsPath);
            }

            var filePath = Path.Combine(profilePicsPath, nomeArquivo);
            using (var stream = new FileStream(filePath, FileMode.Create))
            {
                imagem.CopyTo(stream);
            }

            cliente.UrlPerfil = $"http://127.0.0.1:7258/profile_pics/{nomeArquivo}";
            clienteService.Editar(cliente, out _);

            return Ok(new { cliente.UrlPerfil });
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
