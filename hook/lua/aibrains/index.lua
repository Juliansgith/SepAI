local SepAIBrain = import('/mods/SepAI/lua/brain/brain.lua')

keyToBrain = keyToBrain or {}
keyToBrain["sepai"] = SepAIBrain.NewAIBrain 
keyToBrain["sepaicheat"] = SepAIBrain.NewAIBrain 
