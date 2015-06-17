#!Lua-5.0.exe
-- Take a Panose-1 string and display the signification in clear English.
-- by Philippe Lhoste <PhiLho(a)GMX.net> http: / /jove.prohosting.com / ~philho /
-- v. 0.2 -- 2004 / 09 / 28 -- Rewriting along the HP description
-- v. 0.1 -- 2004 / 09 / 27 -- Creation along the W3C description

--dofile[[_AsText_.lua]]

local panoseValue = "2 0 5 9 0 0 0 0 0 5"
--local panoseValue = "2 11 6 4 2 2 2 2 2 4" -- Arial
--local panoseValue = "2 2 6 3 5 4 5 2 3 4" -- Times
--local panoseValue = "2 3 6 0 0 1 1 1 1 1" -- bakbatn (corean?)
--local panoseValue = "2 11 6 2 3 5 4 2 2 4" -- cardSuits

local enPanoseFamily =
{
	[0] = "Any",
	[1] = "No Fit",
	[2] = "Latin Text",
	[3] = "Latin Hand Written",
	[4] = "Latin Decorative",
	[5] = "Latin Symbol",
}
local enPanoseNames =
{
	["Latin Text"] =
	{
		[1] = "Family",
		[2] = "Serif Style",
		[3] = "Weight",
		[4] = "Proportion",
		[5] = "Contrast",
		[6] = "Stroke Variation",
		[7] = "Arm Style",
		[8] = "Letterform",
		[9] = "Midline",
		[10] = "X-height",
	},
	["Latin Hand Written"] =
	{
		[1] = "Family",
		[2] = "Tool Kind",
		[3] = "Weight",
		[4] = "Spacing",
		[5] = "Aspect Ratio",
		[6] = "Contrast",
		[7] = "TopologyHW",
		[8] = "Form",
		[9] = "Finials",
		[10] = "X-ascent",
	},
	["Latin Decorative"] =
	{
		[1] = "Family",
		[2] = "Class",
		[3] = "Weight",
		[4] = "Aspect",
		[5] = "Contrast",
		[6] = "Serif Variant",
		[7] = "Treatment",
		[8] = "Lining",
		[9] = "TopologyD",
		[10] = "Range of Characters",
	},
	["Latin Symbol"] =
	{
		[1] = "Family",
		[2] = "Kind",
		[3] = "Weight",
		[4] = "Spacing",
		[5] = "Aspect Ratio & Contrast",
		[6] = "Aspect Ratio of Character 94",
		[7] = "Aspect Ratio of Character 119",
		[8] = "Aspect Ratio of Character 157",
		[9] = "Aspect Ratio of Character 163",
		[10] = "Aspect Ratio of Character 211",
	},
}
local enPanoseValues =
{
	["Family"] =
	{
		[0] = "Any",
		[1] = "No Fit",
		[2] = "Latin Text",
		[3] = "Latin Hand Written",
		[4] = "Latin Decorative",
		[5] = "Latin Symbol",
	},
	["Serif Style"] =
	{
		[0] = "Any",
		[1] = "No Fit",
		[2] = "Cove",
		[3] = "Obtuse Cove",
		[4] = "Square Cove",
		[5] = "Obtuse Square Cove",
		[6] = "Square",
		[7] = "Thin",
		[8] = "Oval",
		[9] = "Exaggerated",
		[10] = "Triangle",
		[11] = "Normal Sans",
		[12] = "Obtuse Sans",
		[13] = "Perpendicular Sans",
		[14] = "Flared",
		[15] = "Rounded",
		-- For Decorative fonts
		[16] = "Script",
	},
	["Weight"] =
	{
		[0] = "Any",
		[1] = "No Fit",
		[2] = "Very Light [100]",
		[3] = "Light [200]",
		[4] = "Thin [300]",
		[5] = "Book [400] same as CSS1 'normal'",
		[6] = "Medium [500]",
		[7] = "Demi [600]",
		[8] = "Bold [700] same as CSS1 'bold'",
		[9] = "Heavy [800]",
		[10] = "Black [900]",
		[11] = "Extra Black [900] force mapping to CSS1 100-900 scale",
	},
	["Proportion"] =
	{
		[0] = "Any",
		[1] = "No Fit",
		[2] = "Old Style",
		[3] = "Modern",
		[4] = "Even Width",
		[5] = "Extended",
		[6] = "Condensed",
		[7] = "Very Extended",
		[8] = "Very Condensed",
		[9] = "Monospaced",
	},
	["Contrast"] =
	{
		[0] = "Any",
		[1] = "No Fit",
		[2] = "None",
		[3] = "Very Low",
		[4] = "Low",
		[5] = "Medium Low",
		[6] = "Medium",
		[7] = "Medium High",
		[8] = "High",
		[9] = "Very High",
		-- For Decorative fonts
		[10] = "Horizontal Low",
		[11] = "Horizontal Medium",
		[12] = "Horizontal High",
		[13] = "Broken",
	},
	["Stroke Variation"] =
	{
		[0] = "Any",
		[1] = "No Fit",
		[2] = "No Variation",
		[3] = "Gradual / Diagonal",
		[4] = "Gradual / Transitional",
		[5] = "Gradual / Vertical",
		[6] = "Gradual / Horizontal",
		[7] = "Rapid / Vertical",
		[8] = "Rapid / Horizontal",
		[9] = "Instant / Horizontal",
		[10] = "Instant / Vertical",
	},
	["Arm Style"] =
	{
		[0] = "Any",
		[1] = "No Fit",
		[2] = "Straight Arms / Horizontal",
		[3] = "Straight Arms / Wedge",
		[4] = "Straight Arms / Vertical",
		[5] = "Straight Arms / Single Serif",
		[6] = "Straight Arms / Double Serif",
		[7] = "Non-Straight Arms / Horizontal",
		[8] = "Non-Straight Arms / Wedge",
        [9] = "Non-Straight Arms / Vertical",
		[10] = "Non-Straight Arms / Single Serif",
		[11] = "Non-Straight Arms / Double Serif",
	},
	["Letterform"] =
	{
		[0] = "Any",
		[1] = "No Fit",
		[2] = "Normal / Contact",
		[3] = "Normal / Weighted",
		[4] = "Normal / Boxed",
		[5] = "Normal / Flattened",
		[6] = "Normal / Rounded",
		[7] = "Normal / Off Center",
		[8] = "Normal / Square",
		[9] = "Oblique / Contact",
		[10] = "Oblique / Weighted",
		[11] = "Oblique / Boxed",
		[12] = "Oblique / Flattened",
		[13] = "Oblique / Rounded",
		[14] = "Oblique / Off Center",
		[15] = "Oblique / Square",
	},
	["Midline"] =
	{
		[0] = "Any",
		[1] = "No Fit",
		[2] = "Standard / Trimmed",
		[3] = "Standard / Pointed",
		[4] = "Standard / Serifed",
		[5] = "High / Trimmed",
		[6] = "High / Pointed",
		[7] = "High / Serifed",
		[8] = "Constant / Trimmed",
		[9] = "Constant / Pointed",
		[10] = "Constant / Serifed",
		[11] = "Low / Trimmed",
		[12] = "Low / Pointed",
		[13] = "Low / Serifed",
	},
	["X-height"] =
	{
		[0] = "Any",
		[1] = "No Fit",
		[2] = "Constant / Small",
		[3] = "Constant / Standard",
		[4] = "Constant / Large",
		[5] = "Ducking / Small",
		[6] = "Ducking / Standard",
		[7] = "Ducking / Large",
	},
	["Spacing"] =
	{
		[0] = "Any",
		[1] = "No Fit",
		[2] = "Proportional Spaced",
		[3] = "Monospaced",
	},
	["Aspect Ratio"] =
	{
		[0] = "Any",
		[1] = "No Fit",
		[2] = "Very Condensed",
		[3] = "Condensed",
		[4] = "Normal",
		[5] = "Expanded",
		[6] = "Very Expanded",
	},
	["TopologyHW"] =
	{
		[0] = "Any",
		[1] = "No Fit",
		[2] = "Roman Disconnected",
		[3] = "Roman Trailing",
		[4] = "Roman Connected",
		[5] = "Cursive Disconnected",
		[6] = "Cursive Trailing",
		[7] = "Cursive Connected",
		[8] = "Blackletter Disconnected",
		[9] = "Blackletter Trailing",
		[10] = "Blackletter Connected",
	},
	["Form"] =
	{
		[0] = "Any",
		[1] = "No Fit",
		[2] = "Upright / No Wrapping",
		[3] = "Upright / Some Wrapping",
		[4] = "Upright / More Wrapping",
		[5] = "Upright / Extreme Wrapping",
		[6] = "Oblique / No Wrapping",
		[7] = "Oblique / Some Wrapping",
		[8] = "Oblique / More Wrapping",
		[9] = "Oblique / Extreme Wrapping",
		[10] = "Exaggerated / No Wrapping",
		[11] = "Exaggerated / Some Wrapping",
		[12] = "Exaggerated / More Wrapping",
		[13] = "Exaggerated / Extreme Wrapping",
	},
	["Finials"] =
	{
		[0] = "Any",
		[1] = "No Fit",
		[2] = "None / No loops",
		[3] = "None / Closed loops",
		[4] = "None / Open loops",
		[5] = "Sharp / No loops",
		[6] = "Sharp / Closed loops",
		[7] = "Sharp / Open loops",
		[8] = "Tapered / No loops",
		[9] = "Tapered / Closed loops",
		[10] = "Tapered / Open loops",
		[11] = "Round / No loops",
		[12] = "Round / Closed loops",
		[13] = "Round / Open loops",
	},
	["X-ascent"] =
	{
		[0] = "Any",
		[1] = "No Fit",
		[2] = "Very Low",
		[3] = "Low",
		[4] = "Medium",
		[5] = "High",
		[6] = "Very High",
	},
	["Class"] =
	{
		[0] = "Any",
		[1] = "No Fit",
		[2] = "Derivative",
		[3] = "Non-standard Topology",
		[4] = "Non-standard Elements",
		[5] = " Non-standard Aspect",
		[6] = "Initials",
		[7] = "Cartoon",
		[8] = "Picture Stems",
		[9] = "Ornamented",
		[10] = "Text and Background",
		[11] = "Collage",
		[12] = "Montage",
	},
	["Treatment"] =
	{
		[0] = "Any",
		[1] = "No Fit",
		[2] = "None - Standard Solid Fill",
		[3] = "White / No Fill",
		[4] = "Patterned Fill",
		[5] = "Complex Fill",
		[6] = "Shaped Fill",
		[7] = "Drawn / Distressed",
	},
	["Lining"] =
	{
		[0] = "Any",
		[1] = "No Fit",
		[2] = "None",
		[3] = "Inline",
		[4] = "Outline",
		[5] = "Engraved (Multiple Lines)",
		[6] = "Shadow",
		[7] = "Relief",
		[8] = "Backdrop",
	},
	["TopologyD"] =
	{
		[0] = "Any",
		[1] = "No Fit",
		[2] = "Standard",
		[3] = "Square",
		[4] = "Multiple Segment",
		[5] = "Deco (E, M, S) Waco midlines",
		[6] = "Uneven Weighting",
		[7] = "Diverse Arms",
		[8] = "Diverse Forms",
		[9] = "Lombardic Forms",
		[10] = "Upper Case in Lower Case",
		[11] = "Implied Topology",
		[12] = "Horseshoe E and A",
		[13] = "Cursive",
		[14] = "Blackletter",
		[15] = "Swash Variance",
	},
	["Range of Characters"] =
	{
		[0] = "Any",
		[1] = "No Fit",
		[2] = "Extended Collection",
		[3] = "Litterals",
		[4] = "No Lower Case",
		[5] = "Small Caps",
	},
	["Kind"] =
	{
		[0] = "Any",
		[1] = "No Fit",
		[2] = "Montages",
		[3] = "Pictures",
		[4] = "Shapes",
		[5] = "Scientific",
		[6] = "Music",
		[7] = "Expert",
		[8] = "Patterns",
		[9] = "Boarders",
		[10] = "Icons",
		[11] = "Logos",
		[12] = "Industry specific",
	},
	["Aspect ratio of character"] =
	{
		[0] = "Any",
		[1] = "No Fit",
		[2] = "No Width",
		[3] = "Exceptionally Wide",
		[4] = "Super Wide",
		[5] = "Very Wide",
		[6] = "Wide",
		[7] = "Normal",
		[8] = "Narrow",
		[9] = "Very Narrow",
	},
}
enPanoseValues["Serif Variant"] = enPanoseValues["Serif Style"]

local frPanoseFamily =
{
	[0] = "Tous",
	[1] = "Pas de correspondance",
	[2] = "Texte latin",
	[3] = "Écriture manuscrite latine",
	[4] = "Décoratif latin",
	[5] = "Symbole latin",
}
local frPanoseNames =
{
	["Texte latin"] =
	{
		[1] = "Famille",
		[2] = "Style des empattements",
		[3] = "Graisse",
		[4] = "Proportion",
		[5] = "Contraste",
		[6] = "Variation du trait",
		[7] = "Style des branches",
		[8] = "Forme de la lettre",
		[9] = "Traits du milieu",
		[10] = "Hauteur-x",
	},
	["Écriture manuscrite latine"] =
	{
		[1] = "Family",
		[2] = "Tool Kind",
		[3] = "Weight",
		[4] = "Spacing",
		[5] = "Aspect Ratio",
		[6] = "Contrast",
		[7] = "TopologyHW",
		[8] = "Form",
		[9] = "Finials",
		[10] = "X-ascent",
	},
	["Décoratif latin"] =
	{
		[1] = "Family",
		[2] = "Class",
		[3] = "Weight",
		[4] = "Aspect",
		[5] = "Contrast",
		[6] = "Serif Variant",
		[7] = "Treatment",
		[8] = "Lining",
		[9] = "TopologyD",
		[10] = "Range of Characters",
	},
	["Symbole latin"] =
	{
		[1] = "Family",
		[2] = "Kind",
		[3] = "Weight",
		[4] = "Spacing",
		[5] = "Aspect Ratio & Contrast",
		[6] = "Aspect Ratio of Character 94",
		[7] = "Aspect Ratio of Character 119",
		[8] = "Aspect Ratio of Character 157",
		[9] = "Aspect Ratio of Character 163",
		[10] = "Aspect Ratio of Character 211",
	},
}
local frPanoseValues =
{
	["Famille"] =
	{
		[0] = "Tous",
		[1] = "Pas de correspondance",
		[2] = "Texte latin",
		[3] = "Écriture manuscrite latine",
		[4] = "Décoratif latin",
		[5] = "Symbole latin",
	},
	["Style des empattements"] =
	{
		[0] = "Tous",
		[1] = "Pas de correspondance",
		[2] = "Anse",
		[3] = "Anse obtuse",
		[4] = "Anse carrée",
		[5] = "Anse obtuse carrée",
		[6] = "Carré",
		[7] = "Mince",
		[8] = "Arête",
		[9] = "Exagérée",
		[10] = "Triangulaire",
		[11] = "Normal Sans",
		[12] = "Obtus Sans",
		[13] = "Perpendiculaire Sans",
		[14] = "Évasé",
		[15] = "Arrondi",
	},
	["Graisse"] =
	{
		[0] = "Tous",
		[1] = "Pas de correspondance",
		[2] = "Very Light [100]",
		[3] = "Light [200]",
		[4] = "Thin [300]",
		[5] = "Book [400] même chose que 'normal;' en CSS1",
		[6] = "Medium [500]",
		[7] = "Demi [600]",
		[8] = "Bold [700] même chose que 'bold;' en CSS1",
		[9] = "Heavy [800]",
		[10] = "Black [900]",
		[11] = "Extra Black [900] force dans l'échelle 100-900 de CSS1",
	},
	["Proportion"] =
	{
		[0] = "Tous",
		[1] = "Pas de correspondance",
		[2] = "Ancienne mode",
		[3] = "Moderne",
		[4] = "Largeur égalisée",
		[5] = "Élargie",
		[6] = "Étroite",
		[7] = "Très élargie",
		[8] = "Très étroite",
		[9] = "Chasse fixe",
	},
	["Contraste"] =
	{
		[0] = "Tous",
		[1] = "Pas de correspondance",
		[2] = "Aucun",
		[3] = "Très faible",
		[4] = "Faible",
		[5] = "Moyen faible",
		[6] = "Moyen",
		[7] = "Moyen grand",
		[8] = "Grand",
		[9] = "Très grand",
	},
	["Variation du trait"] =
	{
		[0] = "Tous",
		[1] = "Pas de correspondance",
		[2] = "Aucune variation",
		[3] = "Graduelle / Diagonale",
		[4] = "Graduelle / Transitionnelle",
		[5] = "Graduelle / Verticale",
		[6] = "Graduelle / Horizontale",
		[7] = "Rapide / Verticale",
		[8] = "Rapide / Horizontale",
		[9] = "Instantanée / Horizontale",
		[10] = "Instantanée / Verticale",
	},
	["Style des branches"] =
	{
		[0] = "Tous",
		[1] = "Pas de correspondance",
		[2] = "Branches droites / Horizontal",
		[3] = "Branches droites / Calé",
		[4] = "Branches droites / Vertical",
		[5] = "Branches droites / Empattement simple",
		[6] = "Branches droites / Empattement double",
		[7] = "Branches non droites / Horizontal",
		[8] = "Branches non droites / Calé",
		[9] = "Branches non droites / Vertical",
		[10] = "Branches non droites / Empattement simple",
		[11] = "Branches non droites / Empattement double",
	},
	["Forme de la lettre"] =
	{
		[0] = "Tous",
		[1] = "Pas de correspondance",
		[2] = "Normale / Touchante",
		[3] = "Normale / Équilibrée",
		[4] = "Normale / Encadrée",
		[5] = "Normale / Aplatie",
		[6] = "Normale / Arrondie",
		[7] = "Normale / Décentrée",
		[8] = "Normale / Carrée",
		[9] = "Oblique / Touchante",
		[10] = "Oblique / Équilibrée",
		[11] = "Oblique / Encadrée",
		[12] = "Oblique / Aplatie",
		[13] = "Oblique / Arrondie",
		[14] = "Oblique / Décentrée",
		[15] = "Oblique / Carrée",
	},
	["Traits du milieu"] =
	{
		[0] = "Tous",
		[1] = "Pas de correspondance",
		[2] = "Standard / Coupé",
		[3] = "Standard / Pointu",
		[4] = "Standard / Empattement",
		[5] = "Haut / Coupé",
		[6] = "Haut / Pointu",
		[7] = "Haut / Empattement",
		[8] = "Constant / Coupé",
		[9] = "Constant / Pointu",
		[10] = "Constant / Empattement",
		[11] = "Bas / Coupé",
		[12] = "Bas / Pointu",
		[13] = "Bas / Empattement",
	},
	["Hauteur-x"] =
	{
		[0] = "Tous",
		[1] = "Pas de correspondance",
		[2] = "Constante / Petite",
		[3] = "Constante / Standard",
		[4] = "Constante / Grande",
		[5] = "Plongeante / Petite",
		[6] = "Plongeante / Standard",
		[7] = "Plongeante / Grande",
	},
}

function printf(...)
	print(string.format(unpack(arg)))
end

local i = 0
local familyE, familyF
print('panose-1="' .. panoseValue .. '"')
for n in string.gfind(panoseValue, "([%d]+)") do
	i = i + 1
	if i > 10 then
		print"Incorrect Panose-1 string, too much numbers!"
		return
	end

	local nn = tonumber(n)
	local tNamesE, tNameF, tValE, tValF, valueE, valueF

	if i == 1 then	-- Family
		familyE = enPanoseFamily[nn]
		familyF = frPanoseFamily[nn]
		if nn == 0 or nn == 1 then
			printf("(%s) Family: %s --- Famille : %s", n, familyE, familyF)
			return
		end
	end

	if nn ~= 0 then
		tNamesE = enPanoseNames[familyE]
		nameE = tNamesE[i]
		tValE = enPanoseValues[nameE]
		valueE = tValE[nn]
		if valueE == nil then valueE = "[Invalid Value: " .. nn .. "]" end

		tNamesF = frPanoseNames[familyF]
		nameF = tNamesF[i]
		tValF = frPanoseValues[nameF]
		valueF = tValF[nn]
		if valueF == nil then valueF = "[Valeur incorrecte : " .. nn .. "]" end

		printf("(%s) %s : %s --- %s : %s", n, nameE, valueE, nameF, valueF)
	end
end
