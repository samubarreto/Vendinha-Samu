import { Link } from "simple-react-routing"

export default function NotFoundPage() {
  return (
    <>

      <div className="not-found-container">
        <h2 className="not-found-h2">Página não encontrada! 🦖</h2>
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