import { BrowserRouter } from 'simple-react-routing';

import TabelaDividasDeUmCliente from './dividas/TabelaDividasDeUmCliente.jsx';
import GridCardsClientes from './clientes/GridCardsClientes.jsx';
import NotFoundPage from './general/NotFoundPage.jsx'
import Layout from './general/Layout.jsx';

export default function App() {

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
            path: "cliente/:id_cliente(num)/dividas",
            component: <TabelaDividasDeUmCliente />
          },
          {
            path: "teste",
            component: <TabelaDividasDeUmCliente />
          }
        ]}>
        <Layout />
      </BrowserRouter>
    </>
  )
}