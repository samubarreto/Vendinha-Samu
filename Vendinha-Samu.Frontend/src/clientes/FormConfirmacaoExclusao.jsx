import { deletarCliente } from "../services/clienteApi.js"

export default function FormConfirmacaoExclusao({ cliente, onClose }) {

  const apagarCliente = async (evento) => {
    evento.preventDefault();

    var result = await deletarCliente(cliente.id);
    if (result.status == 200) {
      onClose();
      window.location.reload();
    }
  };

  return (

    <div className="modal">
      <form onSubmit={apagarCliente} className="exclusao-form">
        <h2>Confirme a Exclusão do Cliente:</h2>
        <p>{cliente.nomeCompleto}</p>
        <label>⚠️Todas suas dívidas também serão apagadas</label>
        <div className="flex-row">
          <button type="reset" onClick={onClose}>Cancelar</button>
          <button type="submit">Confirmar</button>
        </div>
      </form>
    </div>

  )
}