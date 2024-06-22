import { BrowserRouter, registerPathTypeParameter } from 'simple-react-routing';
import GridCardsClientes from './clientes/GridCardsClientes.jsx';
import Layout from './general/Layout.jsx';

export default function App() {

  return (
    <>
      <BrowserRouter
        notFoundPage={<GridCardsClientes></GridCardsClientes>}
        routes={[
          {
            path: "clientes",
            component: <GridCardsClientes></GridCardsClientes>
          },
        ]}>
        <Layout></Layout>
      </BrowserRouter>
    </>
  )
}