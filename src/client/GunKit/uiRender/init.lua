local module = {};

local render = require(script.render);
local thisPlayer = game:GetService("Players").LocalPlayer;

local hudRender = require(script.hudRender);
hudRender:setRender(render);

function module.init()
    local uiHolder = Instance.new("ScreenGui");
    uiHolder.Name = "qGunGUI";
    uiHolder.ResetOnSpawn = false;
    uiHolder.Parent = thisPlayer.PlayerGui;

    local hud = hudRender.init();
    hud.updateParent(uiHolder);
    hud.updateVisible(false);

    return {
        ["uiHolder"] = uiHolder;
        ["hud"] = hud;
    };
end

return module;
