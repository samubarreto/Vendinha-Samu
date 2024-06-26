import { URL_API } from "./general";
let skip;

export function listarClientes(pesquisa = '', page = 0, pageSize = 0) {
  page <= 1 ? skip = 0 : skip = (page - 1) * pageSize;
  return fetch(`${URL_API}/api/clientes?pesquisa=${pesquisa}&skip=${skip}&pageSize=${pageSize}`);
}

export function getClienteById(id_cliente) {
  var response = fetch(URL_API + "/api/clientes/" + id_cliente);
  return response;
}

export function deletarCliente(id_cliente) {
  var request = {
    method: "DELETE"
  }
  var response = fetch(URL_API + "/api/clientes/" + id_cliente, request)
  return response;
}

export async function putCliente(cliente) {
  const request = {
    method: "PUT",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify(cliente)
  };
  const response = await fetch(URL_API + "/api/clientes", request);
  return response;
}

export function postCliente(cliente) {
  var request = {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify(cliente)
  }
  var response = fetch(URL_API + "/api/clientes", request)
  return response;
}

export function uparImagemPerfil(form, id_cliente) {
  var formData = new FormData(form);

  var request = { method: "POST", body: formData }

  var response = fetch(URL_API + "/api/clientes/UploadProfilePic/" + id_cliente, request)
  return response;
}