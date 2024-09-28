local MyLib = {}

-- Helper function to loop through players and run a callback on each one
local function processPlayers(players, callback)
    for _, player in pairs(players) do
        callback(player)
    end
end

-- 1. Get all players except the local player and retrieve their avatars and other things inside them
function MyLib.GetOtherPlayers(localPlayer)
    local players = game:GetService("Players"):GetPlayers()
    processPlayers(players, function(player)
        if player ~= localPlayer then
            print("Player:", player.Name)
            if player.Character then
                print("Avatar:", player.Character.Name)
                -- You can access other things inside the player here
            end
        end
    end)
end

-- 2. Get all players including the local player and retrieve their avatars and other things inside them
function MyLib.GetAllPlayers()
    local players = game:GetService("Players"):GetPlayers()
    processPlayers(players, function(player)
        print("Player:", player.Name)
        if player.Character then
            print("Avatar:", player.Character.Name)
            -- You can access other things inside the player here
        end
    end)
end

-- 3. Change all children of `game` to their class names
function MyLib.RenameGameChildrenToClassName()
    local gameChildren = game:GetChildren()
    for _, child in ipairs(gameChildren) do
        -- Get the class name of the child (e.g., "Workspace", "Players")
        local className = child.ClassName
        -- Change its name to the class name
        child.Name = className
    end
end

return MyLib
