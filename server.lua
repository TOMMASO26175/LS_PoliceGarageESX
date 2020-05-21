ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterNetEvent('lspolicegarage:getcars')
AddEventHandler('lspolicegarage:getcars', function(society)
    local ped = source
    print(society)
    MySQL.Async.fetchAll("SELECT * FROM police_car WHERE society = @society", {
        ['@society'] = society
    },
    function(cars)
        local rows = 0
        for k, v in ipairs(cars) do
            rows = rows + 1
        end
        for i=1,rows do --n rows
            TriggerClientEvent("lspolicegarage:carmenu", ped, cars[i].carname,cars[i].plate,cars[i].stored)
        end
    end)
end)