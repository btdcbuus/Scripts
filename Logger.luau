local Logger = {};

local Date = os.date("%Y-%m-%d");
local Time = os.date("%H:%M:%S");
local JobId = game.JobId;
local PlaceId = game.PlaceId;
local PlaceName = cloneref(game:GetService("MarketplaceService")):GetProductInfo(PlaceId).Name;

local LogFolder = "Logger";
local LogFile = "/" .. Date .. " - " .. " - " .. Time .. PlaceName .. ".txt";
local LoggerPrint = true;

local LogLevels = {
    ["1"] = "INFO";
    ["2"] = "WARNING";
    ["3"] = "ERROR";
}

local LogPrint = {
    ["1"] = print;
    ["2"] = info;
    ["3"] = warn;
}

function Logger.Clear()
    writefile(LogFolder .. LogFile, "");
end

function Logger.DeleteLogs()
    delfolder(LogFolder);
end

function Logger.EnablePrint(Bool)
    LoggerPrint = Bool;
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
    local Output = "[" .. Time .. "] " .. LevelOutput .. Data .. "\n";

    if LoggerPrint then
        LogPrint[tostring(Level)](Output);
    end

    appendfile(LogFolder .. LogFile, Output);
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