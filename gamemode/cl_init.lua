RunConsoleCommand("gm_clearfonts")

include( 'shared.lua' )
include( 'sh_resource' )

function GM:Initialize()
	if !file.Exists("models/props_foliage/tree_pine_large.mdl", true) then
		CIVRP_Enviorment_Models = {}
		CIVRP_Enviorment_Models[1] = 	{ID = 1, Model = "models/props_foliage/tree_deciduous_01a.mdl", Solid = true, Generated = true}
		CIVRP_Enviorment_Models[2] = 	{ID = 2, Model =  "models/props_foliage/tree_deciduous_02a.mdl", Solid = true, Generated = true}
		CIVRP_Enviorment_Models[3] = 	{ID = 3, Model = "models/props_foliage/tree_deciduous_02a.mdl", Solid = true, Generated = true}
		CIVRP_Enviorment_Models[4] = 	{ID = 4, Model = "models/props_foliage/tree_deciduous_01a.mdl", Solid = true, Generated = true}
		CIVRP_Enviorment_Models[5] = 	{ID = 5, Model = "models/props_foliage/tree_deciduous_01a.mdl", Solid = true, Generated = true}
		CIVRP_Enviorment_Models[6] = 	{ID = 6, Model = "models/props_foliage/tree_deciduous_01a.mdl", Solid = true, Generated = true}
		CIVRP_Enviorment_Models[7] = 	{ID = 7, Model = "models/props_foliage/tree_deciduous_01a.mdl", Solid = true, Generated = true}
		CIVRP_Enviorment_Models[8] = 	{ID = 8, Model = "models/props_foliage/tree_deciduous_02a.mdl", Solid = true, Generated = true}
		CIVRP_Enviorment_Models[9] = 	{ID = 9, Model = "models/props_foliage/tree_deciduous_02a.mdl", Solid = true, Generated = true}
		CIVRP_Enviorment_Models[10] = 	{ID = 10, Model = "models/props_foliage/tree_deciduous_02a.mdl", Solid = true, Generated = true}
		CIVRP_Enviorment_Models[11] = 	{ID = 11, Model = "models/props_foliage/cattails.mdl", Solid = false, Generated = false}
		CIVRP_Enviorment_Models[12] = 	{ID = 12, Model = "models/props_foliage/cattails.mdl", Solid = false, Generated = false}
		CIVRP_Enviorment_Models[13] = 	{ID = 13, Model = "models/props_foliage/cattails.mdl", Solid = false, Generated = false}
		CIVRP_Enviorment_Models[14] = 	{ID = 14, Model = "models/props_foliage/oak_tree01.mdl", Solid = true, Generated = true}
		CIVRP_Enviorment_Models[15] =	{ID = 15, Model = "models/props_canal/rock_riverbed02a.mdl", Solid = true}
	end
end