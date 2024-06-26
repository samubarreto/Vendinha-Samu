export const URL_API = "https://localhost:7258";

export function calculaIdade(dataSemTratamento) {
  let dataAtual = new Date();
  let dataFormatada = new Date(dataSemTratamento);

  let diaNascimento = dataFormatada.getDate();
  let mesNascimento = dataFormatada.getMonth();
  let anoNascimento = dataFormatada.getFullYear();

  let idade = dataAtual.getFullYear() - anoNascimento;

  if (dataAtual.getMonth() < mesNascimento ||
    (dataAtual.getMonth() == mesNascimento && dataAtual.getDate() < diaNascimento)) {
    idade--;
  }

  return idade;
}

export function formataData(dataSemTratamento) {
  const data = new Date(dataSemTratamento);
  const dia = String(data.getDate()).padStart(2, '0');
  const mes = String(data.getMonth() + 1).padStart(2, '0');
  const ano = data.getFullYear();
  return `${ano}-${mes}-${dia}`;
}