import { BrowserRouter, registerPathTypeParameter } from 'simple-react-routing';

import TabelaDividasDeUmCliente from './dividas/TabelaDividasDeUmCliente.jsx';
import GridCardsClientes from './clientes/GridCardsClientes.jsx';
import NotFoundPage from './general/NotFoundPage.jsx'
import Layout from './general/Layout.jsx';

registerPathTypeParameter("num", /[0-9]+/);

export default function App() {

  var setNum = (novoNum) => {
    var num = novoNum;
  }

  return (
    <>
      <BrowserRouter
        notFoundPage={<NotFoundPage />}
        routes={[
          {
            path: "",
            component: <GridCardsClientes />,
          },
          {
            path: "clientes",
            component: <GridCardsClientes />,
          },
          {
            path: "dividas/cliente/:id(num)",
            component: <TabelaDividasDeUmCliente />
          }
        ]}>
        <Layout />
      </BrowserRouter>
    </>
  )
}