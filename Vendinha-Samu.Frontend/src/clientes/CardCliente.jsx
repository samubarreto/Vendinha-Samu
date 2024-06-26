import { useState } from 'react';
import { calculaIdade } from '../services/general.js';
import { getClienteById, uparImagemPerfil } from '../services/clienteApi.js';
import FormConfirmacaoExclusao from './FormConfirmacaoExclusao.jsx';
import FormCliente from './FormCliente.jsx';
import FormImgPerfil from './FormImgPerfil.jsx';

export default function CardCliente(properties) {

  const cliente = properties.cliente;
  let idadeCliente = calculaIdade(cliente.dataNascimento);

  var [getClienteDelete, setClienteDelete] = useState(undefined);
  var [getClienteEdit, setClienteEdit] = useState(undefined);
  const [getClienteImgPerfil, setClienteImgPerfil] = useState(false);

  const getClienteApi = async (id, contexto) => {
    var result = await getClienteById(id);
    if (result.status == 200) {
      var dados = await result.json();

      switch (contexto) {
        case "IMG":
          setClienteImgPerfil(dados);
          break;
        case "EDIT":
          setClienteEdit(dados);
          break;
        case "DELETE":
          setClienteDelete(dados);
          break
      }
    }
  }

  return (
    <>

      <div className="client-card">
        <div className="profile-img-row">

          <img className="profile-img" src={cliente.urlPerfil} alt="Imagem de Perfil"></img>
          <button className="edit-img-button" onClick={() => getClienteApi(cliente.id, "IMG")} key={`img-${cliente.id}`}>
            <svg xmlns="http://www.w3.org/2000/svg" className="base-icon" viewBox="0 0 16 16">
              <path d="M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0" />
              <path d="M2 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2zm12 1a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1v-1c0-1-1-4-6-4s-6 3-6 4v1a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1z" />
            </svg>
          </button>

          <div className="vertical-buttons">
            <button className="small-button top" onClick={() => getClienteApi(cliente.id, "EDIT")} key={`edit-${cliente.id}`}>
              <svg xmlns="http://www.w3.org/2000/svg" className="base-icon" viewBox="0 0 16 16">
                <path d="m13.498.795.149-.149a1.207 1.207 0 1 1 1.707 1.708l-.149.148a1.5 1.5 0 0 1-.059 2.059L4.854 14.854a.5.5 0 0 1-.233.131l-4 1a.5.5 0 0 1-.606-.606l1-4a.5.5 0 0 1 .131-.232l9.642-9.642a.5.5 0 0 0-.642.056L6.854 4.854a.5.5 0 1 1-.708-.708L9.44.854A1.5 1.5 0 0 1 11.5.796a1.5 1.5 0 0 1 1.998-.001" />
              </svg>
            </button>
            <button className="small-button bottom" onClick={() => getClienteApi(cliente.id, "DELETE")} key={`delete-${cliente.id}`}>
              <svg xmlns="http://www.w3.org/2000/svg" className="base-icon" viewBox="0 0 16 16">
                <path d="M2.5 1a1 1 0 0 0-1 1v1a1 1 0 0 0 1 1H3v9a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V4h.5a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H10a1 1 0 0 0-1-1H7a1 1 0 0 0-1 1zm3 4a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 .5-.5M8 5a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7A.5.5 0 0 1 8 5m3 .5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 1 0" />
              </svg>
            </button>
          </div>

        </div>

        <p className="client-name-age">{cliente.nomeCompleto}, {idadeCliente}</p>
        <p className="client-email">{cliente.email}</p>
        {/* <Link to={`cliente/${cliente.id}/dividas`}> */}
        <button className="debt-sum-client" style={{
          backgroundColor: cliente.somatorioDividasEmAberto == 0
            ? 'var(--cor-verde)'
            : 'var(--cor-vermelho)'
        }}>R${(cliente.somatorioDividasEmAberto).toFixed(2)}
          <svg xmlns="http://www.w3.org/2000/svg" className="base-icon debt-svg" viewBox="0 0 16 16">
            <path d="M1 3a1 1 0 0 1 1-1h12a1 1 0 0 1 1 1zm7 8a2 2 0 1 0 0-4 2 2 0 0 0 0 4" />
            <path d="M0 5a1 1 0 0 1 1-1h14a1 1 0 0 1 1 1v8a1 1 0 0 1-1 1H1a1 1 0 0 1-1-1zm3 0a2 2 0 0 1-2 2v4a2 2 0 0 1 2 2h10a2 2 0 0 1 2-2V7a2 2 0 0 1-2-2z" />
          </svg>
        </button>
        {/* </Link> */}

      </div>
      {getClienteImgPerfil && <FormImgPerfil cliente={cliente} onClose={() => setClienteImgPerfil(undefined)} />}
      {getClienteDelete && <FormConfirmacaoExclusao cliente={cliente} onClose={() => setClienteDelete(undefined)} />}
      {getClienteEdit && <FormCliente cliente={cliente} onClose={() => setClienteEdit(undefined)} contexto={"Editar "} />}
    </>
  )
}