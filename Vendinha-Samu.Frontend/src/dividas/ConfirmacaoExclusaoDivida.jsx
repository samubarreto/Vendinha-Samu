import { deletarDivida } from "../services/dividaApi"
import { useState } from "react";

export default function ConfirmacaoExclusaoDivida({ divida, onClose }) {

  const [closing, setClosing] = useState(false);

  const apagarDivida = async (evento) => {
    evento.preventDefault();

    var result = await deletarDivida(divida.idDivida);
    if (result.status == 200) {
      onClose();
      window.location.reload();
    }
  };

  const handleClose = () => {
    setClosing(true);
    setTimeout(() => {
      onClose();
    }, 150);
  };

  return (
    <>

      <div className={`modal ${closing ? 'close' : ''}`}>
        <form onSubmit={apagarDivida} className="short-form">
          <h2>Confirme a Exclusão da Dívida:</h2>
          <p className="short-form-p">{divida.descricao.length > 50 ? `${(divida.descricao).substring(0, 50)}[...]` : divida.descricao}</p>
          <div className="flex-row">
            <button type="reset" onClick={handleClose}>Cancelar</button>
            <button type="submit">Confirmar</button>
          </div>
        </form>
      </div>

    </>
  )
}