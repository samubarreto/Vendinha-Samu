import CardCliente from "./CardCliente.jsx"
import SearchBarClientes from "./SearchBarClientes.jsx"
import FooterClientes from "./FooterClientes.jsx"

import { listarClientes, getClienteById, deletarCliente, postPutCliente, uparImagemPerfil } from "../services/clienteApi.js"
import { listarDividas, deletarDivida, postPutDivida } from "../services/dividaApi.js"
import { useEffect, useState } from "react"

export default function GridCardsClientes() {
  const [cards, setCards] = useState([]);
  const [busca, setBusca] = useState("");
  const [page, setPage] = useState(0);

  useEffect(() => {
    listarClientes(busca, 0, 10)
      .then(resposta => {
        if (resposta.status == 200) {
          resposta.json()
            .then(clientes => {
              setCards(clientes);
            })
        }
      });
  }, [busca, page]);
  return (
    <>
      <SearchBarClientes value={busca} onChange={(event) => { setBusca(event.target.value) }}></SearchBarClientes>

      <main className="clients-grid">
        {cards.map(cliente => {
          return <CardCliente key={cliente.id_cliente} cliente={cliente}></CardCliente>
        })}
      </main>

      <FooterClientes></FooterClientes>
    </>
  )
}