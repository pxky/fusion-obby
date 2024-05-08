return {
	Name = script.Name,
	Aliases = { "ss" },
	Description = "Sets a player's stage.",
	Group = "Admin",
	Args = {
		{
			Type = "player",
			Name = "player",
			Description = "The player to change stage",
		},
		{
			Type = "number",
			Name = "stage",
			Description = "The stage to set the player to",
		},
	},
}
