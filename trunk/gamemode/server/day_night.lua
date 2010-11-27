--[[function GM:InitPostEntity() 
	table.Random(ents.FindByName('daynight_brush')):Remove()
end]]

CIVRP_WorldData = {}
CIVRP_WorldData.Time = 449
CIVRP_WorldData.CurStage = 0
CIVRP_WorldData.DayLength = 3600
CIVRP_WorldData.Dawn = {Start = CIVRP_WorldData.DayLength/8,End = CIVRP_WorldData.DayLength/3,}
CIVRP_WorldData.Dusk = {Start = CIVRP_WorldData.DayLength*(2/3),End = CIVRP_WorldData.DayLength*(7/8),}
CIVRP_WorldData.NextTime = 0
CIVRP_WorldData.TimeNextSecond = 0 
CIVRP_WorldData.DarknessHigh = 245
CIVRP_WorldData.Interval = 1
CIVRP_WorldData.DayNight = false

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
		CIVRP_WorldData.GlobalLight = table.Random(ents.FindByClass( 'light_environment' ));

		CIVRP_WorldData.SkyBox = table.Random(ents.FindByName('daynight_brush'))
		CIVRP_WorldData.Sun = table.Random(ents.FindByClass( 'env_sun' ))
		CIVRP_WorldData.Sun:SetKeyValue( 'material' , 'sprites/light_glow02_add_noz.vmt' );
		CIVRP_WorldData.Sun:SetKeyValue( 'overlaymaterial' , 'sprites/light_glow02_add_noz.vmt' );
	
		CIVRP_WorldData.GlobalLight:Fire("SetPattern",'a',0) 
		CIVRP_WorldData.GlobalLight:Activate()
		CIVRP_WorldData.DayNight = true
	end
end

function CIVRP_DayNightThink( ) 
	if !CIVRP_WorldData.DayNight then return false end
	if CIVRP_WorldData.TimeNextSecond <= CurTime() then
		CIVRP_WorldData.Time = CIVRP_WorldData.Time + CIVRP_WorldData.Interval
		local col = {r = 0,b = 0,g = 0,a = 0}
		if IsDay() then
			CIVRP_WorldData.GlobalLight:Fire("TurnOn",'',0)		
			col.a = 0 
			if IsDawn() then	
				col.a = math.Clamp((CIVRP_WorldData.DarknessHigh-(CIVRP_WorldData.DarknessHigh/((CIVRP_WorldData.Dawn.End - CIVRP_WorldData.Dawn.Start)/(CIVRP_WorldData.Time-CIVRP_WorldData.Dawn.Start)))),0,255)	
				if CIVRP_WorldData.Time <= CIVRP_WorldData.Dawn.Start + (CIVRP_WorldData.Dawn.End-CIVRP_WorldData.Dawn.Start)/4 then
					col.r = math.Clamp(((35/(((CIVRP_WorldData.Dawn.End-CIVRP_WorldData.Dawn.Start)/4)/(CIVRP_WorldData.Time-CIVRP_WorldData.Dawn.Start)))),0,255)
				else
					col.r = math.Clamp((35-(35/(((CIVRP_WorldData.Dawn.End-CIVRP_WorldData.Dawn.Start)/2)/(CIVRP_WorldData.Time-(CIVRP_WorldData.Dawn.Start + (CIVRP_WorldData.Dawn.End-CIVRP_WorldData.Dawn.Start)/4))))),0,255)
				end
			elseif IsDusk() then
				col.a = math.Clamp(((CIVRP_WorldData.DarknessHigh/((CIVRP_WorldData.Dusk.End - CIVRP_WorldData.Dusk.Start)/(CIVRP_WorldData.Time-CIVRP_WorldData.Dusk.Start)))),0,255)
				if CIVRP_WorldData.Time <= CIVRP_WorldData.Dusk.Start + (CIVRP_WorldData.Dusk.End-CIVRP_WorldData.Dusk.Start)/4 then
					col.r = math.Clamp(((70/(((CIVRP_WorldData.Dusk.End-CIVRP_WorldData.Dusk.Start)/4)/(CIVRP_WorldData.Time-CIVRP_WorldData.Dusk.Start)))),0,255)
				else
					col.r = math.Clamp((70-(70/(((CIVRP_WorldData.Dusk.End-CIVRP_WorldData.Dusk.Start)/2)/(CIVRP_WorldData.Time-(CIVRP_WorldData.Dusk.Start + (CIVRP_WorldData.Dusk.End-CIVRP_WorldData.Dusk.Start)/2))))),0,255)
				end
			end
		else
			CIVRP_WorldData.GlobalLight:Fire("TurnOff",'',0) 
			col.a = CIVRP_WorldData.DarknessHigh
		end	
		
		if CIVRP_WorldData.Time > CIVRP_WorldData.DayLength || CIVRP_WorldData.Time < 0 then
			CIVRP_WorldData.Time = 0
		end
		CIVRP_WorldData.TimeNextSecond = CurTime() + CIVRP_WorldData.Interval 
		
		CIVRP_WorldData.Sun:Fire( 'addoutput' , 'pitch '..tostring(360*(CIVRP_WorldData.Time/CIVRP_WorldData.DayLength)-235) , 0 );
		CIVRP_WorldData.Sun:Activate( );
		
		CIVRP_WorldData.SkyBox:Fire('Color',""..col.r.." "..col.g.." "..col.b,0)
		CIVRP_WorldData.SkyBox:Fire( 'Alpha',col.a,0)
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