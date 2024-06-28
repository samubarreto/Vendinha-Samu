import { deletarDivida } from "../services/dividaApi"

export default function ConfirmacaoExclusaoDivida({ divida, onClose }) {

  const apagarDivida = async (evento) => {
    evento.preventDefault();

    var result = await deletarDivida(divida.idDivida);
    if (result.status == 200) {
      onClose();
      window.location.reload();
    }
  };

  return (
    <>

      <div className="modal">
        <form onSubmit={apagarDivida} className="exclusao-form">
          <h2>Confirme a Exclusão da Dívida:</h2>
          <p className="delete-nome-cliente">{divida.descricao}</p>
          <div className="flex-row">
            <button type="reset" onClick={onClose}>Cancelar</button>
            <button type="submit">Confirmar</button>
          </div>
        </form>
      </div>

    </>
  )
}