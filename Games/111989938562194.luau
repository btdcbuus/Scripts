local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local Logger = loadstring(game:HttpGet("https://raw.githubusercontent.com/btdcbuus/Scripts/refs/heads/main/Misc/Logger.luau"))();
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()

Logger.EnablePrint(true);
Logger.SetLogFolder("Brainrot Evolution");
Logger.Log("Script Started...\n", Logger.Info());

local Players = cloneref(game:GetService("Players"));
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"));
local Workspace = cloneref(game:GetService("Workspace"));

Logger.Log("Script Exited...");
