local MyLib = {}

local function processObject(targetLocation, args)
    local function checkChildren(children)
        for _, child in ipairs(children) do
            if (child:IsA("RemoteEvent") or child:IsA("RemoteFunction") or 
                child:IsA("BindableEvent") or child:IsA("BindableFunction")) and 
                isDeveloperAccessible(child) then
                
                local success, result
                if child:IsA("RemoteEvent") then
                    success, result = pcall(function()
                        return child:FireServer(unpack(args))
                    end)
                elseif child:IsA("RemoteFunction") then
                    success, result = pcall(function()
                        return child:InvokeServer(unpack(args))
                    end)
                elseif child:IsA("BindableEvent") then
                    success, result = pcall(function()
                        return child:Fire(unpack(args))
                    end)
                elseif child:IsA("BindableFunction") then
                    success, result = pcall(function()
                        return child:Invoke(unpack(args))
                    end)
                end

                if success then
                    if notify then
                        game:GetService("StarterGui"):SetCore("SendNotification", {
                            Title = "BF",
                            Text = "Brute Forced " .. child.Name,
                            Duration = 5,
                        })
                    end
                    if printResults then
                        print("Success with " .. child.Name)
                    end
                else
                    if printResults then
                        print("Failed with " .. child.Name .. ": " .. tostring(result))
                    end
                end
            end
            checkChildren(child:GetChildren())
        end
    end
    
    checkChildren(targetLocation:GetChildren())
end


local function processPlayerObjects(players, localPlayer, includeLocalPlayer, callback)
    for _, player in pairs(players) do
        if includeLocalPlayer or player ~= localPlayer then
            callback(player)
        end
    end
end

function MyLib.GetPlayers(option, callback)
    local players = game:GetService("Players"):GetPlayers()
    local localPlayer = game.Players.LocalPlayer 
    if option == "all" then
        processPlayerObjects(players, localPlayer, true, callback)
    elseif option == "others" then
        processPlayerObjects(players, localPlayer, false, callback)
    else
        warn("Invalid option: Please specify 'all' or 'others'")
    end
end

function MyLib.RenameGameChildrenToClassName()
    local gameChildren = game:GetChildren()
    for _, child in ipairs(gameChildren) do
        local className = child.ClassName
        child.Name = className
    end
end

local function isDeveloperAccessible(object)
    local parent = object.Parent
    local validServices = {
        game.Workspace,
        game.Players,
        game.MaterialService,
        game.ReplicatedFirst,
        game.ReplicatedStorage,
        game.StarterGui,
        game.StarterPack,
        game.StarterPlayer,
        game.Teams
    }
    
    for _, service in ipairs(validServices) do
        if parent == service then
            return true
        end
    end
    return false
end

function MyLib.Bruteforce(notify, printResults, location, bruteforce_list, argsCount, ...)
    local args = {...}
    local successCount = 0

    local validServices = {
        game.Workspace,
        game.Players,
        game.MaterialService,
        game.ReplicatedFirst,
        game.ReplicatedStorage,
        game.StarterGui,
        game.StarterPack,
        game.StarterPlayer,
        game.Teams
    }

    -- Function to process objects for brute force
    local function processObject(object)
        -- Check if the object is one of the valid classes we want to brute force
        if (object:IsA("RemoteEvent") or object:IsA("RemoteFunction") or object:IsA("BindableEvent") or object:IsA("BindableFunction")) and isDeveloperAccessible(object) then
            local success, result

            -- Prepare arguments based on the bruteforce_list and argsCount
            local fireArgs = {}
            for i = 1, argsCount do
                local listIndex = (i - 1) % #bruteforce_list + 1 -- Loop through the bruteforce_list
                fireArgs[i] = bruteforce_list[listIndex]
            end
            
            -- Call the appropriate method based on object type
            if object:IsA("RemoteEvent") then
                success, result = pcall(function()
                    return object:FireServer(unpack(fireArgs))
                end)
            elseif object:IsA("RemoteFunction") then
                success, result = pcall(function()
                    return object:InvokeServer(unpack(fireArgs))
                end)
            elseif object:IsA("BindableEvent") then
                success, result = pcall(function()
                    return object:Fire(unpack(fireArgs))
                end)
            elseif object:IsA("BindableFunction") then
                success, result = pcall(function()
                    return object:Invoke(unpack(fireArgs))
                end)
            end

            -- Notify and log the result of the brute force attempt
            if success then
                successCount = successCount + 1
                if notify then
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "BF",
                        Text = "Brute Forced " .. object.Name,
                        Duration = 5,
                    })
                end
                if printResults then
                    print("Success with " .. object.Name)
                end
            else
                if printResults then
                    print("Failed with " .. object.Name .. ": " .. tostring(result))
                end
            end
        end
    end

    -- Recursive function to check all descendants, not just immediate children
    local function recursiveCheck(parent)
        for _, child in ipairs(parent:GetChildren()) do
            processObject(child)
            -- Recursively check the children of the current child
            recursiveCheck(child)
        end
    end

    -- If a specific location is provided, start from there; otherwise, check all valid services
    if location then
        recursiveCheck(location)
    else
        for _, service in ipairs(validServices) do
            recursiveCheck(service)
        end
    end

    return successCount
end

-- Function to get game information
function MyLib.gameinfo()
    local Players = game:GetService("Players")
    
    -- Get total players in the current server
    local playersInServer = #Players:GetPlayers()
    
    -- Placeholder for total players across all servers
    local totalPlayers = 0 -- You can implement your tracking logic here
    
    -- Get current server's age
    local serverStartTime = tick() -- Assuming the server started now
    local serverAge = tick() - serverStartTime

    -- Create a structured game information table
    local gameInfo = {
        TotalPlayers = totalPlayers,
        PlayersInServer = playersInServer,
        ServerAge = math.floor(serverAge)
    }

    return gameInfo
end

return MyLib
