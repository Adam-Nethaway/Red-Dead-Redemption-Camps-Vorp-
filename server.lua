VorpInv = exports.vorp_inventory:vorp_inventoryApi()
VorpCore = {}

local inTown 

TriggerEvent("getCore", function(core)
    VorpCore = core
end)

VorpInv.RegisterUsableItem("tent", function(data)
    TriggerClientEvent('checkTown', data.source)

    while inTown == nil do
        print('Checking Location..')
        Wait(0)
    end
    --Wait(500)
    if inTown then 
        print("Get out of town to place yo tent")
        VorpCore.NotifyBottomRight(data.source,"You can't place a tent inside a town.",4000)
        inTown = nil
    else 
        print('Congrats, Placing Tent..')
        VorpInv.subItem(data.source, "tent", 1)
        TriggerClientEvent("tent", data.source)
        inTown = nil
    end
    
end)

-- VorpInv.RegisterUsableItem("tipi", function(data)
--     VorpInv.subItem(data.source, "tipi", 1)
--     TriggerClientEvent("tipi", data.source)
-- end)

RegisterServerEvent('refundTent')
AddEventHandler('refundTent', function()
    local _source = source
    VorpInv.addItem(_source, "tent", 1)
end)

RegisterServerEvent('refundTipi')
AddEventHandler('refundTipi', function()
    local _source = source
    VorpInv.addItem(_source, "tipi", 1)
end)

RegisterServerEvent('inTown')
AddEventHandler('inTown', function (town)
    inTown = town
end)