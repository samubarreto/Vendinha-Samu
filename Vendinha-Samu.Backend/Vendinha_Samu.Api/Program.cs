using Vendinha_Samu.Console.Services;
using NHibernate;
using NHibernate.Cfg;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();

builder.Services.AddSingleton<ISessionFactory>((s) =>
{
    var config = new Configuration();
    config.Configure();
    return config.BuildSessionFactory();
});

builder.Services.AddTransient<ClienteService>();
builder.Services.AddTransient<DividaService>();
builder.Services.AddCors(b => b.AddDefaultPolicy(c => c.AllowAnyMethod().AllowAnyHeader().AllowAnyOrigin()));

var app = builder.Build();

// Configure the HTTP request pipeline.

app.UseHttpsRedirection();

app.UseCors();

app.UseAuthorization();

app.UseDeveloperExceptionPage();

app.MapControllers();

app.Run();
