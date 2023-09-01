using EventsService.Controllers;
using EventsService.Models;
using EventsService.Services.Authorization;
using EventsService.Services.Details;
using EventsService.Services.Email;
using EventsService.Services.Events;
using EventsService.Services.Notification;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
builder.Services.AddSignalR();


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

builder.Services.AddTransient<IDetailsService, DetailsService>();
builder.Services.AddTransient<IEventsGatherService, EventsGatherService>();
builder.Services.AddTransient<INotificationService, NotificationService>();
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

app.UseAuthorization();
app.UseMiddleware<TokenBasedAuthorizationManager>();

//app.MapControllers();

app.UseEndpoints(endpoints =>
{
    app.MapControllers();
    endpoints.MapHub<EventHub>("/EventHub");
});

app.Run();
