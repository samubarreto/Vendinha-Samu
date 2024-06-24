import CardCliente from "./CardCliente"
import SearchBarClientes from "./SearchBarClientes"
import BotaoNovoCliente from "./BotaoNovoCliente"
import Creditos from "../general/Creditos"

import { listarClientes, getClienteById, deletarCliente, postPutCliente, uparImagemPerfil } from "../services/clienteApi.js"
import { listarDividas, deletarDivida, postPutDivida } from "../services/dividaApi.js"
import { useEffect, useState } from "react"

export default function GridCardsClientes() {
  const [getCards, setCards] = useState([]);
  const [getBusca, setBusca] = useState("");
  const [getPage, setPage] = useState(1);
  const [getTotalPaginas, setTotalPaginas] = useState();

  useEffect(() => {
    listarClientes()
      .then(resposta => {
        if (resposta.status == 200) {
          resposta.json()
            .then(clientes => {
              setTotalPaginas(Math.ceil(clientes.length / 10))
            })
        }
      });
  }, [getBusca, getPage]);

  useEffect(() => {
    listarClientes(getBusca, getPage, 10)
      .then(resposta => {
        if (resposta.status == 200) {
          resposta.json()
            .then(clientes => {
              setCards(clientes);
            })
        }
      });
  }, [getBusca, getPage]);

  return (
    <>
      <SearchBarClientes value={getBusca} onChange={(event) => { setBusca(event.target.value) }}></SearchBarClientes>

      <main className="clients-grid">
        {getCards.map(cliente => {
          return <CardCliente key={cliente.id_cliente} cliente={cliente}></CardCliente>
        })}
      </main>

      <footer>
        <Creditos></Creditos>
        <div className="flex-row">
          <BotaoNovoCliente></BotaoNovoCliente>
          <div className="page-container">
            <button className="page-button" onClick={() => setPage(getPage == 1 ? 1 : getPage - 1)}>&#60;</button>
            <span className="current-page">{getPage}</span>
            <button className="page-button" onClick={() => setPage(getPage + 1 > getTotalPaginas ? getPage : getPage + 1)}>&#62;</button>
          </div>
        </div>
      </footer>
    </>
  )
}