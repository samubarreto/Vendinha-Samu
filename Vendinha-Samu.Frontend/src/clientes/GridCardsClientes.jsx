import CardCliente from "./CardCliente.jsx"
import SearchBarClientes from "./SearchBarClientes.jsx"
import FooterClientes from "./FooterClientes.jsx"

import { listarClientes, getClienteById, deletarCliente, postPutCliente, uparImagemPerfil } from "../services/clienteApi.js"
import { listarDividas, deletarDivida, postPutDivida } from "../services/dividaApi.js"
import { useEffect, useState } from "react"

export default function GridCardsClientes() {
  // console.log(listarClientes("", 10, 10)
  //   .then((payload) => {
  //     console.log(payload.json())
  //   }));
  return (
    <>
      <SearchBarClientes></SearchBarClientes>
      <main className="clients-grid">
        <CardCliente></CardCliente>
        <CardCliente></CardCliente>
        <CardCliente></CardCliente>
        <CardCliente></CardCliente>
        <CardCliente></CardCliente>
        <CardCliente></CardCliente>
        <CardCliente></CardCliente>
        <CardCliente></CardCliente>
        <CardCliente></CardCliente>
        <CardCliente></CardCliente>
      </main>
      <FooterClientes></FooterClientes>
    </>
  )
}