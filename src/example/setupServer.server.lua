--- SETUP
local tool = script.Parent;

local server = require(game:WaitForChild("ServerStorage"):WaitForChild("qGunServer"));
local this = server:setup():setGun {
    tool = tool;
    settings = require(tool.settings);
};

--- BIND EVENT
-- setupClient 에 설명을 확인해주세요 (이건 이제 서버에서 작동하는 부분)

-- 웹훅 사용시 주의사항
-- 웹훅이 필요하시면 ServerStorage 에 모듈을 만들고 requrie 해와서 쓰는 방식을 쓰세요
-- 그렇게 하지 않고 여기에 바로 웹훅을 집어넣으면 웹훅 아이디가 노출될 수 있으며
-- 다른이가 사용할 수 있게 됩니다
this:bind("kill",function(thisPlayer,killedHumanoidObj,killedPlayer)
    
end);

this:bind("fire",function(thisPlayer,firePos,hitPos,hitObj,hitHumanoid,hitPlayer)
    
end);
