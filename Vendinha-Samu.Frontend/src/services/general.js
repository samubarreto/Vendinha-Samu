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