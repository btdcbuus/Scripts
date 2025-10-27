repeat 
    task.wait(1);
until game:IsLoaded()

local PlaceId = tostring(game.PlaceId);
local Logger = loadstring(game:HttpGet("https://raw.githubusercontent.com/btdcbuus/Scripts/refs/heads/main/Misc/Logger.luau"))();

local Supported =  {
    ["111989938562194"] = "https://raw.githubusercontent.com/btdcbuus/Scripts/refs/heads/main/Games/111989938562194.luau";
    ["119048529960596"] = "https://raw.githubusercontent.com/btdcbuus/Scripts/refs/heads/main/Games/119048529960596.luau";
}

Logger.EnablePrint(true);
Logger.SetLogFolder("Loader");

Logger.Log("Loader Starting...", Logger.Info());
Logger.Log("Started with PlaceId: " .. PlaceId, Logger.Info());

if (Supported[PlaceId]) then
    Logger.Log("Matched PlaceId with: " .. Supported[PlaceId], Logger.Info());
    loadstring(Supported[PlaceId])();
else
    Logger.Log("Game is not Supported!", Logger.Error());
end

Logger.Log("Exiting Script...", Logger.Info());