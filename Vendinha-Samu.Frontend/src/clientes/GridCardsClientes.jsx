import CardCliente from "./CardCliente.jsx"
import SearchBar from "./SearchBar.jsx"

export default function GridCardsClientes() {
  return (
    <>
      <SearchBar></SearchBar>
      <div className="clients-grid">
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
      </div>
    </>
  )
}