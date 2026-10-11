local repo = "https://raw.githubusercontent.com/sashapromax278-maker/VoidShow/main/"

local gameId = game.PlaceId
local supportedGames = {
    [142823291] = "games/mm2.lua", -- Murder Mystery 2
}

local scriptPath = supportedGames[gameId]

if scriptPath then
    local url = repo .. scriptPath
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success and result and result ~= "404: Not Found" then
        local fn, err = loadstring(result)
        if fn then
            fn()
        else
            warn("VoidShow Error: Синтаксическая ошибка в скрипте - " .. tostring(err))
        end
    else
        warn("VoidShow Error: Не удалось загрузить файл по адресу: " .. url)
    end
else
    print("VoidShow: Игра не поддерживается.")
end
