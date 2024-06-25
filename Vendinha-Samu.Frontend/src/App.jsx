import { BrowserRouter, registerPathTypeParameter } from 'simple-react-routing';

import TabelaDividasDeUmCliente from './dividas/TabelaDividasDeUmCliente.jsx';
import GridCardsClientes from './clientes/GridCardsClientes.jsx';
import NotFoundPage from './general/NotFoundPage.jsx'
import Layout from './general/Layout.jsx';

registerPathTypeParameter("num", /[0-9]+/);

export default function App() {

  return (
    <>
      <BrowserRouter
        notFoundPage={<NotFoundPage />}
        routes={[
          {
            path: "",
            component: <GridCardsClientes />
          },
          {
            path: "cliente/:id_cliente(num)/dividas",
            component: <TabelaDividasDeUmCliente />
          }
        ]}>
        <Layout />
      </BrowserRouter>
    </>
  )
}