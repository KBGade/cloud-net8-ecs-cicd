var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI();

app.MapGet("/health", () => Results.Ok(new { status = "ok" }));

app.MapGet("/weather", () =>
{
    var rng = new Random();
    var data = Enumerable.Range(1, 5).Select(i =>
        new { Date = DateOnly.FromDateTime(DateTime.Now.AddDays(i)), TempC = rng.Next(-5, 45) });
    return Results.Ok(data);
});

app.Run();
