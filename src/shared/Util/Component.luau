local CollectionService = game:GetService("CollectionService")

local Component = {}
local CachedInstances = {}

type component_code = {
    Tag: string,
    New: (instance: Instance) -> {},
}

function Component.LoadCode(code: component_code)
    local function instance_added(instance: Instance)
        CachedInstances[instance] = CachedInstances[instance] or {}
        local new_component = code.New(instance)
        CachedInstances[instance][code.Tag] = new_component
    end

    local function instance_removed(instance: Instance)
        for i, Component in pairs(CachedInstances[instance]) do
            if Component.Destroy then
                Component:Destroy()
            end
            Component[i] = nil
        end
    end

    for _, existing in CollectionService:GetTagged(code.Tag) do
        instance_added(existing)
    end
    CollectionService:GetInstanceAddedSignal(code.Tag):Connect(instance_added)
    CollectionService:GetInstanceRemovedSignal(code.Tag):Connect(instance_removed)
end

return Component
