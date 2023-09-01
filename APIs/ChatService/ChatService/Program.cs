using ChatService.Controllers;
using ChatService.Models;
using ChatService.Services.Authorization;
using ChatService.Services.Chat;
using ChatService.Services.Details;
using ChatService.Services.Notification;
using ChatService.Services.User;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
builder.Services.AddSignalR();

//var dbHost = Environment.GetEnvironmentVariable("DB_HOST");
//var dbName = Environment.GetEnvironmentVariable("DB_NAME");
//var dbPassword = Environment.GetEnvironmentVariable("DB_SA_PASSWORD");
//var connectionString = $"Data Source={dbHost};Initial Catalog={dbName};User ID=sa;Password={dbPassword}";

//builder.Services.AddDbContext<SportNetContext>(options => options.UseSqlServer(connectionString));
//Add dbContext:
builder.Services.AddDbContext<SportNetContext>(options => options.UseSqlServer(builder.Configuration.GetConnectionString("dbconn")));


// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddTransient<IDetailsService, DetailsService>();
builder.Services.AddTransient<IMessageService, MessageService>();
builder.Services.AddTransient<INotificationService, NotificationService>();
builder.Services.AddTransient<IUserService, UserService>();
builder.Services.AddScoped<ContextUser>();
builder.Services.AddScoped<ChatHub>();

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

app.UseAuthorization();
app.UseMiddleware<TokenBasedAuthorizationManager>();

app.UseEndpoints(endpoints =>
{
    endpoints.MapControllers();
    endpoints.MapHub<ChatHub>("/ChatHub");
});

//app.MapControllers();

app.Run();
