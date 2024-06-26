import { Link } from "simple-react-routing"

export default function NotFoundPage() {
  return (
    <>

      <div className="not-found-container">
        <h1 className="not-found-h1">Página não encontrada! 🦖</h1>
        <p className="not-found-url">{window.location.protocol}//{window.location.host}{window.location.pathname}</p>
      </div>

      <Link to="/">
        <button className="not-found-button">
          &lt; Voltar ao Início
        </button>
      </Link>

    </>
  )
}