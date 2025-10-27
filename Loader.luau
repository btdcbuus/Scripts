repeat 
    task.wait(1);
until game:IsLoaded()

local PlaceId = tostring(game.PlaceId);
local Logger = loadstring(game:HttpGet(""))();

Logger.SetLogFolder("Loader");
Logger.SetLogFile("Loader");

local Supported =  {
    [""] = "";
}

if (Supported[PlaceId]) then
    loadstring(Supported[PlaceId])();
else

end