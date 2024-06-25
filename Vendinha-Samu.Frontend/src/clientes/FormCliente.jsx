import { postPutCliente } from "../services/clienteApi.js"

export default function FormCliente({ cliente, onClose }) {

  // const editarCliente = async (evento) => {
  //   evento.preventDefault();

  //   var result = await postPutCliente(cliente.id);
  //   if (result.status == 200) {
  //     onClose();
  //     window.location.reload();
  //   }
  // };

  return (

    <div className="modal">
      <form className="edicao-cliente-form">
        <h2>Editar Cliente</h2>

        <div className="label-input-container large">
          <label for="nomeCompleto" className="form-label">*Nome Completo (30)</label>
          <input type="text" name="nomeCompleto" id="nomeCompleto" placeholder="Insira o Nome Completo do Cliente" />
        </div>

        <div className="flex-row">
          <div className="label-input-container small">
            <label for="cpf" className="form-label">*CPF</label>
            <input type="text" name="cpf" id="cpf" placeholder="000.000.000-00" />
          </div>
          <div className="label-input-container small">
            <label for="dataNascimento" className="form-label">*Data de Nascimento</label>
            <input type="date" name="dataNascimento" id="dataNascimento" />
          </div>
        </div>

        <div className="label-input-container large">
          <label for="email" className="form-label">E-mail</label>
          <input type="email" name="email" id="email" placeholder="exemplo@exemplo.com" />
        </div>

        <div className="label-input-container large">
          <label for="imgPerfil" className="form-label">Imagem de Perfil</label>
          <input type="file" name="imgPerfil" id="imgPerfil" placeholder="Escolher arquivo" accept="image/*" />
        </div>

        <div className="flex-row form-cliente">
          <button type="reset" onClick={onClose}>Cancelar</button>
          <button type="submit">Confirmar</button>
        </div>

      </form>
    </div>

  )
}