local OldAITypes = import('/lua/ui/lobby/aitypes.lua').aitypes

local NewAITypes = table.deepcopy(OldAITypes)

table.insert(NewAITypes, {
    key = 'sepai',  
    name = '<LOC sepai_0000>SepAI',  
    tooltip = 'lobui_0121',  
    sort = 101,  
    default = false,
})

aitypes = NewAITypes
