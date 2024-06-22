import { RenderComponent } from "simple-react-routing"
import Header from "./Header.jsx"

export default function Layout() {
  return (
    <>

      <Header></Header>
      <RenderComponent></RenderComponent>

    </>
  )
}