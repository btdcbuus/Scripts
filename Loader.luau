repeat 
    task.wait(1);
until game:IsLoaded()

local PlaceId = tostring(game.PlaceId);
local Logger = loadstring(game:HttpGet("https://raw.githubusercontent.com/btdcbuus/Scripts/refs/heads/main/Logger.luau"))();

Logger.SetLogFolder("Loader");

local Supported =  {
    [""] = "";
}

if (Supported[PlaceId]) then
    loadstring(Supported[PlaceId])();
else
    Logger.Log(Logger.Error(), "Game is not Supported!");
end