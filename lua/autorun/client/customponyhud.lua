-- You do NOT have my permission to use or redistribute this code and textures 

if !ConVarExists("HUD_Toggle") then
   CreateClientConVar("HUD_Toggle", '1', true, false)
end
if !ConVarExists("HUD_pony") then
    CreateClientConVar("HUD_pony", '1',true, false)
end
if !ConVarExists("HUD_Counter_Toggle") then
    CreateClientConVar("HUD_Counter_Toggle", '1',true, false)
end

print( "Custom Pony HUD v1.0 Loading..." )
function HUDFontSet() --Creates font
surface.CreateFont( "FONT_AMMO",
    {
        font      = "Celestia Redux",
        size      = 45,
        weight    = 200,
    }

 )
surface.CreateFont( "FONT_WEAPON_NAME",
    {
        font      = "Celestia Redux",
        size      = 25,
        weight    = 100,
    }

 )
end
hook.Add("Initialize","HUDfont",HUDFontSet)



function disableCHUD(name) -- Dont draw the hl2 hud
	if GetConVarNumber("HUD_Toggle") <= 0 then return end
	
	if name == "CHudHealth" or name == "CHudBattery" or name == "CHudAmmo" or name == "CHudSecondaryAmmo" then 
		return false 
	end

end
hook.Add("HUDShouldDraw", "disableHUD", disableCHUD)


local Selected_pony_health = 0
local Selected_pony_ammo = 0
local Text_Color = Color(0,0,0,255)
if(CLIENT)then
-- Table of all the Textures
local PonyTextureTable={
--[00]={surface.GetTextureID("name_health"),surface.GetTextureID("name_ammo"),Color(0,0,0,255)},
}


local function HUD()
local ply=LocalPlayer() -- Identify the Player
local Num=GetConVarNumber("HUD_pony")-- Get the selected pony
local SelectedPonyHealth=surface.GetTextureID("hud_health") -- get the health textures 
local SelectedPonyAmmo=surface.GetTextureID("hud_ammo") -- get the ammo textures 
local TextColor=Color(255,255,255,255)
local Wep=ply:GetActiveWeapon() --Get the current weapon
               
    if(IsValid(Wep))then
        if(GetConVarNumber("HUD_Toggle")==1)then -- If the hud is enabled
            if(ply:Alive())then -- Make sure the player is alive
                local health=ply:Health() -- Get the player's health
                local armor=ply:Armor() -- Get the player's armor
                local hx=health*1.7
                local ax=armor*1.7
				local hx = math.Clamp((health*1.7), 0, 170) -- Stops scale from jumping out of borders
				local ax = math.Clamp((armor*1.7), 0, 170)
                -- Draw main hud texture
                surface.SetDrawColor(255,255,255,255)
                surface.SetTexture(SelectedPonyHealth)
                surface.DrawTexturedRect(-10,ScrH()-300,500,300)
                surface.SetTexture(0)
                draw.NoTexture()                 
                draw.RoundedBox(0,144,ScrH()-112.5,hx,19.4,Color(196,196,196,255)) -- Health bar color
                draw.RoundedBox(0,144,ScrH()-66.7,ax,19.4,Color(196,196,196,255)) -- Armor bar color
                draw.SimpleText(health.."%","FONT_WEAPON_NAME",210,ScrH()-119.5,Color(0,0,0,255),100,100)
                draw.SimpleText(armor.."%","FONT_WEAPON_NAME",210,ScrH()-74.7,Color(0,0,0,255),100,100)
            end
                -- This is were the main hud stops and were the ammo hud starts
                local name=ply:GetActiveWeapon():GetPrintName()--Get the display name
                local Mag=Wep:Clip1() -- Gets how much ammo is left in the players mag
                local Res=ply:GetAmmoCount(Wep:GetPrimaryAmmoType()) -- Gets how much ammo is left in the reserve
                local SecondAmmo=ply:GetAmmoCount(Wep:GetSecondaryAmmoType()) -- Gets how much Secondary ammo is left(EX smg gernades)
                if((Mag<=0)and(Res<=0)and(SecondAmmo<=0))then return end -- Make sure the counter has values. If not don't draw the ammo counter
                -- Draw the ammo hud texture
                surface.SetDrawColor(255,255,255,255)
                surface.SetTexture(SelectedPonyAmmo)
                surface.DrawTexturedRect(ScrW()/1.189,ScrH()-250,250,250)
                surface.SetTexture(0)
                draw.NoTexture()
                draw.SimpleText(Mag.."/"..Res.." | "..SecondAmmo,"FONT_AMMO",ScrW()/1.160,ScrH()-81,Text_Color,100,100) -- Draw the ammo counter
                draw.SimpleText(name,"FONT_WEAPON_NAME",ScrW()/1.175,ScrH()-110,Text_Color,100,100) --Draw the display name
                                       
        end
    end
end
        hook.Add("HUDPaint","HUD",HUD)
end




local function HUDOption(panel) -- This function holds all the code for the options menu. 
        local HUDOption = {Options = {}, CVars = {}, Label = "#Presets", MenuButton = "1", Folder = "HUD Options"}

        panel:AddControl("CheckBox", {
        Label = "Enable HUD",
        Command = "HUD_Toggle",
        })

        HUDOption.Options["#Default"] = { HUD_Toggle = "1",HUD_Counter_Toggle = "1" }

        panel:AddControl("Label", {Text = ""})
        panel:AddControl("Label", {Text = "Original Author: ResidualGrub"})
		panel:AddControl("Label", {Text = "Made by: Fire Sparkle, Epic Acrylic & [creator of OC] (for personal use only)"})
		panel:AddControl("Label", {Text = ""})
		panel:AddControl("Label", {Text = ""})
    end 

    function HUDOptioncreate() -- Create the options panel
        spawnmenu.AddToolMenuOption("Options", "Pony HUD", "HUD", "HUD", "", "", HUDOption)
    end
    hook.Add("PopulateToolMenu", "HUDOptioncreate", HUDOptioncreate)
	
print( "Custom Pony HUD v1.0 Loaded!" )