local module = {};

function module:setup()
    return self;
end

-- setup gun server from tool
-- this function is make client side-server side binding

local bindObj = game:GetService("ReplicatedStorage")
    :WaitForChild("qGunClient")
    :WaitForChild("callServer");

local guns = {};

local function serverCall(tool,functionName,...)
    local self = guns[tool].serverCall
    return self[functionName](self,...);
    -- 주의할껀 이건 내부에 함수를 클라로 모두 노출시키기 때문에
    -- 여기다 중요한거 넣어두면 치명적임
    -- 보안 주의!!!!!!!!!!!

    -- this is allow to call server's function on client
end
bindObj.OnServerInvoke = serverCall;

local gunMt = {}; -- class server
gunMt.__index = gunMt;

-- fire / 총을 발사함 (데미지를 입히고, 다른 사람 눈에 보이도록 다른 클라이언트 부르고 등등)
function gunMt:fire()
    local ammo = self.ammo;

    if not ammo == 0 then -- 총알이 없어서 쏠 수가 없음; no ammo for fire
        return;
    end

    self.ammo = ammo - 1;
end

-- reload
function gunMt:reload()
    
end

-- 이 부분에서 클라이언트로 노출시킬 함수를 지정함; allow to client to call server function
gunMt.serverCall = {
    fire = gunMt.fire;
    reload = gunMt.reload;
};

function module:setGun(data)
    local data = data or {};
    local tool = data.tool;
    local settings = data.settings;

    guns[data.tool] = data;
end

-- 클라이언트로 이벤트를 흘려주고, 기본 서버 셋팅을 여기서 시작함
-- 건들였다 어떻게 되면 나도 모름
function module.init()

end

return module
