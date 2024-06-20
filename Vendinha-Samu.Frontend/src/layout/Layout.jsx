import { RenderComponent } from "simple-react-routing"
import Header1 from "./Header1"

export default function Layout() {
  return (
    <>

      <Header1></Header1>
      <RenderComponent></RenderComponent>

    </>
  )
}