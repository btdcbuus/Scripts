local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local Logger = loadstring(game:HttpGet("https://raw.githubusercontent.com/btdcbuus/Scripts/refs/heads/main/Misc/Logger.luau"))();
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()

Logger.EnablePrint(true);
Logger.SetLogFolder("Restaurant Tycoon 3");
Logger.Log("Script Started...\n", Logger.Info());

local Players = cloneref(game:GetService("Players"));
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"));
local Workspace = cloneref(game:GetService("Workspace"));
local LocalPlayer = Players.LocalPlayer;

local Window = Library:CreateWindow{
    Title = "nigel.wtf",
    SubTitle = "Restaurant Tycoon 3",
    TabWidth = 160,
    Size = UDim2.fromOffset(830, 525),
    Resize = true,
    MinSize = Vector2.new(470, 380),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
};

local Tabs = {
    Main = Window:CreateTab{
        Title = "Main",
        Icon = "utensils"
    },
    Settings = Window:CreateTab{
        Title = "Settings",
        Icon = "settings"
    }
};

local Options = Library.Options;

local Config = {
    AutoSeat = false;
    AutoTakeOrders = false;
    AutoServe = false;
    AutoCollectBills = false;
    AutoCollectDishes = false;
    AutoFarmAll = false;
    ActionDelay = 1;
    CurrentStatus = "Idle";
};

local PlayerTycoon = nil;
local StatusParagraph = nil;

local function UpdateStatus(status)
    Config.CurrentStatus = status;
    if StatusParagraph then
        StatusParagraph:SetValue(status);
    end;
    Logger.Log(status, Logger.Info());
end;

local function FindPlayerTycoon()
    local Tycoons = Workspace:WaitForChild("Tycoons");
    for _, tycoon in pairs(Tycoons:GetChildren()) do
        if tycoon.Name == "Tycoon" then
            local playerValue = tycoon:FindFirstChild("Player");
            if playerValue and playerValue.Value == LocalPlayer then
                return tycoon;
            end;
        end;
    end;
    return nil;
end;

local function FireTaskCompleted(data)
    ReplicatedStorage.Events.Restaurant.TaskCompleted:FireServer(data);
end;

local function GetTables()
    if not PlayerTycoon then return {}; end;
    local Items = PlayerTycoon:FindFirstChild("Items");
    if not Items then return {}; end;
    local Surface = Items:FindFirstChild("Surface");
    if not Surface then return {}; end;
    local tables = {};
    for _, item in pairs(Surface:GetChildren()) do
        if string.sub(item.Name, 1, 1) == "T" then
            table.insert(tables, item);
        end;
    end;
    return tables;
end;

local function AutoSeatLoop()
    while task.wait(Config.ActionDelay) do
        if not Config.AutoSeat and not Config.AutoFarmAll then continue; end;

        PlayerTycoon = FindPlayerTycoon();
        if not PlayerTycoon then continue; end;

        local ClientCustomers = PlayerTycoon:FindFirstChild("ClientCustomers");
        if not ClientCustomers then continue; end;

        local tables = GetTables();
        local tableIndex = 1;
        local groupsSeated = 0;

        for _, group in pairs(ClientCustomers:GetChildren()) do
            if group:IsA("Folder") and tableIndex <= #tables then
                local groupId = group.Name;
                local hasCustomers = #group:GetChildren() > 0;

                if hasCustomers then
                    pcall(function()
                        local tableObj = tables[tableIndex];
                        FireTaskCompleted({
                            Name = "SendToTable";
                            GroupId = groupId;
                            FurnitureModel = tableObj;
                            Tycoon = PlayerTycoon;
                        });
                        groupsSeated = groupsSeated + 1;
                        tableIndex = tableIndex + 1;
                        Logger.Log("Seated Group " .. groupId .. " at table " .. tableObj.Name, Logger.Info());
                        task.wait(0.2);
                    end);
                end;
            end;
        end;

        if groupsSeated > 0 then
            UpdateStatus("Seated " .. groupsSeated .. " groups");
        else
            UpdateStatus("Idle - No groups to seat");
        end;
    end;
end;

local function AutoTakeOrdersLoop()
    while task.wait(Config.ActionDelay) do
        if not Config.AutoTakeOrders and not Config.AutoFarmAll then continue; end;

        PlayerTycoon = FindPlayerTycoon();
        if not PlayerTycoon then continue; end;

        local ClientCustomers = PlayerTycoon:FindFirstChild("ClientCustomers");
        if not ClientCustomers then
            UpdateStatus("No ClientCustomers folder found");
            continue;
        end;

        local customerCount = #ClientCustomers:GetChildren();
        if customerCount == 0 then
            UpdateStatus("No customers in restaurant");
            continue;
        end;

        local ordersTaken = 0;
        for _, group in pairs(ClientCustomers:GetChildren()) do
            if group:IsA("Folder") then
                local groupId = group.Name;
                for _, customer in pairs(group:GetChildren()) do
                    pcall(function()
                        local customerId = customer.Name;
                        FireTaskCompleted({
                            Name = "TakeOrder";
                            GroupId = groupId;
                            CustomerId = customerId;
                            Tycoon = PlayerTycoon;
                        });
                        ordersTaken = ordersTaken + 1;
                        Logger.Log("Took order for Group " .. groupId .. " Customer " .. customerId, Logger.Info());
                        task.wait(0.1);
                    end);
                end;
            end;
        end;

        UpdateStatus("Found " .. customerCount .. " customers, took " .. ordersTaken .. " orders");
    end;
end;

local function AutoServeLoop()
    while task.wait(Config.ActionDelay) do
        if not Config.AutoServe and not Config.AutoFarmAll then continue; end;

        PlayerTycoon = FindPlayerTycoon();
        if not PlayerTycoon then continue; end;

        local Objects = PlayerTycoon:FindFirstChild("Objects");
        if not Objects then continue; end;

        local Food = Objects:FindFirstChild("Food");
        if not Food then continue; end;

        local ClientCustomers = PlayerTycoon:FindFirstChild("ClientCustomers");
        if not ClientCustomers then continue; end;

        local foodServed = 0;
        local foodItems = Food:GetChildren();
        local foodIndex = 1;

        for _, group in pairs(ClientCustomers:GetChildren()) do
            if group:IsA("Folder") then
                local groupId = group.Name;
                for _, customer in pairs(group:GetChildren()) do
                    if foodIndex <= #foodItems then
                        local foodItem = foodItems[foodIndex];
                        pcall(function()
                            local customerId = customer.Name;
                            FireTaskCompleted({
                                Name = "Serve";
                                FoodModel = foodItem;
                                GroupId = groupId;
                                CustomerId = customerId;
                                Tycoon = PlayerTycoon;
                            });
                            foodServed = foodServed + 1;
                            foodIndex = foodIndex + 1;
                            Logger.Log("Served food " .. foodItem.Name .. " to Group " .. groupId .. " Customer " .. customerId, Logger.Info());
                            task.wait(0.15);
                        end);
                    end;
                end;
            end;
        end;

        if foodServed > 0 then
            UpdateStatus("Served " .. foodServed .. " dishes");
        else
            UpdateStatus("Idle - No food to serve");
        end;
    end;
end;

local function AutoCollectBillsLoop()
    while task.wait(Config.ActionDelay) do
        if not Config.AutoCollectBills and not Config.AutoFarmAll then continue; end;

        PlayerTycoon = FindPlayerTycoon();
        if not PlayerTycoon then continue; end;

        local tables = GetTables();
        for _, tableObj in ipairs(tables) do
            pcall(function()
                FireTaskCompleted({
                    Name = "CollectBill";
                    FurnitureModel = tableObj;
                    Tycoon = PlayerTycoon;
                });
            end);
            task.wait(0.05);
        end;
    end;
end;

local function AutoCollectDishesLoop()
    while task.wait(Config.ActionDelay) do
        if not Config.AutoCollectDishes and not Config.AutoFarmAll then continue; end;

        PlayerTycoon = FindPlayerTycoon();
        if not PlayerTycoon then continue; end;

        local tables = GetTables();
        for _, tableObj in ipairs(tables) do
            pcall(function()
                FireTaskCompleted({
                    Name = "CollectDishes";
                    FurnitureModel = tableObj;
                    Tycoon = PlayerTycoon;
                });
            end);
            task.wait(0.05);
        end;
    end;
end;

StatusParagraph = Tabs.Main:CreateParagraph("StatusParagraph", {
    Title = "Status";
    Content = Config.CurrentStatus;
});

local AutoFarmAllToggle = Tabs.Main:CreateToggle("AutoFarmAll", {
    Title = "Auto Farm All";
    Description = "Enable all automation features";
    Default = false;
});

AutoFarmAllToggle:OnChanged(function()
    Config.AutoFarmAll = Options.AutoFarmAll.Value;
    Logger.Log("Auto Farm All: " .. tostring(Config.AutoFarmAll), Logger.Info());
end);

Tabs.Main:CreateParagraph("CustomerSection", {
    Title = "Customer Management";
    Content = "Seating, ordering, and serving automation";
});

local AutoSeatToggle = Tabs.Main:CreateToggle("AutoSeat", {
    Title = "Auto Seat Customers";
    Description = "Automatically seat waiting groups at tables";
    Default = false;
});

AutoSeatToggle:OnChanged(function()
    Config.AutoSeat = Options.AutoSeat.Value;
    Logger.Log("Auto Seat: " .. tostring(Config.AutoSeat), Logger.Info());
end);

local AutoTakeOrdersToggle = Tabs.Main:CreateToggle("AutoTakeOrders", {
    Title = "Auto Take Orders";
    Description = "Automatically take customer orders";
    Default = false;
});

AutoTakeOrdersToggle:OnChanged(function()
    Config.AutoTakeOrders = Options.AutoTakeOrders.Value;
    Logger.Log("Auto Take Orders: " .. tostring(Config.AutoTakeOrders), Logger.Info());
end);

local AutoServeToggle = Tabs.Main:CreateToggle("AutoServe", {
    Title = "Auto Serve Food";
    Description = "Automatically serve completed food";
    Default = false;
});

AutoServeToggle:OnChanged(function()
    Config.AutoServe = Options.AutoServe.Value;
    Logger.Log("Auto Serve: " .. tostring(Config.AutoServe), Logger.Info());
end);

Tabs.Main:CreateParagraph("CleanupSection", {
    Title = "Cleanup";
    Content = "Money and dish collection";
});

local AutoCollectBillsToggle = Tabs.Main:CreateToggle("AutoCollectBills", {
    Title = "Auto Collect Bills";
    Description = "Automatically collect money from tables";
    Default = false;
});

AutoCollectBillsToggle:OnChanged(function()
    Config.AutoCollectBills = Options.AutoCollectBills.Value;
    Logger.Log("Auto Collect Bills: " .. tostring(Config.AutoCollectBills), Logger.Info());
end);

local AutoCollectDishesToggle = Tabs.Main:CreateToggle("AutoCollectDishes", {
    Title = "Auto Collect Dishes";
    Description = "Automatically clean dirty dishes";
    Default = false;
});

AutoCollectDishesToggle:OnChanged(function()
    Config.AutoCollectDishes = Options.AutoCollectDishes.Value;
    Logger.Log("Auto Collect Dishes: " .. tostring(Config.AutoCollectDishes), Logger.Info());
end);

local ActionDelaySlider = Tabs.Main:CreateSlider("ActionDelay", {
    Title = "Action Delay";
    Description = "Delay between automation actions (seconds)";
    Default = 1;
    Min = 0;
    Max = 5;
    Rounding = 1;
});

ActionDelaySlider:OnChanged(function(value)
    Config.ActionDelay = value;
    Logger.Log("Action Delay: " .. tostring(value) .. "s", Logger.Info());
end);

SaveManager:SetLibrary(Library);
InterfaceManager:SetLibrary(Library);
SaveManager:IgnoreThemeSettings();
SaveManager:SetIgnoreIndexes{};
InterfaceManager:SetFolder("nigel.wtf");
SaveManager:SetFolder("nigel.wtf/RestaurantTycoon3");
InterfaceManager:BuildInterfaceSection(Tabs.Settings);
SaveManager:BuildConfigSection(Tabs.Settings);

Window:SelectTab(1);

Library:Notify{
    Title = "nigel.wtf";
    Content = "Restaurant Tycoon 3 script loaded!";
    Duration = 5;
};

task.spawn(AutoSeatLoop);
task.spawn(AutoTakeOrdersLoop);
task.spawn(AutoServeLoop);
task.spawn(AutoCollectBillsLoop);
task.spawn(AutoCollectDishesLoop);

SaveManager:LoadAutoloadConfig();

Logger.Log("All automation loops started", Logger.Info());
Logger.Log("Script running...", Logger.Info());
