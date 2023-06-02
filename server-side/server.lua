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
vCLIENT = Tunnel.getInterface("lc_policejob")
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOTORISTA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("Patrulhar",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id and vRP.hasPermission(user_id,"Police") then
		vCLIENT.toggleService(source)
	else
		TriggerClientEvent("Notify",source,"vermelho","Apenas Policiais podem Patrulhar.",5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTMETHOD
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.paymentMethod(status)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local value = math.random(45,55)

		if not status then
			vRP.giveInventoryItem(user_id,"dollars",parseInt(value),true)
		else
			vRP.giveInventoryItem(user_id,"dollars",parseInt(value),true)
		end
		TriggerClientEvent("sounds:source",source,"coin",0.5)
	end
end