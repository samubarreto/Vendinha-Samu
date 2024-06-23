import { BrowserRouter, registerPathTypeParameter } from 'simple-react-routing';

import TabelaDividasDeUmCliente from './dividas/TabelaDividasDeUmCliente.jsx';
import GridCardsClientes from './clientes/GridCardsClientes.jsx';
import Layout from './general/Layout.jsx';

registerPathTypeParameter("num", /[0-9]+/);

export default function App() {

  return (
    <>
      <BrowserRouter
        notFoundPage={<h2>Página não encontrada! 🦖</h2>}
        routes={[
          {
            path: "",
            component: <GridCardsClientes></GridCardsClientes>
          },
          {
            path: "cliente/:id_cliente(num)/dividas",
            component: <TabelaDividasDeUmCliente></TabelaDividasDeUmCliente>
          }
        ]}>
        <Layout></Layout>
      </BrowserRouter>
    </>
  )
}