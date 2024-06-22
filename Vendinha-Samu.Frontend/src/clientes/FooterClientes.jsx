import BotaoNovoCliente from "./BotaoNovoCliente.jsx"
import Creditos from "../general/Creditos.jsx"
import Paginacao from "../general/Paginacao.jsx"

export default function FooterClientes() {
  return (
    <>
      <footer>
        <Creditos></Creditos>
        <div className="flex-row">
          <BotaoNovoCliente></BotaoNovoCliente>
          <Paginacao></Paginacao>
        </div>
      </footer>
    </>
  )
}