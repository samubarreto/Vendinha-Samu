import CardCliente from "./CardCliente"
import BotaoNovoCliente from "./BotaoNovoCliente"
import Creditos from "../general/Creditos"
import NenhumClienteEncontrado from "./NenhumClienteEncontrado.jsx"

import { useNavigation } from 'simple-react-routing';
import { listarClientes } from "../services/clienteApi.js"
import { useEffect, useState } from "react"

export default function GridCardsClientes() {

  const { navigateTo } = useNavigation();
  const [getCards, setCards] = useState([]);
  const [getBusca, setBusca] = useState("");
  const [getPage, setPage] = useState(1);
  const [getTotalPaginas, setTotalPaginas] = useState(undefined);

  useEffect(() => {
    if (window.location.pathname === '/') {
      navigateTo(null, '/clientes');
    }
  }, [navigateTo]);

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
            })
        }
      });
  }, [getBusca, getPage]);

  return (
    <>
      <input type="search" placeholder="Pesquise pelo Nome do Cliente 🔍" value={getBusca} onChange={(event) => {
        setBusca(event.target.value);
        setPage(1);
      }} />

      <main className="clients-grid" style={{
        gridTemplateColumns: getCards.length === 1 || getCards.length === 0
          ? '1fr'
          : getCards.length === 8
            ? 'repeat(4, 1fr)'
            : getCards.length === 6
              ? 'repeat(3, 1fr)'
              : getCards.length === 4
                ? 'repeat(2, 1fr)'
                : getCards.length === 2
                  ? 'repeat(2, 1fr)'
                  : 'repeat(5, 1fr)',
        gridTemplateRows: getCards.length === 0 || getCards.length === 1 || getCards.length === 2
          ? '1fr'
          : 'repeat(2, 1fr)'
      }}>
        {getCards.length === 0 ? (<NenhumClienteEncontrado />) : (getCards.map(cliente => (<CardCliente key={cliente.id} cliente={cliente} />)))}
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
      <p className="footer-advice">Dê um git pull -ff sempre que possível para usar a versão mais atualizada da aplicação 🔄</p>
    </>
  )
}