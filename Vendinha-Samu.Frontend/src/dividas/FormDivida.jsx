import { postPutDivida } from "../services/dividaApi.js"
import { useState } from "react";
import { useRouter } from "simple-react-routing";

export default function FormDivida({ divida, onClose, contexto }) {

  const { pathParams } = useRouter();
  const idClientePath = pathParams["id"];
  const [getErrorMessage, setErrorMessage] = useState("");

  const editarCriarDivida = async (evento) => {
    evento.preventDefault();
    var dados = new FormData(evento.target);

    let dividaDados;
    if (contexto === "Editar ") {
      dividaDados = {
        idDivida: divida.idDivida,
        idCliente: divida.idCliente,
        valor: Number((dados.get("valor")).replaceAll(",", ".")),
        situacao: false,
        descricao: dados.get("descricao")
      };
    } else {
      dividaDados = {
        idCliente: idClientePath,
        valor: Number((dados.get("valor")).replaceAll(",", ".")),
        situacao: false,
        descricao: dados.get("descricao"),
        dataPagamento: null
      };
    }

    try {
      const response = await postPutDivida(dividaDados);
      if (response.status === 200) {
        onClose();
        window.location.reload();
      } else {
        const result = await response.json();
        const errorMessage = result.map(error => error.errorMessage).join(" · ");
        setErrorMessage("⚠️ " + errorMessage);
      }
    } catch (error) {
      setErrorMessage(`⚠️ Ocorreu um erro ao ${(contexto === "Inserir " ? "inserir" : "editar ")} a dívida.`);
    }
  }

  return (
    <>
      <div className="modal">
        <form className="edicao-divida-form" onSubmit={editarCriarDivida}>
          <h2>{contexto}Dívida</h2>

          <div className="label-input-container large">
            <label htmlFor="valor" className="form-label">Valor da Dívida &#10090;R$&#10091;:</label>
            <input type="decimal" name="valor" id="valor" placeholder="Insira o Valor da Dívida" defaultValue={contexto === "Editar " ? divida.valor : ""} required />
          </div>

          <div className="label-input-container extra-large">
            <label htmlFor="descricao" className="form-label">Descrição da Dívida:</label>
            <textarea cols="45" rows="5" name="descricao" id="descricao" placeholder="Insira a Descrição da Dívida" defaultValue={contexto === "Editar " ? divida.descricao : ""} required />
          </div>

          <div className="flex-row form-cliente">
            <button type="reset" onClick={onClose}>Cancelar</button>
            <button type="submit">{contexto === "Editar " ? "Editar" : "Inserir"}</button>
          </div>

          <p className="api-error-message">{getErrorMessage}</p>

        </form>
      </div>
    </>
  )
}