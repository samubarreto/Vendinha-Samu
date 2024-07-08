import { postPutDivida } from "../services/dividaApi"
import { useState } from "react";

export default function ConfirmacaoBaixaDivida({ divida, onClose }) {

  const [closing, setClosing] = useState(false);

  const baixarDivida = async (evento) => {
    evento.preventDefault();

    let dividaDados = {
      idDivida: divida.idDivida,
      idCliente: divida.idCliente,
      valor: divida.valor,
      dataCriacao: divida.dataCriacao,
      situacao: true,
      dataPagamento: divida.dataPagamento,
      descricao: divida.descricao
    };

    const response = await postPutDivida(dividaDados);
    if (response.status === 200) {
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
        <form onSubmit={baixarDivida} className="short-form">
          <h2>Confirme a Baixa da Dívida:</h2>
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