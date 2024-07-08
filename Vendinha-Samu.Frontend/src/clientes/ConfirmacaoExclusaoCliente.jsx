import { deletarCliente } from "../services/clienteApi.js"
import { useNavigation } from 'simple-react-routing';
import { useState } from "react";

export default function FormConfirmacaoExclusao({ cliente, onClose, debt = false }) {

  const { navigateTo } = useNavigation();
  const [closing, setClosing] = useState(false);

  const apagarCliente = async (evento) => {
    evento.preventDefault();

    var result = await deletarCliente(cliente.id);
    if (result.status == 200 && debt) {
      onClose();
      navigateTo(null, '/clientes');
    } else {
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

    <div className={`modal ${closing ? 'close' : ''}`}>
      <form onSubmit={apagarCliente} className="short-form">
        <h2>Confirme a Exclusão do Cliente:</h2>
        <p className="short-form-p">{cliente.nomeCompleto}</p>
        <label>⚠️Todas suas dívidas também serão apagadas</label>
        <div className="flex-row">
          <button type="reset" onClick={handleClose}>Cancelar</button>
          <button type="submit">Confirmar</button>
        </div>
      </form>
    </div>

  )
}