import CardCliente from "./CardCliente.jsx"
import SearchBarClientes from "./SearchBarClientes.jsx"
import FooterClientes from "./FooterClientes.jsx"

export default function GridCardsClientes() {
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