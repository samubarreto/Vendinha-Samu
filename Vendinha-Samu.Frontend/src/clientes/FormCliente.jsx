import { putCliente, postCliente } from "../services/clienteApi.js"
import { formataData } from "../services/general.js"
import { useState } from "react";

export default function FormCliente({ cliente, onClose, contexto }) {

  const [getErrorMessage, setErrorMessage] = useState();

  const editarCliente = async (evento) => {
    evento.preventDefault();

    var dados = new FormData(evento.target);

    var clienteDados = {
      id: cliente.id,
      nomeCompleto: dados.get("nomeCompleto"),
      cpf: ((dados.get("cpf")).replaceAll(".", "")).replaceAll("-", ""),
      dataNascimento: dados.get("dataNascimento"),
      email: dados.get("email"),
      urlPerfil: cliente.urlPerfil,
      somatorioDividasEmAberto: cliente.somatorioDividasEmAberto
    };

    try {
      const response = await putCliente(clienteDados);
      if (response.status === 200) {
        onClose();
        window.location.reload();
      } else {
        const result = await response.json();
        const errorMessage = result.map(error => error.errorMessage).join(", ");
        setErrorMessage("⚠️ " + errorMessage);
      }
    } catch (error) {
      setErrorMessage("⚠️ Ocorreu um erro ao atualizar o cliente.");
    }
  };

  return (

    <div className="modal">
      <form className="edicao-cliente-form" onSubmit={editarCliente}>
        <h2>{cliente.id ? "Editar " : "Inserir "}Cliente</h2>

        <div className="flex-column jcc">
          <img src={cliente.urlPerfil} className="profile-img"></img>
          <p className="info-text">&#10090;A imagem não é editável por aqui, Pangaré 🤠&#10091;</p>
        </div>

        {/* <div className="label-input-container large">
          <label htmlFor="imgPerfil" className="form-label">Imagem de Perfil</label>
          <input type="file" name="imgPerfil" id="imgPerfil" placeholder="Escolher arquivo" accept="image/*" />
        </div> */}

        <div className="label-input-container large">
          <label htmlFor="nomeCompleto" className="form-label">*Nome Completo &#10090;50&#10091;</label>
          <input type="text" name="nomeCompleto" id="nomeCompleto" placeholder="Insira o Nome Completo do Cliente" defaultValue={cliente.nomeCompleto} />
        </div>

        <div className="flex-row">
          <div className="label-input-container small">
            <label htmlFor="cpf" className="form-label">*CPF &#10090;Dígitos&#10091;</label>
            <input type="text" name="cpf" id="cpf" placeholder="000.000.000-00" defaultValue={cliente.cpf} />
          </div>
          <div className="label-input-container small">
            <label htmlFor="dataNascimento" className="form-label">*Data de Nascimento</label>
            <input type="date" name="dataNascimento" id="dataNascimento" defaultValue={formataData(cliente.dataNascimento)} />
          </div>
        </div>

        <div className="label-input-container large">
          <label htmlFor="email" className="form-label">E-mail</label>
          <input type="email" name="email" id="email" placeholder="exemplo@exemplo.com" defaultValue={cliente.email} />
        </div>

        <div className="flex-row form-cliente">
          <button type="reset" onClick={onClose}>Cancelar</button>
          <button type="submit">Confirmar</button>
        </div>

        <p className="api-error-message">{getErrorMessage}</p>

      </form>
    </div>

  )
}