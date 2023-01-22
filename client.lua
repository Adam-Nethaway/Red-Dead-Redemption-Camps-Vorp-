progressBar = exports.vorp_progressbar:initiate()

local VORPcore = {}
local PlacedObjects = {}

TriggerEvent("getCore", function(core)
    VORPcore = core
end)

Tipi = 0
Tent = 0
Chair = 0
Crate = 0
Hitch = 0
Cot = 0
Rug = 0

ZoneTypeId = 1
current_district = 0
local inCity = false
local obj
local placed = false
local objHash
local coords
local forward
local h
local finalHeading
local finalCoords
local x,y,z
local pos

function CheckTown()
    local x,y,z =  table.unpack(GetEntityCoords(PlayerPedId()))

    -- Find ZoneName of type "District" at current coords. Returns false if nothing of this type was found:
    ZoneTypeId = 1
    current_district = Citizen.InvokeNative(0x43AD8FC02B429D33 ,x,y,z,ZoneTypeId)
    if current_district then
        inCity = true
        print('in town')
        TriggerServerEvent('inTown', inCity)
    else
        print('not in town')
        inCity = false
        TriggerServerEvent('inTown', inCity)
    end
end

function PlaceTent()
    if Tent ~= 0 then
        SetEntityAsMissionEntity(Tent)
        SetEntityAsMissionEntity(Cot)
        SetEntityAsMissionEntity(Crate)
        SetEntityAsMissionEntity(Chair)
        SetEntityAsMissionEntity(Hitch)
        SetEntityAsMissionEntity(Rug)
        
        DeleteObject(Tent)
        Tent = 0
    end
    local ped = PlayerPedId()
    --TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 30000, true, false, false, false)

    --progressBar.start("Placing Tent...", 30000)
    --Wait(30000) ClearPedTasksImmediately(ped)

    local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(ped, 0.0, 3.0, -1.55))
    local x2,y2,z2 = table.unpack(GetOffsetFromEntityInWorldCoords(ped, 0.5, 2.6, -1.55))
    local x3,y3,z3 = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), -1.4, 1.2, -1.55))
    local x4,y4,z4 = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), -1.2, 2.8, -1.55))
    local x5,y5,z5 = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), -3.3, -1.8, -1.55))

    local prop = CreateObject(GetHashKey(Config.Tent), x, y, z, true, false, true)

    -- local prop2 = CreateObject(GetHashKey(Config.Cot), x2, y2, z2, true, false, true)
    -- local prop3 = CreateObject(GetHashKey(Config.Crate), x3, y3, z3, true, false, true)
    -- local prop4 = CreateObject(GetHashKey(Config.Chair), x4, y4, z4, true, false, true)
    -- local prop5 = CreateObject(GetHashKey("p_hitchingpost05x"), x5, y5, z5, true, false, true)
    -- local prop6 = CreateObject(GetHashKey(Config.Rug), x2, y2, z2, true, false, true)

    SetEntityHeading(prop, GetEntityHeading(ped))
    
    PlaceObjectOnGroundProperly(prop, true)

    -- SetEntityHeading(prop2, GetEntityHeading(prop))
    -- PlaceObjectOnGroundProperly(prop2)

    -- SetEntityHeading(prop3, GetEntityHeading(prop) - 90)
    -- PlaceObjectOnGroundProperly(prop3)

    -- SetEntityHeading(prop4, GetEntityHeading(prop) + 45)
    -- PlaceObjectOnGroundProperly(prop4)
    
    -- SetEntityHeading(prop5, GetEntityHeading(prop) + 45)
    -- PlaceObjectOnGroundProperly(prop5)

    -- SetEntityHeading(prop6, GetEntityHeading(prop) - 90)
    -- PlaceObjectOnGroundProperly(prop6)

    Tent = prop
    -- Cot = prop2
    -- Crate = prop3
    -- Chair = prop4
    -- Hitch = prop5
    -- Rug = prop6

    
        
end

Citizen.CreateThread(function ()
    while true do
        Wait(0)
        --print(GetHashKey(5116162))
        if Tent ~= 0 then
            tentblip = Citizen.InvokeNative(0x23F74C2FDA6E7C61, 1664425300, Tent) 
            SetBlipSprite(tentblip, -910004446, true)
            SetBlipScale(tentblip, 0.5)
            Citizen.InvokeNative(0x9CB1A1623062F402, tentblip, "Camp")
        end
    end
end)

function PlaceTipi()
    if Tipi ~= 0 then
        SetEntityAsMissionEntity(Tipi)
        
        DeleteObject(Tipi)
        Tipi = 0
    end
    local ped1 = PlayerPedId()
    --TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 20000, true, false, false, false)

    --progressbar.start("Placing Tipi...", 20000)
    --Wait(20000) ClearPedTasksImmediately(ped)
    local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(ped1, 0.0, 0.0, -2.0))

    local prop = CreateObject(GetHashKey("s_wap_rainsfalls"), x, y, z, true, false, true)

    SetEntityHeading(prop, 0.0)
    Citizen.InvokeNative(0x9587913B9E772D29, prop, true) 

    Tipi = prop
end

RegisterCommand('packtent', function()
    if Tent ~= 0 then
        local ped = PlayerPedId()
        TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 5000, true, false, false, false)
        progressBar.start("Packing Tent...", 5000)
        Wait(5000)
        TriggerServerEvent('refundTent')
        DeleteCampObjects()

        SetEntityAsMissionEntity(Tent)
        SetEntityAsMissionEntity(Cot)
        SetEntityAsMissionEntity(Crate)
        SetEntityAsMissionEntity(Chair)
        SetEntityAsMissionEntity(Hitch)
        SetEntityAsMissionEntity(Rug)

        DeleteObject(Tent)
        DeleteObject(Cot)
        DeleteObject(Crate)
        DeleteObject(Chair)
        DeleteObject(Hitch)
        DeleteObject(Rug)

        Tent = 0
        Chair = 0
        Crate = 0
        Hitch = 0
        Cot = 0
        Roll = 0
        RemoveBlip(tentblip)
    else 
        VORPcore.NotifyBottomRight("No tent",4000)
    end
end)

RegisterCommand('packtipi', function()
    if Tipi ~= 0 then
        local ped = PlayerPedId()
        TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 5000, true, false, false, false)
        progressBar.start("Packing Tipi...", 5000)
        Wait(5000)
        TriggerServerEvent('refundTipi')
        SetEntityAsMissionEntity(Tipi)
        DeleteObject(Tipi)

        Tipi = 0
    else 
        VORPcore.NotifyBottomRight("No Tipi",4000)
    end
end)

function whenKeyJustPressed(key)
    if Citizen.InvokeNative(0x580417101DDB492F, 0, key) then
        return true
    else
        return false
    end
end

Citizen.CreateThread(function ()
    while true do
        Wait(0)
        local pedCoord = GetEntityCoords(PlayerPedId())
        if PlacingObject then
            coords = GetEntityCoords(Tent)
            forward = GetEntityForwardVector(PlayerPedId())

            if not placed then 
                obj = CreateObject(GetHashKey(objHash), coords.x, coords.y, coords.z, true, true, false)
                
                SetEntityAsMissionEntity(obj, true)
                PlaceObjectOnGroundProperly(obj)
                SetEntityAlpha(obj, 200)
                SetEntityCollision(obj, false, false)
                FreezeEntityPosition(obj, true)
                pos = GetEntityCoords(obj, true)
                x,y,z = table.unpack(pos)
                           
                placed = true
            end
            h = GetEntityHeading(obj)
            SetEntityCoords(obj, pedCoord.x + (forward.x * 2), pedCoord.y + (forward.y * 2), z , true, true, true, false)
            finalCoords = GetEntityCoords(obj)
            finalHeading = GetEntityHeading(obj)

            if (IsControlJustPressed(1, 0x430593AA)) then --LEFT BRACKET
                h = h + 10
                SetEntityHeading(obj, h % 360)

            elseif (IsControlJustPressed(1, 0xA5BDCD3C)) then --RIGHT BRACKET
                h = h - 10
                SetEntityHeading(obj, h % 360)

            -- elseif (IsControlJustPressed(1, 0x6319DB71)) then --UP
            --     SetEntityCoords(obj, x, y , z+ 0.1 , true, true, true, false)
            --     --PlaceObjectOnGroundProperly(obj)
            --     z = z + 0.1
            -- elseif (IsControlJustPressed(1, 0x05CA7C52)) then --DOWNM
            --     SetEntityCoords(obj, x, y , z - 0.1, true, true, true, false)
            --     --PlaceObjectOnGroundProperly(obj)
            --     z = z - 0.1
            elseif (IsControlJustPressed(1, 0xB2F377E8)) then
                DeleteObject(obj)
                local newObj = CreateObject(GetHashKey(objHash), finalCoords.x, finalCoords.y, finalCoords.z, true, true, true, false, false)
    
                SetEntityHeading(newObj, finalHeading)
                PlaceObjectOnGroundProperly(newObj)
                table.insert(PlacedObjects, newObj)
                PlacingObject = false
                placed = false
            end
        end
    end
end)

RegisterCommand('place', function (source, args, rawCommand)

    if Tent ~= 0 then
        if args[1] == "chair" then
            objHash = tostring(Config.chairs[tonumber(args[2])])
            --elseif  then
            print(Config.chairs[tonumber(args[2])])
            args[1] = ""

        elseif args[1] == "crate" then
            objHash = tostring(Config.crates[tonumber(args[2])])
            --elseif  then
            print(Config.crates[tonumber(args[2])])
            args[1] = ""

        elseif args[1] == "bed" then
            objHash = tostring(Config.beds[tonumber(args[2])])
            --elseif  then
            print(Config.beds[tonumber(args[2])])
            args[1] = ""

        elseif args[1] == "rug" then
            objHash = tostring(Config.rugs[tonumber(args[2])])
            --elseif  then
            print(Config.rugs[tonumber(args[2])])
            args[1] = ""

        elseif args[1] == "table" then
            objHash = tostring(Config.tables[tonumber(args[2])])
            --elseif  then
            print(Config.tables[tonumber(args[2])])
            args[1] = ""

        elseif args[1] == "hitch" then
            objHash = tostring(Config.hitches[tonumber(args[2])])
            --elseif  then
            print(Config.hitches[tonumber(args[2])])
            args[1] = ""
        else 
            print("Not an item")
        end
        PlacingObject = true
        args[1] = " "
    else
        print("no tent")
    end   
end)

RegisterCommand('delete', function (source, args, rawCommand)
    local lastIndex = #PlacedObjects

    DeleteObject(PlacedObjects[lastIndex])
    table.remove(PlacedObjects, lastIndex)
end)

Citizen.CreateThread(function ()
    for k, v in pairs(PlacedObjects) do
        print(v)
    end
end)

function DeleteCampObjects()
    for k,v in pairs(PlacedObjects)do
        DeleteObject(v)
        PlacedObjects = {}
    end
end

Citizen.CreateThread(function ()
    while true do 
        Wait(0)
        for k, v in pairs(PlacedObjects) do
            print("Object: " ..v)
        end
    end
end)

RegisterNetEvent('tent')
AddEventHandler('tent', function()
    PlaceTent()
end)

RegisterNetEvent('tipi')
AddEventHandler('tipi', function()
    PlaceTipi()
end)

RegisterNetEvent('checkTown')
AddEventHandler('checkTown', function()
    CheckTown()
end)

--------------------------------------------------------------TESTING SCRIPTS ---------------------------------------------------------------------------
friend = nil
DogOut = false
Following = false

RegisterCommand('go', function ()
	local hash = GetHashKey("a_c_dogcollie_01")
	local pos = GetEntityCoords(PlayerPedId())
    DogOut = true

	RequestModel(hash, 0)

	while not HasModelLoaded(hash) do
		RequestModel(hash, 0)
		Wait(0)
	end

	friend = CreatePed(hash, pos.x, pos.y + 2, pos.z, 0.0, true, false, true, true)

	SetEntityInvincible(friend, true)
	Citizen.InvokeNative(0x9587913B9E772D29, friend, true) -- PlaceEntityOnGroundProperly
	Wait(100)
	Citizen.InvokeNative(0x1794B4FCC84D812F, friend, 1) -- SetEntityVisible
	Citizen.InvokeNative(0x0DF7692B1D9E7BA7, friend, 255, false) -- SetEntityAlpha
	Citizen.InvokeNative(0x283978A15512B2FE, friend, true) -- SetRandomOutfitVariation - Invisible without 

	Citizen.InvokeNative(0xCC8CA3E88256E58F, friend, false, true, true, true, false) -- _UPDATE_PED_VARIATION
	SetEntityAsMissionEntity(friend, true, true)
	--SetEntityInvincible(friend, false)
	--NetworkRegisterEntityAsNetworked(friend)
    Follow(friend, true)
    
end)

function Follow(dog, follow)
    if follow then
        Citizen.InvokeNative(0x304AE42E357B8C7E, dog, PlayerPedId(), 1.0, 1.0, 0.0, -1, -1, -1, true, true, false, true, true)
    else
        ClearPedTasks(dog)
    end  
end

Citizen.CreateThread(function ()
    while true do
        Wait(0)
        local coords = GetEntityCoords(friend)
        
        -- if DogOut then
        --     local animalblip = Citizen.InvokeNative(0x23F74C2FDA6E7C61, 1664425300, friend) 
        --     SetBlipSprite(animalblip, -1646261997, true)
        --     SetBlipScale(animalblip, 0.5)
        --     Citizen.InvokeNative(0x9CB1A1623062F402, animalblip, "Companion")
        -- end

        if IsControlJustPressed(1, 0xA5BDCD3C) and DogOut and not Following then
            Following = true
            ClearPedTasksImmediately(dog)
            Follow(friend, true)
        elseif IsControlJustPressed(1, 0x446258B6) and DogOut then
            Following = false

            Follow(friend, false)
            RequestAnimDict("amb_creature_mammal@world_dog_sitting@idle")
            TaskPlayAnim(friend, "amb_creature_mammal@world_dog_sitting@idle", "idle_b", 8.0, 8.0, -1, 1, 0, 0, 0, 0)

        elseif IsControlJustPressed(1, 0x3C3DD371) and DogOut then
            Following = false

            Follow(friend, false)
            RequestAnimDict("amb_creature_mammal@world_dog_resting@idle")
            TaskPlayAnim(friend, "amb_creature_mammal@world_dog_resting@idle", "idle_a", 8.0, 8.0, -1, 1, 0, 0, 0, 0)
        end
    end
end)