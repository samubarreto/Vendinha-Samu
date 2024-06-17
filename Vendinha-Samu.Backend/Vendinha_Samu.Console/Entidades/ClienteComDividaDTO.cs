namespace Vendinha_Samu.Console.Entidades
{
  public class ClienteComDividaDTO
  {
    public int IdCliente { get; set; }
    public string NomeCompleto { get; set; }
    public string CPF { get; set; }
    public int Idade { get; set; }
    public string Email { get; set; }
    public decimal TotalDivida { get; set; }
  }
}
