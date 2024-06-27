import { URL_API } from "./general";
let skip;

export function listarDividas(id_cliente_divida, page = 0, pageSize = 0) {
  page <= 1 ? skip = 0 : skip = (page - 1) * pageSize;
  return fetch(`${URL_API}/api/dividas/${id_cliente_divida}?skip=${skip}&pageSize=${pageSize}`);
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