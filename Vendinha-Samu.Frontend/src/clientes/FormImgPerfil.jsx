import { uparImagemPerfil, putCliente } from "../services/clienteApi.js"

export default function FormImgPerfil({ cliente, onClose }) {

  const uparImagem = async (evento) => {
    evento.preventDefault();

    var result = await uparImagemPerfil(evento.target, cliente.id);
    if (result.status == 200) {
      onClose();
      window.location.reload();
    } else {

      var clienteDados = {
        id: cliente.id,
        nomeCompleto: cliente.nomeCompleto,
        cpf: cliente.cpf,
        dataNascimento: cliente.dataNascimento,
        email: cliente.email,
        urlPerfil: "https://127.0.0.1:7258/profile_pics/profile_placeholder.png",
        somatorioDividasEmAberto: cliente.somatorioDividasEmAberto
      };

      const response = await putCliente(clienteDados);
      if (response.status === 200) {
        onClose();
        window.location.reload();
      }
    }
  };

  return (

    <div className="modal">
      <form onSubmit={uparImagem} className="img-form">

        <h2>Selecione a Nova Imagem:</h2>

        <input type="file" name="imgPerfil" id="imgPerfil" placeholder="Escolher arquivo" accept="image/*" />

        <div className="flex-row">
          <button type="reset" onClick={onClose}>Cancelar</button>
          <button type="submit">Confirmar</button>
        </div>

        <p className="info-text">&#10090;Deixe vazio para remover a imagem atual 🤠&#10091;</p>

      </form>
    </div>

  )
}