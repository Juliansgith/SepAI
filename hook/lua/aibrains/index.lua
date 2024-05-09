local SepAIBrain = import('/mods/SepAI/lua/AI/SepAIBrain.lua')
LOG('Index: Loading Custom AI Brain')
keyToBrain = keyToBrain or { }
keyToBrain['sepstandard'] = SepAIBrain.NewAIBrain 