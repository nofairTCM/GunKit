local module = {}

local import;
function module:setRender(newRender)
    import = newRender.import;
    return module;
end

return module
