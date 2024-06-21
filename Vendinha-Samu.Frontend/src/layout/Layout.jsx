import { RenderComponent } from "simple-react-routing"
import Header1 from "./Header"

export default function Layout() {
  return (
    <>

      <Header1></Header1>
      <RenderComponent></RenderComponent>

    </>
  )
}