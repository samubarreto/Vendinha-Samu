import { deletarCliente } from "../services/clienteApi.js"
import { useNavigation } from 'simple-react-routing';

export default function FormConfirmacaoExclusao({ cliente, onClose, debt = false }) {

  const { navigateTo } = useNavigation();

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

  return (

    <div className="modal">
      <form onSubmit={apagarCliente} className="exclusao-form">
        <h2>Confirme a Exclusão do Cliente:</h2>
        <p className="delete-nome-cliente">{cliente.nomeCompleto}</p>
        <label>⚠️Todas suas dívidas também serão apagadas</label>
        <div className="flex-row">
          <button type="reset" onClick={onClose}>Cancelar</button>
          <button type="submit">Confirmar</button>
        </div>
      </form>
    </div>

  )
}