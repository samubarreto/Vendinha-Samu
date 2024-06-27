import BotaoNovaDivida from "./BotaoNovaDivida.jsx"
import Creditos from "../general/Creditos.jsx"
import { Link, useRouter } from "simple-react-routing"

export default function TabelaDividasDeUmCliente() {

  const { pathParams } = useRouter();
  // const idClientePath = pathParams["id"];

  return (
    <>

      <main className="debt-table-container">

        <header className="debt-table-header">
          <div className="flex-row">
            <Link to="/clientes" className="back-clients-link">
              <svg xmlns="http://www.w3.org/2000/svg" className="base-icon black large-icon" viewBox="0 0 16 16">
                <path d="m3.86 8.753 5.482 4.796c.646.566 1.658.106 1.658-.753V3.204a1 1 0 0 0-1.659-.753l-5.48 4.796a1 1 0 0 0 0 1.506z" />
              </svg>
            </Link>

            <img className="profile-img debt-table-img"></img>

            <div className="debt-etc-container">
              <p className="debt-name-age">DÍVIDAS: MICHAEL JACKSON OLIVEIRA MORAES CARDOSO, 31</p>
              <p className="debt-cpf-email">000.000.000-00 · micael.jack@gmail.com</p>
            </div>
          </div>

          <div className="flex-row jcc small-gap">
            <button className="small-button debt">
              <svg xmlns="http://www.w3.org/2000/svg" className="base-icon" viewBox="0 0 16 16">
                <path d="m13.498.795.149-.149a1.207 1.207 0 1 1 1.707 1.708l-.149.148a1.5 1.5 0 0 1-.059 2.059L4.854 14.854a.5.5 0 0 1-.233.131l-4 1a.5.5 0 0 1-.606-.606l1-4a.5.5 0 0 1 .131-.232l9.642-9.642a.5.5 0 0 0-.642.056L6.854 4.854a.5.5 0 1 1-.708-.708L9.44.854A1.5 1.5 0 0 1 11.5.796a1.5 1.5 0 0 1 1.998-.001" />
              </svg>
            </button>
            <button className="small-button debt">
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
            <tr>
              <td className="ti-text">Jaqueta corta-vento masculina</td>
              <td>R$60.00</td>
              <td>26/06/2024</td>
              <td>--/--/----</td>
              <td>Em aberto</td>
              <td className="clickable clickable-column">
                <svg xmlns="http://www.w3.org/2000/svg" className="base-icon black" viewBox="0 0 16 16">
                  <path d="M9.293 0H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V4.707A1 1 0 0 0 13.707 4L10 .293A1 1 0 0 0 9.293 0M9.5 3.5v-2l3 3h-2a1 1 0 0 1-1-1m-1 4v3.793l1.146-1.147a.5.5 0 0 1 .708.708l-2 2a.5.5 0 0 1-.708 0l-2-2a.5.5 0 0 1 .708-.708L7.5 11.293V7.5a.5.5 0 0 1 1 0" />
                </svg>
              </td>
              <td className="clickable clickable-column">
                <svg xmlns="http://www.w3.org/2000/svg" className="base-icon black" viewBox="0 0 16 16">
                  <path d="m13.498.795.149-.149a1.207 1.207 0 1 1 1.707 1.708l-.149.148a1.5 1.5 0 0 1-.059 2.059L4.854 14.854a.5.5 0 0 1-.233.131l-4 1a.5.5 0 0 1-.606-.606l1-4a.5.5 0 0 1 .131-.232l9.642-9.642a.5.5 0 0 0-.642.056L6.854 4.854a.5.5 0 1 1-.708-.708L9.44.854A1.5 1.5 0 0 1 11.5.796a1.5 1.5 0 0 1 1.998-.001" />
                </svg>
              </td>
              <td className="clickable clickable-column">
                <svg xmlns="http://www.w3.org/2000/svg" className="base-icon black" viewBox="0 0 16 16">
                  <path d="M2.5 1a1 1 0 0 0-1 1v1a1 1 0 0 0 1 1H3v9a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V4h.5a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H10a1 1 0 0 0-1-1H7a1 1 0 0 0-1 1zm3 4a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 .5-.5M8 5a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7A.5.5 0 0 1 8 5m3 .5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 1 0" />
                </svg>
              </td>
            </tr>
            {/* {dividas.map(divida =>
              <tr>
                <td className="ti-text">{divida.descricao}</td>
                <td>{divida.valor}</td>
                <td>{divida.dataCriacao}</td>
                <td>{divida.dataPagamento}</td>
                <td>{divida.situacao}</td>
                <td className="clickable">
                  <svg xmlns="http://www.w3.org/2000/svg" className="base-icon black" viewBox="0 0 16 16">
                    <path d="M9.293 0H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V4.707A1 1 0 0 0 13.707 4L10 .293A1 1 0 0 0 9.293 0M9.5 3.5v-2l3 3h-2a1 1 0 0 1-1-1m-1 4v3.793l1.146-1.147a.5.5 0 0 1 .708.708l-2 2a.5.5 0 0 1-.708 0l-2-2a.5.5 0 0 1 .708-.708L7.5 11.293V7.5a.5.5 0 0 1 1 0" />
                  </svg>
                </td>
                <td>
                  <svg xmlns="http://www.w3.org/2000/svg" className="base-icon black" viewBox="0 0 16 16">
                    <path d="m13.498.795.149-.149a1.207 1.207 0 1 1 1.707 1.708l-.149.148a1.5 1.5 0 0 1-.059 2.059L4.854 14.854a.5.5 0 0 1-.233.131l-4 1a.5.5 0 0 1-.606-.606l1-4a.5.5 0 0 1 .131-.232l9.642-9.642a.5.5 0 0 0-.642.056L6.854 4.854a.5.5 0 1 1-.708-.708L9.44.854A1.5 1.5 0 0 1 11.5.796a1.5 1.5 0 0 1 1.998-.001" />
                  </svg>
                </td>
                <td>
                  <svg xmlns="http://www.w3.org/2000/svg" className="base-icon black" viewBox="0 0 16 16">
                    <path d="M2.5 1a1 1 0 0 0-1 1v1a1 1 0 0 0 1 1H3v9a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V4h.5a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H10a1 1 0 0 0-1-1H7a1 1 0 0 0-1 1zm3 4a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 .5-.5M8 5a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7A.5.5 0 0 1 8 5m3 .5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 1 0" />
                  </svg>
                </td>
              </tr>
            )} */}
          </tbody>
        </table>

        <div className="flex-row debt-resumo">
          <span>Dívidas em aberto: 4</span>
          ·
          <span>Dívidas quitadas: 4</span>
          ·
          <span>Total de Dívidas: 8</span>
          ·
          <span>Total pago: R$60.00</span>
          ·
          <span>Total em aberto: R$60.00</span>
        </div>

        <footer className="debt-footer">
          <Creditos></Creditos>
          <div className="flex-row">
            <BotaoNovaDivida></BotaoNovaDivida>
            <div className="page-container">
              <button className="page-button">&#60;</button>
              <span className="current-page">1</span>
              <button className="page-button">&#62;</button>
            </div>
          </div>
        </footer>

      </main>

    </>
  )
}