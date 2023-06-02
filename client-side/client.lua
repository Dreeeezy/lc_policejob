-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cnVRP = {}
Tunnel.bindInterface("lc_policejob",cnVRP)
vSERVER = Tunnel.getInterface("lc_policejob")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local blip = nil
local inService = false
local startX = 441.11  
local startY = -982.79
local startZ = 30.69
local driverPosition = 1
local timeSeconds = 0  
-----------------------------------------------------------------------------------------------------------------------------------------
-- COORDS
-----------------------------------------------------------------------------------------------------------------------------------------
local coords = {
	[1] = { 159.29,-1013.24,29.4 },
	[2] = { 76.17,-1473.45,29.33 },
	[3] = { -1023.15,-2713.98,13.82 },
	[4] = { -70.88,-2148.06,10.35 },
	[5] = { -643.08,-1680.17,25.14 },
	[6] = { -1051.66,-1274.48,6.27 },
	[7] = { -1867.9,-541.49,11.69 },
	[8] = { -1576.44,-201.53,55.43 },
	[9] = { -973.67,409.65,75.6 },
	[10] = { -340.23,474.88,111.12 },
	[11] = { 520.74,258.17,103.09 },
	[12] = { 773.67,-669.64,28.85 },
	[13] = { 1073.87,-1440.71,36.76 },
	[14] = { 1026.75,-2580.63,40.44 },
	[15] = { 191.39,-2927.93,6.68 },
	[16] = { -193.38,-2570.48,6.01 },
	[17] = { -734.58,-1627.12,25.31 },
	[18] = { -532.92,-1041.47,22.73 },
	[19] = { -839.61,-1021.92,13.3 },
	[20] = { -1279.32,-1232.54,4.46 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTSERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.toggleService()
	local ped = PlayerPedId()

	if not inService then
		startthreadservice()
		startthreadtimeseconds()
		inService = true
		makeBlipMarked()
		TriggerEvent("Notify","verde","A <b>Patrulha</b> foi iniciada.",2000)
	else
		inService = false
		TriggerEvent("Notify","vermelho","A <b>Patrulha</b> foi finalizada.",2000)
		if DoesBlipExist(blip) then
			RemoveBlip(blip)
			blip = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
function startthreadservice()
	Citizen.CreateThread(function()
		while true do
			local timeDistance = 500
			if inService then
				local ped = PlayerPedId()
				if IsPedInAnyVehicle(ped) then
					local veh = GetVehiclePedIsUsing(ped)
					local coordsPed = GetEntityCoords(ped)
					local distance = #(coordsPed - vector3(coords[driverPosition][1],coords[driverPosition][2],coords[driverPosition][3]))
					if distance <= 300 then
						timeDistance = 4
						DrawMarker(22,coords[driverPosition][1],coords[driverPosition][2],coords[driverPosition][3]+0.60,0,0,0,0,180.0,130.0,2.0,2.0,1.0,121,206,121,100,1,0,0,1)
						if distance <= 15 then
							local speed = GetEntitySpeed(veh) * 2.236936
							if IsControlJustPressed(1,38) and speed <= 20 and timeSeconds <= 0 then
								timeSeconds = 2
								if driverPosition == #coords then
									driverPosition = 1
									vSERVER.paymentMethod(true)
								else
									driverPosition = driverPosition + 1
									vSERVER.paymentMethod(false)
								end
								makeBlipMarked()
							end
						end
					end
				end
			end
			Citizen.Wait(timeDistance)
		end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMESECONDS
-----------------------------------------------------------------------------------------------------------------------------------------
function startthreadtimeseconds()
	Citizen.CreateThread(function()
		while true do
			if timeSeconds > 0 then
				timeSeconds = timeSeconds - 1
			end
			Citizen.Wait(1000)
		end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAKEBLIPMARKED
-----------------------------------------------------------------------------------------------------------------------------------------
function makeBlipMarked()
	if DoesBlipExist(blip) then
		RemoveBlip(blip)
		blip = nil
	end

	blip = AddBlipForCoord(coords[driverPosition][1],coords[driverPosition][2],coords[driverPosition][3],50.0)
	SetBlipSprite(blip,1)
	SetBlipColour(blip,1)
	SetBlipScale(blip,0.7)
	SetBlipAsShortRange(blip,false)
	SetBlipRoute(blip,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Ponto de Patrulha")
	EndTextCommandSetBlipName(blip)
end