LOG('Loading SepAI custom AI brain...')

local OriginalAIBrain = AIBrain

local NewAIBrainFunctions = import('/mods/SepAI/lua/AI/brain.lua')

AIBrain = Class(OriginalAIBrain) {
    OnCreateAI = function(self, brainName)
        LOG('SepAI: OnCreateAI called for brain: ' .. tostring(brainName))
        
        OriginalAIBrain.OnCreateAI(self, brainName)

        local personality = ScenarioInfo.ArmySetup[self.Name].AIPersonality
        if string.find(personality, 'sepai') then
            self.SepAI = true
            LOG('SepAI: SepAI is active for brain: ' .. tostring(brainName))
        end

        if self.SepAI and self.InitCustomBrainFunctions then
            LOG('SepAI: Initializing custom brain functions for brain: ' .. tostring(brainName))
            self:InitCustomBrainFunctions()
        elseif not self.SepAI then
            LOG('SepAI: Current AI is not SepAI, skipping custom initializations.')
        end
    end,

    InitCustomBrainFunctions = function(self)
        LOG('SepAI: Inside InitCustomBrainFunctions...')

        if NewAIBrainFunctions and NewAIBrainFunctions.SetupCustomBrain then
            NewAIBrainFunctions.SetupCustomBrain(self)
            LOG('SepAI: Custom AI Brain functionality initialized for ' .. self:GetArmyIndex())
        else
            LOG('SepAI: SetupCustomBrain function not found, check your brain.lua for errors.')
        end
    end,
}

LOG('SepAI custom AI brain overrides loaded successfully.')
