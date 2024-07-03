import BotaoNovaDivida from "./BotaoNovaDivida.jsx"
import Creditos from "../general/Creditos.jsx"
import ClienteSemDividas from "./ClienteSemDividas.jsx";
import ConfirmacaoExclusaoCliente from '../clientes/ConfirmacaoExclusaoCliente.jsx';
import FormCliente from '../clientes/FormCliente.jsx';
import ConfirmacaoExclusaoDivida from "./ConfirmacaoExclusaoDivida.jsx";
import ConfirmacaoBaixaDivida from "./ConfirmacaoBaixaDivida.jsx";
import FormDivida from "./FormDivida.jsx";

import { useEffect, useState } from "react";
import { Link, useRouter } from "simple-react-routing"

import { listarDividas } from "../services/dividaApi.js";
import { formataData, calculaIdade } from "../services/general.js";
import { getClienteById } from "../services/clienteApi.js";
import { getDividaById } from "../services/dividaApi.js";

export default function TabelaDividasDeUmCliente() {

  const { pathParams } = useRouter();
  const idClientePath = pathParams["id"];

  const [getCliente, setCliente] = useState([]);
  const [getDeleteCliente, setDeleteCliente] = useState();
  const [getEditCliente, setEditCliente] = useState();

  const [getDividas, setDividas] = useState([]);
  const [getDeleteDivida, setDeleteDivida] = useState();
  const [getBaixaDivida, setBaixaDivida] = useState();
  const [getEditDivida, setEditDivida] = useState();
  const [getCreateDivida, setCreateDivida] = useState();

  const [getPage, setPage] = useState(1);
  const [getTotalPaginas, setTotalPaginas] = useState(undefined);

  const getDividaApi = async (id, contexto) => {
    var result = await getDividaById(id);
    if (result.status == 200) {
      var dados = await result.json();

      switch (contexto) {
        case "BAIXA":
          setBaixaDivida(dados);
          break;
        case "EDIT":
          setEditDivida(dados);
          break;
        case "DELETE":
          setDeleteDivida(dados);
          break
      }
    }
  }

  useEffect(() => {
    getClienteById(idClientePath)
      .then(resposta => {
        if (resposta.status == 200) {
          resposta.json()
            .then(cliente => {
              setCliente(cliente);
            })
        }
      });
  }, []);

  useEffect(() => {
    listarDividas(idClientePath)
      .then(resposta => {
        if (resposta.status == 200) {
          resposta.json()
            .then(dividas => {
              setTotalPaginas(Math.ceil(dividas.length / 10));
            })
        }
      });
  }, [idClientePath]);

  useEffect(() => {
    listarDividas(idClientePath, getPage, 10)
      .then(resposta => {
        if (resposta.status == 200) {
          resposta.json()
            .then(dividas => {
              setDividas(dividas);
            })
        }
      });
  }, [idClientePath, getPage]);

  return (
    <>

      <main className="debt-table-container">

        <header className="debt-table-header">
          <div className="flex-row">
            <Link to="/clientes">
              <svg xmlns="http://www.w3.org/2000/svg" className="base-icon black large-icon back-clients-link" viewBox="0 0 16 16">
                <path d="m3.86 8.753 5.482 4.796c.646.566 1.658.106 1.658-.753V3.204a1 1 0 0 0-1.659-.753l-5.48 4.796a1 1 0 0 0 0 1.506z" />
              </svg>
            </Link>

            <img className="profile-img debt-table-img" src={getCliente.urlPerfil}></img>

            <div className="debt-etc-container">
              <p className="debt-name-age">DÍVIDAS: {getCliente.nomeCompleto}, {calculaIdade(getCliente.dataNascimento)}</p>
              <p className="debt-cpf-email-numero">
                {/* <svg xmlns="http://www.w3.org/2000/svg" className="base-icon gray debt-icon" viewBox="0 0 16 16">
                  <path d="M3 14s-1 0-1-1 1-4 6-4 6 3 6 4-1 1-1 1zm5-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6" />
                </svg> */}
                <span>CPF: </span>
                {getCliente.cpf} ·
                <svg xmlns="http://www.w3.org/2000/svg" className="base-icon gray debt-icon" viewBox="0 0 16 16">
                  <path d="M.05 3.555A2 2 0 0 1 2 2h12a2 2 0 0 1 1.95 1.555L8 8.414zM0 4.697v7.104l5.803-3.558zM6.761 8.83l-6.57 4.027A2 2 0 0 0 2 14h12a2 2 0 0 0 1.808-1.144l-6.57-4.027L8 9.586zm3.436-.586L16 11.801V4.697z" />
                </svg>
                {getCliente.email ? getCliente.email : "Sem email cadastrado"} ·
                <svg xmlns="http://www.w3.org/2000/svg" className="base-icon gray debt-icon" viewBox="0 0 16 16">
                  <path fill-rule="evenodd" d="M1.885.511a1.745 1.745 0 0 1 2.61.163L6.29 2.98c.329.423.445.974.315 1.494l-.547 2.19a.68.68 0 0 0 .178.643l2.457 2.457a.68.68 0 0 0 .644.178l2.189-.547a1.75 1.75 0 0 1 1.494.315l2.306 1.794c.829.645.905 1.87.163 2.611l-1.034 1.034c-.74.74-1.846 1.065-2.877.702a18.6 18.6 0 0 1-7.01-4.42 18.6 18.6 0 0 1-4.42-7.009c-.362-1.03-.037-2.137.703-2.877z" />
                </svg>
                {getCliente.numeroCelular}</p>
            </div>
          </div>

          <div className="flex-row jcc small-gap">
            <button className="small-button debt" onClick={() => setEditCliente(getCliente.id)} key={`edit-${getCliente.id}`}>
              <svg xmlns="http://www.w3.org/2000/svg" className="base-icon" viewBox="0 0 16 16">
                <path d="m13.498.795.149-.149a1.207 1.207 0 1 1 1.707 1.708l-.149.148a1.5 1.5 0 0 1-.059 2.059L4.854 14.854a.5.5 0 0 1-.233.131l-4 1a.5.5 0 0 1-.606-.606l1-4a.5.5 0 0 1 .131-.232l9.642-9.642a.5.5 0 0 0-.642.056L6.854 4.854a.5.5 0 1 1-.708-.708L9.44.854A1.5 1.5 0 0 1 11.5.796a1.5 1.5 0 0 1 1.998-.001" />
              </svg>
            </button>
            <button className="small-button debt" onClick={() => setDeleteCliente(getCliente.id)} key={`delete-${getCliente.id}`}>
              <svg xmlns="http://www.w3.org/2000/svg" className="base-icon" viewBox="0 0 16 16">
                <path d="M2.5 1a1 1 0 0 0-1 1v1a1 1 0 0 0 1 1H3v9a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V4h.5a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H10a1 1 0 0 0-1-1H7a1 1 0 0 0-1 1zm3 4a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 .5-.5M8 5a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7A.5.5 0 0 1 8 5m3 .5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 1 0" />
              </svg>
            </button>
          </div>

        </header>

        <table>
          <thead>
            <tr>
              <th className="ti-text">Descrição</th>
              <th>Valor</th>
              <th>Criação</th>
              <th>Pagamento</th>
              <th>Situação</th>
              <th className="clickable-column">
                <svg xmlns="http://www.w3.org/2000/svg" className="base-icon" viewBox="0 0 16 16">
                  <path d="M9.293 0H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V4.707A1 1 0 0 0 13.707 4L10 .293A1 1 0 0 0 9.293 0M9.5 3.5v-2l3 3h-2a1 1 0 0 1-1-1m-1 4v3.793l1.146-1.147a.5.5 0 0 1 .708.708l-2 2a.5.5 0 0 1-.708 0l-2-2a.5.5 0 0 1 .708-.708L7.5 11.293V7.5a.5.5 0 0 1 1 0" />
                </svg>
              </th>
              <th className="clickable-column">
                <svg xmlns="http://www.w3.org/2000/svg" className="base-icon" viewBox="0 0 16 16">
                  <path d="m13.498.795.149-.149a1.207 1.207 0 1 1 1.707 1.708l-.149.148a1.5 1.5 0 0 1-.059 2.059L4.854 14.854a.5.5 0 0 1-.233.131l-4 1a.5.5 0 0 1-.606-.606l1-4a.5.5 0 0 1 .131-.232l9.642-9.642a.5.5 0 0 0-.642.056L6.854 4.854a.5.5 0 1 1-.708-.708L9.44.854A1.5 1.5 0 0 1 11.5.796a1.5 1.5 0 0 1 1.998-.001" />
                </svg>
              </th>
              <th className="clickable-column">
                <svg xmlns="http://www.w3.org/2000/svg" className="base-icon" viewBox="0 0 16 16">
                  <path d="M2.5 1a1 1 0 0 0-1 1v1a1 1 0 0 0 1 1H3v9a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V4h.5a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H10a1 1 0 0 0-1-1H7a1 1 0 0 0-1 1zm3 4a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 .5-.5M8 5a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7A.5.5 0 0 1 8 5m3 .5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 1 0" />
                </svg>
              </th>
            </tr>
          </thead>
          <tbody>
            {getDividas.map(divida =>
              <tr key={divida.idDivida}>
                <td className="ti-text">{divida.descricao.length > 80 ? `${(divida.descricao).substring(0, 80)}[...]` : divida.descricao}</td>
                <td>R${(divida.valor).toFixed(2)}</td>
                <td>{formataData(divida.dataCriacao, false)}</td>
                <td>{divida.dataPagamento == null ? "--/--/----" : formataData(divida.dataPagamento, false)}</td>
                <td>{divida.situacao ? "Quitada" : "Em aberto"}</td>
                <td className={"clickable clickable-column " + (!divida.situacao ? "" : "debt-paid")} onClick={divida.situacao ? undefined : () => getDividaApi(divida.idDivida, "BAIXA")} key={`baixa-${divida.idDivida}`}
                >
                  <svg xmlns="http://www.w3.org/2000/svg" className="base-icon black" viewBox="0 0 16 16">
                    <path d="M9.293 0H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V4.707A1 1 0 0 0 13.707 4L10 .293A1 1 0 0 0 9.293 0M9.5 3.5v-2l3 3h-2a1 1 0 0 1-1-1m-1 4v3.793l1.146-1.147a.5.5 0 0 1 .708.708l-2 2a.5.5 0 0 1-.708 0l-2-2a.5.5 0 0 1 .708-.708L7.5 11.293V7.5a.5.5 0 0 1 1 0" />
                  </svg>
                </td>
                <td className={"clickable clickable-column " + ((!divida.situacao) ? "" : "debt-paid")} onClick={divida.situacao ? undefined : () => getDividaApi(divida.idDivida, "EDIT")} key={`edit-${divida.idDivida}`}>
                  <svg xmlns="http://www.w3.org/2000/svg" className="base-icon black" viewBox="0 0 16 16">
                    <path d="m13.498.795.149-.149a1.207 1.207 0 1 1 1.707 1.708l-.149.148a1.5 1.5 0 0 1-.059 2.059L4.854 14.854a.5.5 0 0 1-.233.131l-4 1a.5.5 0 0 1-.606-.606l1-4a.5.5 0 0 1 .131-.232l9.642-9.642a.5.5 0 0 0-.642.056L6.854 4.854a.5.5 0 1 1-.708-.708L9.44.854A1.5 1.5 0 0 1 11.5.796a1.5 1.5 0 0 1 1.998-.001" />
                  </svg>
                </td>
                <td className={"clickable clickable-column"} onClick={() => getDividaApi(divida.idDivida, "DELETE")} key={`delete-${divida.idDivida}`}>
                  <svg xmlns="http://www.w3.org/2000/svg" className="base-icon black" viewBox="0 0 16 16">
                    <path d="M2.5 1a1 1 0 0 0-1 1v1a1 1 0 0 0 1 1H3v9a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V4h.5a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H10a1 1 0 0 0-1-1H7a1 1 0 0 0-1 1zm3 4a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 .5-.5M8 5a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7A.5.5 0 0 1 8 5m3 .5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 1 0" />
                  </svg>
                </td>
              </tr>
            )}
          </tbody>
        </table>

        {getDividas.filter(divida => !divida.situacao).length === 0
          ? <ClienteSemDividas />
          : <div className="flex-row debt-resumo">
            <span>Valor total de dívidas em aberto: R${(getCliente.somatorioDividasEmAberto)}</span>
          </div>}

        <footer className="debt-footer">
          <Creditos></Creditos>
          <div className="flex-row">
            <BotaoNovaDivida></BotaoNovaDivida>
            <div className="page-container">
              <button className="page-button" onClick={() => setPage(getPage == 1 ? 1 : getPage - 1)}>&#60;</button>
              <span className="current-page">{getPage}</span>
              <button className="page-button" onClick={() => setPage(getPage + 1 > getTotalPaginas ? getPage : getPage + 1)}>&#62;</button>
            </div>
          </div>
        </footer>

      </main>
      {getDeleteCliente && <ConfirmacaoExclusaoCliente cliente={getCliente} onClose={() => setDeleteCliente(undefined)} debt={true} />}
      {getEditCliente && <FormCliente cliente={getCliente} onClose={() => setEditCliente(undefined)} contexto={"Editar "} />}
      {getDeleteDivida && <ConfirmacaoExclusaoDivida divida={getDeleteDivida} onClose={() => setDeleteDivida(undefined)} />}
      {getBaixaDivida && <ConfirmacaoBaixaDivida divida={getBaixaDivida} onClose={() => setBaixaDivida(undefined)} />}
      {getEditDivida && <FormDivida divida={getEditDivida} onClose={() => setEditDivida(undefined)} contexto={"Editar "} />}
    </>
  )
}