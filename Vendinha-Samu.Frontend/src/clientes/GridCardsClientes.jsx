import CardCliente from "./CardCliente"
import BotaoNovoCliente from "./BotaoNovoCliente"
import Creditos from "../general/Creditos"
import NenhumClienteEncontrado from "./NenhumClienteEncontrado.jsx"

import { listarClientes, deletarCliente, postPutCliente, uparImagemPerfil } from "../services/clienteApi.js"
import { useEffect, useState } from "react"

export default function GridCardsClientes() {
  const [getCards, setCards] = useState([]);
  const [getBusca, setBusca] = useState("");
  const [getPage, setPage] = useState(1);
  const [getTotalPaginas, setTotalPaginas] = useState();

  useEffect(() => {
    listarClientes(getBusca)
      .then(resposta => {
        if (resposta.status == 200) {
          resposta.json()
            .then(clientes => {
              setTotalPaginas(Math.ceil(clientes.length / 10))
            })
        }
      });
  }, [getBusca]);

  useEffect(() => {
    listarClientes(getBusca, getPage, 10)
      .then(resposta => {
        if (resposta.status == 200) {
          resposta.json()
            .then(clientes => {
              setCards(clientes);
              console.log(getCards.length)
            })
        }
      });
  }, [getBusca, getPage]);

  return (
    <>
      <div className="search-bar-container">
        <input type="search" placeholder="Pesquise pelo Nome do Cliente" value={getBusca} onChange={(event) => {
          setBusca(event.target.value);
          setPage(1);
        }} />
        <svg xmlns="http://www.w3.org/2000/svg" className="base-icon black" viewBox="0 0 16 16">
          <path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001q.044.06.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1 1 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0" />
        </svg>
      </div>

      <main className="clients-grid" style={{
        gridTemplateColumns: getCards.length === 1 || getCards.length === 0
          ? '1fr'
          : getCards.length === 8
            ? 'repeat(4, 1fr)'
            : getCards.length === 4
              ? 'repeat(2, 1fr)'
              : getCards.length === 2
                ? 'repeat(2, 1fr)'
                : 'repeat(5, 1fr)',
        gridTemplateRows: getCards.length === 0 || getCards.length === 1 || getCards.length === 2
          ? '1fr'
          : 'repeat(2, 1fr)'
      }}>
        {getCards.length === 0 ? (<NenhumClienteEncontrado />) : (getCards.map(cliente => (<CardCliente key={cliente.id_cliente} cliente={cliente} />)))}
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