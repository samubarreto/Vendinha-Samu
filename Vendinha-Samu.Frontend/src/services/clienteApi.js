import { URL_API } from "./generalApi";

export function listarClientes(pesquisa, skip, pageSize) {
  var response = fetch(URL_API + "/api/clientes?pesquisa=" + pesquisa + "&" + `skip=${skip}&pageSize=${pageSize}`);
  return response;
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

export function postPutCliente(cliente) {
  var request = {
    method: cliente.id_cliente ? "PUT" : "POST",
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