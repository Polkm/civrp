--[[function GM:InitPostEntity() 
	table.Random(ents.FindByName('daynight_brush')):Remove()
end]]

CIVRP_WorldData = {}
CIVRP_WorldData.Time = 0
CIVRP_WorldData.CurStage = 0
CIVRP_WorldData.DayLength = 60
CIVRP_WorldData.Dawn = {Start = CIVRP_WorldData.DayLength/8,End = CIVRP_WorldData.DayLength/3,}
CIVRP_WorldData.Dusk = {Start = CIVRP_WorldData.DayLength*(2/3),End = CIVRP_WorldData.DayLength*(7/8),}
CIVRP_WorldData.NextTime = 0
CIVRP_WorldData.TimeNextSecond = 0 
CIVRP_WorldData.DarknessHigh = 255
CIVRP_WorldData.Interval = 0.1
CIVRP_WorldData.Fog = {Enabled = false,Ent = nil,Duration = 0}
CIVRP_WorldData.DayNight = false


local COLFOG =  {}
COLFOG[1] = 0
COLFOG[2] = 0.05
COLFOG[3] = 0.10
COLFOG[4] = 0.125
COLFOG[5] = 0.14
COLFOG[6] = 0.165
COLFOG[7] = 0.23
COLFOG[8] = 0.25
COLFOG[9] = 0.33
COLFOG[10] = 0.40
COLFOG[11] = 0.43
COLFOG[12] = 0.47
COLFOG[13] = 0.5
COLFOG[14] = 0.54
COLFOG[15] = 0.56
COLFOG[16] = 0.58
COLFOG[17] = 0.60
COLFOG[18] = 0.62
COLFOG[19] = 0.63
COLFOG[20] = 0.64
COLFOG[21] = 0.65
COLFOG[22] = 0.66
COLFOG[23] = 0.67
COLFOG[24] = 0.68
COLFOG[25] = 0.69
COLFOG[26] = 0.73
COLFOG[27] = 0.75
COLFOG[28] = 0.75
COLFOG[29] = 0.75
COLFOG[30] = 0.73
COLFOG[31] = 0.70
COLFOG[32] = 0.70
COLFOG[33] = 0.71
COLFOG[34] = 0.73
COLFOG[35] = 0.74
COLFOG[36] = 0.75
COLFOG[37] = 0.76
COLFOG[38] = 0.77
COLFOG[38] = 0.78
COLFOG[39] = 0.79
COLFOG[40] = 0.80
COLFOG[41] = 0.81
COLFOG[42] = 0.82
COLFOG[43] = 0.83
COLFOG[44] = 0.84
COLFOG[45] = 0.85
COLFOG[46] = 0.86
COLFOG[47] = 0.87
COLFOG[48] = 0.88
COLFOG[49] = 0.89
COLFOG[50] = 0.91
COLFOG[51] = 0.91
COLFOG[52] = 0.91
COLFOG[53] = 0.92
COLFOG[54] = 0.93
COLFOG[55] = 0.93
COLFOG[56] = 0.94
COLFOG[57] = 0.94
COLFOG[58] = 0.95
COLFOG[59] = 0.95
COLFOG[60] = 0.96
COLFOG[61] = 0.96
COLFOG[62] = 0.96
COLFOG[63] = 0.97
COLFOG[64] = 0.97
COLFOG[65] = 0.97
COLFOG[66] = 0.97
COLFOG[67] = 0.97
COLFOG[68] = 0.98
COLFOG[69] = 0.99
COLFOG[70] = 0.98
COLFOG[71] = 0.98
COLFOG[72] = 0.98
COLFOG[73] = 0.98
COLFOG[74] = 0.98
COLFOG[75] = 0.98
COLFOG[76] = 0.99
COLFOG[77] = 0.99
COLFOG[78] = .99
COLFOG[78] = .99
COLFOG[79] = .99
COLFOG[80] = .99
COLFOG[81] = .99
COLFOG[82] = .99
COLFOG[83] = .99
COLFOG[84] = .99
COLFOG[85] = .99
COLFOG[86] = .99
COLFOG[87] = 1
COLFOG[88] = 1
COLFOG[89] = 1
COLFOG[90] = 1
COLFOG[91] = 1
COLFOG[92] = 1
COLFOG[93] = 1
COLFOG[94] = 1
COLFOG[95] = 1
COLFOG[96] = 1
COLFOG[97] = 1
COLFOG[98] = 1
COLFOG[99] = 1
COLFOG[100] = 1

local Patterns = {}
Patterns[1] = {Letter = "a",SkyColor = "0 0 0 " , SkyAlpha = "35"}
Patterns[2] = {Letter = "b",SkyColor = "0 0 0 " , SkyAlpha = "45"}
Patterns[3] = {Letter = "c",SkyColor = "0 0 0 " , SkyAlpha = "60"}
Patterns[4] = {Letter = "d",SkyColor = "0 0 0 " , SkyAlpha = "65"}
Patterns[5] = {Letter = "e",SkyColor = "0 0 0 " , SkyAlpha = "75"}
Patterns[6] = {Letter = "f",SkyColor = "0 0 0 " , SkyAlpha = "85"}
Patterns[7] = {Letter = "g",SkyColor = "0 0 0 " , SkyAlpha = "95"}
Patterns[8] = {Letter = "h",SkyColor = "0 0 0 " , SkyAlpha = "105"}
Patterns[9] = {Letter = "i",SkyColor = "0 0 0 " , SkyAlpha = "115"}
Patterns[10] = {Letter = "j",SkyColor = "0 0 0 " , SkyAlpha = "125"}
Patterns[11] = {Letter = "k",SkyColor = "0 0 0 " , SkyAlpha = "135"}
Patterns[12] = {Letter = "l",SkyColor = "0 0 0 " , SkyAlpha = "145"}
Patterns[13] = {Letter = "m",SkyColor = "0 0 0 " , SkyAlpha = "155"}
Patterns[14] = {Letter = "n",SkyColor = "0 0 0 " , SkyAlpha = "145"}
Patterns[15] = {Letter = "o",SkyColor = "0 0 0 " , SkyAlpha = "255"}
Patterns[16] = {Letter = "p",SkyColor = "0 0 0 " , SkyAlpha = "255"}
Patterns[17] = {Letter = "q",SkyColor = "0 0 0 " , SkyAlpha = "255"}
Patterns[18] = {Letter = "r",SkyColor = "0 0 0 " , SkyAlpha = "255"}
Patterns[19] = {Letter = "s",SkyColor = "0 0 0 " , SkyAlpha = "255"}
Patterns[20] = {Letter = "t",SkyColor = "0 0 0 " , SkyAlpha = "255"}
Patterns[21] = {Letter = "u",SkyColor = "0 0 0 " , SkyAlpha = "255"}
Patterns[22] = {Letter = "v",SkyColor = "0 0 0 " , SkyAlpha = "255"}
Patterns[23] = {Letter = "w",SkyColor = "0 0 0 " , SkyAlpha = "255"}
Patterns[24] = {Letter = "x",SkyColor = "0 0 0 " , SkyAlpha = "255"}
Patterns[25] = {Letter = "y",SkyColor = "0 0 0 " , SkyAlpha = "255"}
Patterns[26] = {Letter = "z",SkyColor = "0 0 0 " , SkyAlpha = "0"}

function GM:InitPostEntity() 
	if table.Count(ents.FindByClass( 'light_environment' )) >= 1 then
		--Enviorment Light
		CIVRP_WorldData.GlobalLight = table.Random(ents.FindByClass('light_environment'))
		--Skybox
		CIVRP_WorldData.SkyBox = table.Random(ents.FindByName('daynight_brush'))
		--Sun
		CIVRP_WorldData.Sun = table.Random(ents.FindByClass('env_sun'))
		CIVRP_WorldData.Sun:SetKeyValue('material', 'sprites/light_glow02_add_noz.vmt')
		CIVRP_WorldData.Sun:SetKeyValue('overlaymaterial', 'sprites/light_glow02_add_noz.vmt')
		--Fog controller
		
			CIVRP_WorldData.Fog.Ent = table.Random(ents.FindByClass('env_fog_controller'))
			CIVRP_WorldData.Fog.Ent:SetKeyValue("spawnflags", 1)
			CIVRP_WorldData.Fog.Ent:SetKeyValue("fogend", CIVRP_FADEDISTANCE - 100)
			CIVRP_WorldData.Fog.Ent:SetKeyValue("fogstart", 100)
			CIVRP_WorldData.Fog.Ent:SetKeyValue("fogmaxdensity", 1)
			CIVRP_WorldData.Fog.Ent:SetKeyValue("farz", CIVRP_FADEDISTANCE + 500) --Temporrary fix
			CIVRP_WorldData.Fog.Ent:Fire("TurnOn", '', 0)
			CIVRP_WorldData.Fog.Ent:Activate()

		--Set enviorment light
		CIVRP_WorldData.GlobalLight:Fire("SetPattern", 'a', 0) 
		CIVRP_WorldData.GlobalLight:Activate()
		--Activate the think function
		CIVRP_WorldData.DayNight = true
	end
end

function CIVRP_DayNightThink() 
	--Don't think if the system has not been initialized
	if !CIVRP_WorldData.DayNight then return false end
	--Don't think if it is not time to think
	if CIVRP_WorldData.TimeNextSecond <= CurTime() then
		--Set the next time to think
		CIVRP_WorldData.Time = CIVRP_WorldData.Time + CIVRP_WorldData.Interval
		local Per_DayCompleted = (CIVRP_WorldData.Time) / (CIVRP_WorldData.DayLength / 2)
		local Per_DawnCompleted = (CIVRP_WorldData.Time-CIVRP_WorldData.Dawn.Start)/(CIVRP_WorldData.Dawn.End-CIVRP_WorldData.Dawn.Start)
		local Per_DuskCompleted = ((CIVRP_WorldData.Time-CIVRP_WorldData.Dusk.Start))/(CIVRP_WorldData.Dusk.End - CIVRP_WorldData.Dusk.Start)
		local col = {r = 10, b = 25, g = 15, a = 255}
		if IsDay() then
			CIVRP_WorldData.GlobalLight:Fire("TurnOn",'',0)	
			col = {r = 45,b = 200,g = 150,a = 255}
			col.a = 255 
			if IsDawn() then	
				col.b = math.Round(math.Clamp(200*Per_DawnCompleted,25,255))
				col.g = math.Round(math.Clamp(150*Per_DawnCompleted,15,255))
				col.r = math.Round(math.Clamp(45*Per_DawnCompleted,10,255))
			elseif IsDusk() then
				col.b = math.Round(math.Clamp((200*(1-Per_DuskCompleted)),25,255))
				col.g = math.Round(math.Clamp((150*(1-Per_DuskCompleted)),15,255))
				col.r = math.Round(math.Clamp((45*(1-Per_DuskCompleted)),10,255))
			end
		else
			CIVRP_WorldData.GlobalLight:Fire("TurnOff",'',0) 
			col.a = CIVRP_WorldData.DarknessHigh
		end	
		col.a = 255
		if CIVRP_WorldData.Time > CIVRP_WorldData.DayLength || CIVRP_WorldData.Time < 0 then
			CIVRP_WorldData.Time = 0
		end
		CIVRP_WorldData.TimeNextSecond = CurTime() + CIVRP_WorldData.Interval 
		
		CIVRP_WorldData.Sun:Fire('addoutput', 'pitch ' .. tostring(360*(CIVRP_WorldData.Time/CIVRP_WorldData.DayLength)-235), 0)
		CIVRP_WorldData.Sun:Activate()
		
		--Fog Updating
			local fcol = {r = col.r,b = col.b,g = col.g,a = 255}
							
			local additionr = 0
			local additionb = 0
			local additiong = 0
			
			if IsDay() then
				if CIVRP_WorldData.Fog.Enabled then
					col = {r = 100,b = 100,g = 100,a = 255}
					fcol = {r = 100,b = 100,g = 100,a = 255}
					if IsDawn() then
						col.r = math.Round(100 * (Per_DawnCompleted))
						col.b = math.Round(100 * (Per_DawnCompleted))
						col.g = math.Round(100 * (Per_DawnCompleted))
					--[[	if Per_DawnCompleted <= 0.5 then
							additionr = (12-(12*Per_DawnCompleted/.5))*-1
							additionb = (12-(12*Per_DawnCompleted/.5))*-1
							additiong = (12-(12*Per_DawnCompleted/.5))*-1
						else
							additionr = (12*(Per_DawnCompleted-0.5)/.5)
							additionb = (12*(Per_DawnCompleted-0.5)/.5)
							additiong = (12*(Per_DawnCompleted-0.5)/.5)
						end	]]				
						fcol.r = math.Round(col.r*COLFOG[col.r])--math.Clamp(math.Round(50*math.tan((math.rad(col.r) - math.rad(50)))+45+additionr),0,100)--Love the graphing calculators...
						fcol.b = math.Round(col.b*COLFOG[col.b])--math.Clamp(math.Round(50*math.tan((math.rad(col.r) - math.rad(50)))+45+additionb),0,100)
						fcol.g = math.Round(col.g*COLFOG[col.g])--math.Clamp(math.Round(50*math.tan((math.rad(col.r) - math.rad(50)))+45+additiong),0,100)
						print("COLFOG["..col.r.."] = "..math.Round((fcol.r/col.r)*100)/100)
					elseif IsDusk() then
						col.r = math.Round( 100 * (1-Per_DuskCompleted))
						col.b = math.Round( 100 * (1-Per_DuskCompleted))
						col.g = math.Round( 100 * (1-Per_DuskCompleted))
					--[[if Per_DuskCompleted <= 0.5 then
							additionr = (12*(Per_DuskCompleted-0.5)/.5)
							additionb = (12*(Per_DuskCompleted-0.5)/.5)
							additiong = (12*(Per_DuskCompleted-0.5)/.5)
						elseif Per_DuskCompleted > 0.5 &&  Per_DuskCompleted <= 0.75 then
							additionr = (12-(12*Per_DuskCompleted/.5))*-1
							additionb = (12-(12*Per_DuskCompleted/.5))*-1
							additiong = (12-(12*Per_DuskCompleted/.5))*-1
						end					]]
						fcol.r = math.Round(col.r*COLFOG[col.r])--math.Clamp(math.Round(50*math.tan((math.rad(col.r) - math.rad(50)))+45+additionr),0,100)--Love the graphing calculators...
						fcol.b = math.Round(col.b*COLFOG[col.b])--math.Clamp(math.Round(50*math.tan((math.rad(col.r) - math.rad(50)))+45+additionb),0,100)
						fcol.g = math.Round(col.g*COLFOG[col.g])										
					end
				else
					fcol = {r = col.r,b = col.b,g = col.g,a = 255}
				end
			else
				if CIVRP_WorldData.Fog.Enabled then
					col = {r = 0,b = 0,g = 0,a = 255}
					fcol = {r = 0,b = 0,g = 0,a = 255}
				else
					fcol = {r = col.r,b = col.b,g = col.g,a = 255}
				end
			end
		
		CIVRP_WorldData.Fog.Ent:Fire('SetColor', fcol.r .." ".. fcol.g .." ".. fcol.b, 0)
		
		--Skybox Updating
		CIVRP_WorldData.SkyBox:Fire('Color', col.r .." ".. col.g .." ".. col.b, 0)
		CIVRP_WorldData.SkyBox:Fire('Alpha', 255, 0)
		
		if CIVRP_WorldData.NextTime <= CurTime() then 
			if CIVRP_WorldData.Time >= (CIVRP_WorldData.Dawn.Start+(CIVRP_WorldData.Dawn.End-CIVRP_WorldData.Dawn.Start)/4) && CIVRP_WorldData.Time < CIVRP_WorldData.DayLength/2 then	
				if CIVRP_WorldData.CurStage < #Patterns then
					CIVRP_WorldData.CurStage = CIVRP_WorldData.CurStage + 1
				end
				CIVRP_WorldData.GlobalLight:Fire("FadeToPattern",Patterns[CIVRP_WorldData.CurStage].Letter,0)
				local addtime = (CIVRP_WorldData.DayLength/2-CIVRP_WorldData.Dawn.Start)/table.Count(Patterns)
				CIVRP_WorldData.NextTime = CurTime() + addtime
				
			elseif CIVRP_WorldData.Time >= CIVRP_WorldData.DayLength/2 && CIVRP_WorldData.Time < CIVRP_WorldData.Dusk.End then	
				if CIVRP_WorldData.CurStage > 1  then
					CIVRP_WorldData.CurStage = CIVRP_WorldData.CurStage - 1
				end
				
				CIVRP_WorldData.GlobalLight:Fire("FadeToPattern",Patterns[CIVRP_WorldData.CurStage].Letter,0) 
				
				local addtime = (CIVRP_WorldData.Dusk.End-CIVRP_WorldData.DayLength/2)/table.Count(Patterns)
				CIVRP_WorldData.NextTime = CurTime() + addtime
			end
		end
	end
end
hook.Add("Think", "Day/Night", CIVRP_DayNightThink)

function IsDay()
	if CIVRP_WorldData.Time >= CIVRP_WorldData.Dawn.Start && CIVRP_WorldData.Time < CIVRP_WorldData.Dusk.End then 
		return true
	end
	return false
end
function IsDawn()
	if CIVRP_WorldData.Time >= CIVRP_WorldData.Dawn.Start && CIVRP_WorldData.Time < CIVRP_WorldData.Dawn.End then	
		return true
	end
	return false
end
function IsDusk()
	if CIVRP_WorldData.Time >= CIVRP_WorldData.Dusk.Start && CIVRP_WorldData.Time < CIVRP_WorldData.Dusk.End then
		return true
	end
	return false
end

function IsMorning()
	if CIVRP_WorldData.Time < CIVRP_WorldData.DayLength/2 then
		return true
	end
	return false
end

function IsAfternoon()
	if CIVRP_WorldData.Time >= CIVRP_WorldData.DayLength/2 then
		return true
	end
	return false
end
--[[

// table.
local daylight = { };


// variables.
local DAY_LENGTH	= 100 * 24; // 24 hours
local DAY_START		= 5 * 100; // 5:00am
local DAY_END		= 18.5 * 100; // 6:30pm
local DAWN			= ( DAY_LENGTH / 4 );
local DAWN_START	= DAWN - 144;
local DAWN_END		= DAWN + 144;
local NOON			= DAY_LENGTH / 2;
local DUSK			= DAWN * 4;
local DUSK_START	= DUSK - 144;
local DUSK_END		= DUSK + 144;
local LIGHT_LOW		= string.byte( 'b' );
local LIGHT_HIGH	= string.byte( 'z' );


// convars.
daylight.dayspeed = CreateConVar( 'daytime_speed', '0', { FCVAR_REPLICATED , FCVAR_ARCHIVE , FCVAR_NOTIFY } );


// precache sounds.
util.PrecacheSound( 'buttons/button1.wav' );


// initalize.
function daylight:init( )
	// clear think time.
	self.nextthink = 0;
	// midnight?
	self.minute = 1;
	
	// get light entities.
	self.light_environment = ents.FindByClass( 'light_environment' );
	
	// start at night.
	if ( self.light_environment ) then
		local light;
		for _ , light in pairs( self.light_environment ) do
			light:Fire( 'FadeToPattern' , string.char( LIGHT_LOW ) , 0 );
			light:Activate( );
		end
	end
	
	// get sun entities.
	self.env_sun = ents.FindByClass( 'env_sun' );
	
	// setup the sun entities materials (fixes a repeating console error)
	if ( self.env_sun ) then
		local sun;
		for _ , sun in pairs( self.env_sun ) do
			sun:SetKeyValue( 'material' , 'sprites/light_glow02_add_noz.vmt' );
			sun:SetKeyValue( 'overlaymaterial' , 'sprites/light_glow02_add_noz.vmt' );
		end
	end
	
	// find the sky overlay brush.
	self.sky_overlay = ents.FindByName( 'daynight_brush' );
	
	// setup the sky color.
	if ( self.sky_overlay ) then
		local brush;
		for _ , brush in pairs( self.sky_overlay ) do
			// enable the brush if it isn't already.
			brush:Fire( 'Enable' , '' , 0 );
			// turn it black.
			brush:Fire( 'Color' , '0 0 0' , 0.01 );
		end
	end
	
	// build the light information table.
	self:buildLightTable( );
	
	// flag as ready.
	self.ready = true;
end


// build light information table.
function daylight:buildLightTable( )
	/*
	I used to run the light calculation dynamically, thanks
	to AndyVincent for this and the idea to build all the vars
	at once.
	*/
	
	// reset table.
	self.light_table = { };
	
	local i;
	for i = 1 , DAY_LENGTH do
		// reset current time information.
		self.light_table[i] = { };
		
		// defaults.
		local letter = string.char( LIGHT_LOW );
		local red = 0;
		local green = 0;
		local blue = 0;
		
		// calculate which letter to use in the light pattern.
		if ( i >= DAY_START && i < NOON ) then
			local progress = ( NOON - i ) / ( NOON - DAY_START );
			local letter_progress = 1 - math.EaseInOut( progress , 0 , 1 );
						
			letter = ( ( LIGHT_HIGH - LIGHT_LOW ) * letter_progress ) + LIGHT_LOW;
			letter = math.ceil( letter );
			letter = string.char( letter );
		elseif (i  >= NOON && i < DAY_END ) then
		
			local progress = ( i - NOON ) / ( DAY_END - NOON );
			local letter_progress = 1 - math.EaseInOut( progress , 0 , 1 );
						
			letter = ( ( LIGHT_HIGH - LIGHT_LOW ) * letter_progress ) + LIGHT_LOW;
			letter = math.ceil( letter );
			letter = string.char( letter );
		end
		
		// calculate colors.
		if ( i >= DAWN_START && i <= DAWN_END ) then
			// golden dawn.
			local frac = ( i - DAWN_START ) / ( DAWN_END - DAWN_START );
			if ( i < DAWN ) then
				red = 200 * frac;
				green = 128 * frac;
			else
				red = 200 - ( 200 * frac );
				green = 128 - ( 128 * frac );
			end
		elseif ( i >= DUSK_START && i <= DUSK_END ) then
			// red dusk.
			local frac = ( i - DUSK_START ) / ( DUSK_END - DUSK_START );
			if ( i < DUSK ) then
				red = 85 * frac;
			else
				red = 85 - ( 85 * frac );
			end
		elseif ( i >= DUSK_END || i <= DAWN_START ) then
			// blue hinted night sky.
			if ( i > DUSK_END ) then
				local frac = ( i - DUSK_END ) / ( DAY_LENGTH - DUSK_END );
				blue = 30 * frac;
			else
				local frac = i / DAWN_START;
				blue = 30 - ( 30 * frac );
			end
		end
		
		// store information.
		self.light_table[i].pattern = letter;
		self.light_table[i].sky_overlay_alpha = math.floor( 255 * math.Clamp( math.abs( ( i - NOON ) / NOON ) , 0 , 0.7 ) );
		self.light_table[i].sky_overlay_color = math.floor( red ) .. ' ' .. math.floor( green ) .. ' ' .. math.floor( blue );
		
		// calculate the suns angle.
		self.light_table[i].env_sun_angle = ( i / DAY_LENGTH ) * 360;
		// offset it (fixes sun<->time sync ratio)
		self.light_table[i].env_sun_angle = self.light_table[i].env_sun_angle + 90;
		// wrap around.
		if ( self.light_table[i].env_sun_angle > 360 ) then
			self.light_table[i].env_sun_angle = self.light_table[i].env_sun_angle - 360;
		end
		// store it.
		self.light_table[i].env_sun_angle = 'pitch ' .. self.light_table[i].env_sun_angle;
	end
end


// environment think.
function daylight:think( )
	// not ready to think?
	if ( !self.ready || self.nextthink > CurTime( ) ) then return; end
	
	local daylen = daylight.dayspeed:GetFloat( );
	
	// delay next think.
	self.nextthink = CurTime( ) + ( ( daylen / 1440 ) * 60 );
	
	// progress the time.
	self.minute = self.minute + 1;
	if ( self.minute > DAY_LENGTH ) then self.minute = 1; end
	
	// light pattern.
	local pattern = self.light_table[self.minute].pattern;
	
	// change the pattern if needed.
	if ( self.light_environment && self.pattern != pattern ) then
		local light;
		for _ , light in pairs( self.light_environment ) do
			light:Fire( 'FadeToPattern' , pattern , 0 );
			light:Activate( );
		end
	end
	
	// save the current pattern.
	self.pattern = pattern;
	
	// sky overlay attributes.
	local sky_overlay_alpha = self.light_table[self.minute].sky_overlay_alpha;
	local sky_overlay_color = self.light_table[self.minute].sky_overlay_color;
	
	// change the overlay.
	if ( self.sky_overlay ) then
		local brush;
		for _ , brush in pairs( self.sky_overlay ) do
			// change the alpha if needed.
			if ( self.sky_overlay_alpha != sky_overlay_alpha ) then
				brush:Fire( 'Alpha' , sky_overlay_alpha , 0 );
			end
			
			// change the color if needed.
			if ( self.sky_overlay_color != sky_overlay_color ) then
				brush:Fire( 'Color' , sky_overlay_color , 0 );
			end
		end
	end
	
	// save the overlay attributes.
	self.sky_overlay_alpha = sky_overlay_alpha;
	self.sky_overlay_color = sky_overlay_color;
	
	// sun angle.
	local env_sun_angle = self.light_table[self.minute].env_sun_angle;
	
	// update the sun position if needed.
	if ( self.env_sun && self.env_sun_angle != env_sun_angle ) then
		local sun;
		for _ , sun in pairs( self.env_sun ) do
			sun:Fire( 'addoutput' , env_sun_angle , 0 );
			sun:Activate( );
		end
	end
	
	// save the sun angle.
	self.env_sun_angle = env_sun_angle;
	
	// make the lights go magic!
	if ( self.minute == DAWN ) then
		self:lightsOff( );
	elseif ( self.minute == DUSK ) then
		self:lightsOn( );
	end
end


// add night lights.
function daylight:checkNightLight( ent , key , val )
	// check if its a light.
	if ( !string.find( ent:GetClass( ) , 'light' ) ) then return; end
	
	// define table.
	self.nightlights = self.nightlights or { };
	
	if ( key == 'nightlight' ) then
		local name = ent:GetClass( ) .. '_nightlight' .. ent:EntIndex( );
//		ent:SetKeyValue( 'targetname' , name );
		table.insert( self.nightlights , { ent = ent , style = val } );
		ent:Fire( 'TurnOn' , '' , 0 );
	end
end


// lights on bitch!
function daylight:lightsOn( )
	// no lights? bail.
	if ( !self.nightlights ) then return; end
	
	// macro function for making the lights flicker.
	local function flicker( ent )
		// pattern.
		local new_pattern;
		
		// randomize it.
		if ( math.random( 1 , 2 ) == 1 ) then
			new_pattern = 'az';
		else
			new_pattern = 'za';
		end
		
		// random delay.
		local delay = math.random( 0 , 400 ) * 0.01;
		
		// flicker the light on.
		ent:Fire( 'SetPattern' , new_pattern , delay );
		ent:Fire( 'TurnOn' , '' , delay );
		
		// delay the sound.
		timer.Simple( delay , function( ) ent:EmitSound( 'buttons/button1.wav' , math.random( 70 , 80 ) , math.random( 95 , 105 ) ) end );
		
		// delay for solid pattern.
		delay = delay + math.random( 10 , 50 ) * 0.01;
		
		// set solid pattern.
		ent:Fire( 'SetPattern' , 'z' , delay );
	end
	
	// loop through lights and turn um on.
	local light;
	for _ , light in pairs( self.nightlights ) do
		flicker( light.ent );
	end
end


// lights out!
function daylight:lightsOff( )
	// no lights?
	if ( !self.nightlights ) then return; end
	
	// loop through lights and turn um off.
	local light;
	for _ , light in pairs( self.nightlights ) do
		light.ent:Fire( 'TurnOff' , '' , 0 );
	end
end


// yarr... tis be where we hook thee hooks of the seven seas-- so says I...
hook.Add( 'InitPostEntity' , 'daylight:init' , function( ) daylight:init( ); end );
hook.Add( 'Think' , 'daylight:think' , function( ) daylight:think( ); end );
hook.Add( 'EntityKeyValue' , 'daylight:checkNightLight' , function( ent , key , val ) daylight:checkNightLight( ent , key , val ); end );
]]