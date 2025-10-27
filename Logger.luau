local Logger = {};

local Date = os.date("%Y-%m-%d");
local JobId = game.JobId;
local PlaceId = game.PlaceId;
local PlaceName = game:GetService("MarketplaceService"):GetProductInfo(PlaceId).Name;

local LogFile = "/" + Date + " - " + PlaceName + " - " + JobId + ".txt";
local LogFolder = "Logger";

local LogLevels = {
    ["1"] = "INFO";
    ["2"] = "WARNING";
    ["3"] = "ERROR";
};

function Logger.Clear()
    writefile(LogFolder + LogFile, "");
end

function Logger.DeleteLogs()
    delfolder(LogFolder);
end

function Logger.Log(Data, Level)
    if not isfolder(LogFolder) then
        makefolder(LogFolder);
    end

    if not Level then
        Level = 1;
    end

    local LevelOutput = "[" + LogLevels[tostring(Level)] + "] ";
    local Time = os.date("%H:%M:%S");
    local Output = "[" + Time + "] " + LevelOutput + Data + "\n";

    appendfile(LogFolder + LogFile, Output);
end

function Logger.SetLogFile(File)
    if isfile(File) then
        writefile(LogFolder + File, "");
    end

    LogFile = "/" + File + ".txt";
    LogFile = "/"  + File + " - " + Date + " - " + PlaceName + " - " + JobId + ".txt"
end

function Logger.SetLogFolder(Folder)
    if not isfolder(Folder) then
        makefolder(Folder);
    end

    LogFolder = Folder;
end

return Logger;