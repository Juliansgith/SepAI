local BaseAIBrain = import("/lua/aibrains/base-ai.lua").AIBrain

-- Custom AI modules
local BaseTemplates = import('/mods/SepAI/lua/AI/AIBaseTemplates/BaseTemplates.lua')
local Builders = import('/mods/SepAI/lua/AI/AIBuilders/SepAIEarlySetup.lua')
local PlatoonTemplates = import('/mods/SepAI/lua/AI/platoontemplates/sepaiplatoontemplates.lua')
local SepAI_Map = import('/mods/SepAI/lua/AI/SepAIMap.lua')

-- Extending the base AI brain with custom behaviors
NewAIBrain = Class(BaseAIBrain) {
    OnBeginSession = function(self)
        BaseAIBrain.OnBeginSession(self)
    end,

    OnDefeat = function(self)
        BaseAIBrain.OnDefeat(self)
    end,
    -- Initialization function for AI
    OnCreateAI = function(self, planName)
        BaseAIBrain.OnCreateAI(self, planName)  -- Calling the superclass's method with planName
        LOG('SepAI: OnCreateAI Initialization started')
        self.SepAI = true

        -- Initialize AI base templates and builders
        self.BaseTemplates = BaseTemplates
        self.Builders = Builders
        self.PlatoonTemplates = PlatoonTemplates

        if not BaseTemplates then
            LOG('ERROR: SepAI base templates not loaded correctly')
            return
        end
        -- Map setup for initial map awareness
        ForkThread(SepAI_Map.SetupMap, self)

        -- Additional custom setup can go here
        self:InitCustomAI()
        LOG('SepAI: OnCreateAI Initialization completed')
    end,

    -- Custom initialization for specific strategies or adjustments
    InitCustomAI = function(self)
        LOG('SepAI: InitCustomAI started')
        -- Set up economic parameters or initial strategies that influence early game builders
        self.EconomicStatus = {
            EnergyEfficiency = 1.0,
            MassEfficiency = 1.0,
        }

        -- You can set initial flags or state variables here
        self.InitialSetupDone = false  -- A flag to track if the initial setup phase is complete
        LOG('SepAI: Initial custom AI setup completed')
    end,

    -- Unified Decide what the AI should do next
    DecideWhatToDo = function(self)
        LOG('SepAI: DecideWhatToDo called')
        if not self.InitialSetupDone then
            -- Check if early game setup conditions are met
            if self:CheckEarlyGameSetupCompletion() then
                self.InitialSetupDone = true
                LOG('SepAI: Initial setup completed, transitioning to standard growth')
                -- Adjust strategies or resource allocations based on early setup completion
                self:SetResourceAllocation('StandardGrowth')
            end
        else
            -- Continue with regular decision making
            self:EvaluateStrategicPosition()
            LOG('SepAI: Regular strategic evaluation in progress')
            -- Custom logic for deciding next actions based on current game state
            -- This is where you can add checks for aggression levels, defense needs, etc.
        end
    end,

    -- Function to set resource allocation strategies
    SetResourceAllocation = function(self, mode)
        LOG('SepAI: SetResourceAllocation called with mode: ' .. tostring(mode))
        if mode == 'EarlyGameFocus' then
            -- Increase emphasis on energy and mass collection efficiency
            self:AdjustEconomicParameters({
                MassCollectionEfficiency = 1.2,
                EnergyCollectionEfficiency = 1.2
            })
        elseif mode == 'StandardGrowth' then
            -- Balance all resources towards a more rounded growth
            self:AdjustEconomicParameters({
                MassCollectionEfficiency = 1.0,
                EnergyCollectionEfficiency = 1.0
            })
        end
    end,

    -- Function to check if early game setup is completed
    CheckEarlyGameSetupCompletion = function(self)
        LOG('SepAI: Checking early game setup completion')
        -- Example: check if certain number of resource units are built
        local massExtractors = self:GetUnitCount(categories.MASSEXTRACTION)
        local energyProduction = self:GetUnitCount(categories.ENERGYPRODUCTION)
        return massExtractors >= 8 and energyProduction >= 8
    end,
}

-- Ensure the AI is listed in the AI manager
function AddSepAI()
    local aitypes = import('/lua/ui/lobby/aitypes.lua').aitypes
    table.insert(aitypes, {'sepstandard', 'Standard SepAI'})
    LOG('SepAI: AI type added to AI manager')
end

AddSepAI()
