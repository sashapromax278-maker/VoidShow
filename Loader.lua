-- Loader.lua
local repo = "https://raw.githubusercontent.com/CaramanCompany/scripts/main/"

local gameId = game.PlaceId
local supportedGames = {
    [142823291] = "mm2.lua", -- Murder Mystery 2
    -- Сюда можно добавлять другие игры:
    -- [PLACE_ID] = "another_game.lua",
}

local scriptFile = supportedGames[gameId]

if scriptFile then
    local success, result = pcall(function()
        return game:HttpGet(repo .. "games/" .. scriptFile)
    end)
    
    if success and result then
        local fn, err = loadstring(result)
        if fn then
            fn()
        else
            warn("Loader Error: Failed to parse script - " .. tostring(err))
        end
    else
        warn("Loader Error: Failed to download script from repository.")
    end
else
    print("Loader: This game is not supported.")
end
