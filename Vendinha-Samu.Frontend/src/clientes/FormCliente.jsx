import { postPutCliente } from "../services/clienteApi.js"
import { formataData } from "../services/general.js"
import { useState } from "react";

export default function FormCliente({ cliente, onClose, contexto }) {
  const [getErrorMessage, setErrorMessage] = useState("");

  const editarCriarCliente = async (evento) => {
    evento.preventDefault();
    var dados = new FormData(evento.target);

    let clienteDados;
    if (contexto === "Editar ") {
      clienteDados = {
        id: cliente.id,
        nomeCompleto: dados.get("nomeCompleto"),
        cpf: ((dados.get("cpf")).replaceAll(".", "")).replaceAll("-", ""),
        dataNascimento: dados.get("dataNascimento"),
        email: dados.get("email"),
        numeroCelular: dados.get("numero-celular"),
        urlPerfil: cliente.urlPerfil,
        somatorioDividasEmAberto: cliente.somatorioDividasEmAberto
      };
    } else {
      clienteDados = {
        nomeCompleto: dados.get("nomeCompleto"),
        cpf: ((dados.get("cpf")).replaceAll(".", "")).replaceAll("-", ""),
        dataNascimento: dados.get("dataNascimento"),
        email: dados.get("email") === "" ? null : dados.get("email"),
        numeroCelular: dados.get("numero-celular"),
        urlPerfil: "https://127.0.0.1:7258/profile_pics/profile_placeholder.png",
        somatorioDividasEmAberto: 0
      };
    }

    try {
      const response = await postPutCliente(clienteDados);
      if (response.status === 200) {
        onClose();
        window.location.reload();
      } else {
        const result = await response.json();
        const errorMessage = result.map(error => error.errorMessage).join(" · ");
        setErrorMessage("⚠️ " + errorMessage);
      }
    } catch (error) {
      setErrorMessage(`⚠️ Ocorreu um erro ao ${(contexto === "Inserir " ? "inserir" : "editar ")} o cliente.`);
    }
  };

  return (
    <div className="modal">
      <form className="edicao-cliente-form" onSubmit={editarCriarCliente}>
        <h2>{contexto}Cliente</h2>

        <div className="flex-column jcc">
          <img src={contexto === "Editar " ? cliente.urlPerfil : "https://127.0.0.1:7258/profile_pics/profile_placeholder.png"} className="profile-img editing" alt="Profile"></img>
          <p className="info-text">&#10090;A imagem não é editável por aqui, Colega 🤠&#10091;</p>
        </div>

        <div className="label-input-container large">
          <label htmlFor="nomeCompleto" className="form-label">*Nome Completo &#10090;50&#10091;</label>
          <input type="text" name="nomeCompleto" id="nomeCompleto" placeholder="Insira o Nome Completo do Cliente" defaultValue={contexto === "Editar " ? cliente.nomeCompleto : ""} required />
        </div>

        <div className="flex-row">
          <div className="label-input-container small">
            <label htmlFor="cpf" className="form-label">*CPF &#10090;Dígitos&#10091;</label>
            <input type="text" name="cpf" id="cpf" placeholder="000.000.000-00" defaultValue={contexto === "Editar " ? cliente.cpf : ""} required />
          </div>
          <div className="label-input-container small">
            <label htmlFor="dataNascimento" className="form-label">*Data de Nascimento</label>
            <input type="date" name="dataNascimento" id="dataNascimento" defaultValue={contexto === "Editar " ? formataData(cliente.dataNascimento) : ""} required />
          </div>
        </div>

        <div className="label-input-container large">
          <label htmlFor="numero-celular" className="form-label">*Número &#10090;DDD + Dígitos&#10091;</label>
          <input type="text" name="numero-celular" id="numero-celular" placeholder="12345678901" defaultValue={contexto === "Editar " ? cliente.numeroCelular : ""} required />
        </div>

        <div className="label-input-container large">
          <label htmlFor="email" className="form-label">E-mail</label>
          <input type="email" name="email" id="email" placeholder="exemplo@exemplo.com" defaultValue={contexto === "Editar " ? cliente.email : ""} />
        </div>

        <div className="flex-row form-cliente">
          <button type="reset" onClick={onClose}>Cancelar</button>
          <button type="submit">{contexto === "Editar " ? "Editar" : "Inserir"}</button>
        </div>

        <p className="api-error-message">{getErrorMessage}</p>
      </form>
    </div>
  )
}
