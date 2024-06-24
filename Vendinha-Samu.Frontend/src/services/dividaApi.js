import { URL_API } from "./general";

export function listarDividas(id_cliente_divida) {
  var response = fetch(URL_API + "/api/dividas/" + id_cliente_divida)
  return response;
}

export function deletarDivida(id_divida) {
  var request = {
    method: "DELETE"
  }
  var response = fetch(URL_API + "/api/dividas/" + id_divida, request)
  return response;
}

export function postPutDivida(divida) {
  var request = {
    method: divida.id_divida ? "PUT" : "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify(divida)
  }
  var response = fetch(URL_API + "/api/dividas", request)
  return response;
}