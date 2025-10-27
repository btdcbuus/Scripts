local Logger = {};

local Date = os.date("%Y-%m-%d");
local JobId = game.JobId;
local PlaceId = game.PlaceId;
local PlaceName = cloneref(game:GetService("MarketplaceService")):GetProductInfo(PlaceId).Name;

local LogFolder = "Logger";
local LogFile = "/" .. Date .. " - " .. PlaceName .. " - " .. JobId .. ".txt";

local LogLevels = {
    ["1"] = "INFO";
    ["2"] = "WARNING";
    ["3"] = "ERROR";
}

function Logger.Clear()
    writefile(LogFolder .. LogFile, "");
end

function Logger.DeleteLogs()
    delfolder(LogFolder);
end

function Logger.Error() 
    return "3";
end

function Logger.Info()
    return "1";
end

function Logger.Log(Data, Level)
    if not isfolder(LogFolder) then
        makefolder(LogFolder);
    end

    Level = Level or 1;
    local LevelOutput = "[" .. LogLevels[tostring(Level)] .. "] ";
    local Time = os.date("%H:%M:%S");
    local Output = "[" .. Time .. "] " .. LevelOutput .. Data .. "\n";

    appendfile(LogFolder .. LogFile, Output);
end

function Logger.SetLogFile(File)
    LogFile = "/" .. File .. " - " .. Date .. " - " .. PlaceName .. " - " .. JobId .. ".txt";
    
    if not isfile(LogFolder .. LogFile) then
        writefile(LogFolder .. LogFile, "");
    end
end

function Logger.SetLogFolder(Folder)
    LogFolder = Folder;

    if not isfolder(Folder) then
        makefolder(Folder);
    end
end

function Logger.Warning() 
    return "2";
end

return Logger;