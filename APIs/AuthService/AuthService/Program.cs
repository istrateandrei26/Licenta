using Microsoft.EntityFrameworkCore;
using AuthService.Models;
using AuthService.Services.Authorization;
using AuthService.Services.Details;
using AuthService.Services.Email;
using AuthService.Services.Identity;
using AuthService.Services.Authentication;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();

var dbHost = Environment.GetEnvironmentVariable("DB_HOST");
var dbName = Environment.GetEnvironmentVariable("DB_NAME");
var dbPassword = Environment.GetEnvironmentVariable("DB_SA_PASSWORD");
var connectionString = $"Data Source={dbHost};Initial Catalog={dbName};User ID=sa;Password={dbPassword}";

builder.Services.AddDbContext<SportNetContext>(options => options.UseSqlServer(connectionString));
//Add dbContext:
//builder.Services.AddDbContext<SportNetContext>(options => options.UseSqlServer(builder.Configuration.GetConnectionString("dbconn")));



// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddScoped<IRegisterService, RegisterService>();
builder.Services.AddScoped<ILoginService, LoginService>();
builder.Services.AddScoped<IIdentityService, IdentityService>();
builder.Services.AddScoped<IDetailsService, DetailsService>();
builder.Services.AddScoped<ContextUser>();
builder.Services.AddScoped<IEmailService, EmailService>();

builder.Services.AddHttpContextAccessor();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseRouting();

//app.UseAuthorization();
//app.UseMiddleware<TokenBasedAuthorizationManager>();

app.MapControllers();

app.Run();
