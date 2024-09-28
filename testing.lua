local MyLib = {}

-- Helper function to loop through players and apply a callback to their entire player model
local function processPlayerObjects(players, localPlayer, includeLocalPlayer, callback)
    for _, player in pairs(players) do
        if includeLocalPlayer or player ~= localPlayer then
            callback(player)
        end
    end
end

-- Combined function to get all players or just other players and apply a callback
function MyLib.GetPlayers(option, callback)
    local players = game:GetService("Players"):GetPlayers()
    local localPlayer = game.Players.LocalPlayer  -- Get the local player automatically
    
    -- Check the option to determine whether to include the local player
    if option == "all" then
        processPlayerObjects(players, localPlayer, true, callback)
    elseif option == "others" then
        processPlayerObjects(players, localPlayer, false, callback)
    else
        warn("Invalid option: Please specify 'all' or 'others'")
    end
end

-- Change all children of `game` to their class names
function MyLib.RenameGameChildrenToClassName()
    local gameChildren = game:GetChildren()
    for _, child in ipairs(gameChildren) do
        local className = child.ClassName
        child.Name = className
    end
end

-- Function to brute force bindable events, remote functions, bindable functions, and remote events
function MyLib.Bruteforce(notify, printResults, ...)
    local args = {...}
    local successCount = 0

    -- Iterate through all children of the game
    local function processObject(object)
        if object:IsA("RemoteEvent") or object:IsA("RemoteFunction") or object:IsA("BindableEvent") or object:IsA("BindableFunction") then
            local success, result

            -- Attempt to invoke the object based on its type
            if object:IsA("RemoteEvent") then
                success, result = pcall(function()
                    return object:FireServer(unpack(args))  -- Use unpack to spread the args
                end)
            elseif object:IsA("RemoteFunction") then
                success, result = pcall(function()
                    return object:Invoke(unpack(args))  -- Use unpack to spread the args
                end)
            elseif object:IsA("BindableEvent") then
                success, result = pcall(function()
                    return object:Fire(unpack(args))  -- Use unpack to spread the args
                end)
            elseif object:IsA("BindableFunction") then
                success, result = pcall(function()
                    return object:Invoke(unpack(args))  -- Use unpack to spread the args
                end)
            end

            -- Notify and print results if requested
            if success then
                successCount = successCount + 1
                if notify then
                    -- Send a notification instead of kicking the player
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "Success!",
                        Text = "Success with " .. object.Name,
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

    -- Recursive function to process all objects in the game
    local function recursiveCheck(children)
        for _, child in ipairs(children) do
            processObject(child)  -- Check the current object
            recursiveCheck(child:GetChildren())  -- Check its children
        end
    end

    -- Start checking from the game object
    recursiveCheck(game:GetChildren())

    return successCount
end

return MyLib
