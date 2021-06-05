local module = {};
local userInput = game:GetService("UserInputService");
local run = game:GetService("RunService");
local tween = game:GetService("TweenService");
local players = game:GetService("Players");
local uiRender = require(script.uiRender);
local cwait = require(script.cwait);
local clock = os.clock;
local warn = warn or print;

local defaultWalkSpeed = 16;

local thisPlayer;
local ui;
local mouse;
local character;
local humanoid;
local equipped;
local ammoHolder;
local rayCastIgnore;
local rayCastParams;

local lastMouseConnection;
local lastFireTime = 0;

--- 리로드를 요청합니다
local reloadStatus = false; -- 리로드중인가를 나타냄
local function requestReload()
    if not equipped then
        return;
    end

    equipped:reload();
end

--- 리로드 상태를 지정합니다, 중간에 false 쓰면 캔슬됨, init 에 의해 실행되는 비공개 함수
---@param isReloading boolean
local function setReloading(isReloading)
    reloadStatus = isReloading;
    if isReloading then
        requestReload();
    end
end

--- 발사를 요청합니다, 시간을 확인해서 발사시간을 맞춰줍니다
local function requestFire()
    local time = clock();
    if lastFireTime > time then
        return;
    elseif not equipped then
        return;
    end

    equipped:fire(time);
end

--- 마우스 클릭 상태를 지정합니다, init 에 의해 실행되는 비공개 함수
---@param isDown boolean
local function setMouseDown(isDown)
    if lastMouseConnection then
        lastMouseConnection:Disconnect();
        lastMouseConnection = nil;
    end

    if (not isDown) or (not equipped) then
        return;
    end

    if equipped.ammo <= 0 then -- 총알이 없으면 리로드 호출
        setReloading(true);
        return;
    elseif reloadStatus then -- 리로드 중이면 멈춤
        setReloading(false);
    end

    lastMouseConnection = run.Stepped:Connect(requestFire);
end

--- 달리는중인 상태를 지정합니다, init 에 의해 실행되는 비공개 함수
---@param isRunning boolean
local function setRunning(isRunning)
    if not equipped then
        return;
    end

    equipped:setRunning(isRunning);
end

--- 달리는 키를 누름
local function keyDown_Fire()
    setMouseDown(true);
    setRunning(false);
end
local function keyUp_Fire() -- 땜
    setMouseDown(false);
end

--- 리로드 키를 누름
local function keyDown_Reload()
    setReloading(true);
    setMouseDown(false);
    setRunning(false);
end

--- 달리기 키를 누름
local function keyDown_Run()
    setRunning(true);
    setReloading(false);
    setMouseDown(false);
end
local function keyUp_Run() -- 땜
    setRunning(false);
end

local random = math.random;
--- -1 이나 1 을 반환합니다, 방향을 두개로 나누는 경우 유용하게 사용됩니다
---@return integer
local function randomSign()
    return random(0,1) == 0 and -1 or 1;
end

--- 테이블로부터 아이템을 찾고 찾은경우 해당하는 인덱스를 반환합니다
---@param table table
---@param item any
---@return any
local function tableFind(table,item)
    for i,v in pairs(table) do
        if v == item then
            return i;
        end
    end
    return nil;
end

local hitPartTweenInfo = TweenInfo.new(
    1.6,
    Enum.EasingStyle.Quad,
    Enum.EasingDirection.Out,
    0,false,0
);
local tailPartTweenInfo = TweenInfo.new(
    1,
    Enum.EasingStyle.Quad,
    Enum.EasingDirection.Out,
    0,false,0
);
local meshTweenInfo = TweenInfo.new(
    0.9,
    Enum.EasingStyle.Quad,
    Enum.EasingDirection.Out,
    0,false,0
);
--- 날라가는 총알을 그립니다
---@param FirePos number 날리는 위치
---@param HitPos number 맞은 위치
---@param data table 총 데이터
local function drawBullet(FirePos,HitPos,data)
    local color = data.Color

    local hitPart = Instance.new("Part");
    hitPart.Anchored = true;
    hitPart.Position = HitPos;
    hitPart.Size = Vector3.new(1,1,1);
    hitPart.CanCollide = false;
    hitPart.Color = color;
    hitPart.Parent = ammoHolder;
    hitPart.Transparency = 0.55;
    hitPart.BottomSurface = Enum.SurfaceType.Smooth
    hitPart.TopSurface = Enum.SurfaceType.Smooth

    local PartCFrame = CFrame.new(FirePos,HitPos) - FirePos + FirePos:Lerp(HitPos,0.5); -- 파트의 CFrame 을 구함

    local tailPart = Instance.new("Part"); -- 파트를 만듬
    tailPart.Anchored = true;
    tailPart.Size = Vector3.new(1,1,1);
    tailPart.CFrame = PartCFrame;
    tailPart.CanCollide = false;
    tailPart.Color = color;
    tailPart.Parent = ammoHolder;
    tailPart.Transparency = 0.55;
    tailPart.BottomSurface = Enum.SurfaceType.Smooth
    tailPart.TopSurface = Enum.SurfaceType.Smooth

    local meshScale = (HitPos - FirePos).Magnitude
    local mesh = Instance.new("BlockMesh",tailPart); -- 파트 크기제한을 뛰어넘을 수 있도록 메시 사용
    mesh.Scale = Vector3.new(0.4,0.4,meshScale);

    local hitPartTween = tween:Create(hitPart,hitPartTweenInfo,{
        Transparency = 1;
    });
    hitPartTween:Play();

    local tailPartTween = tween:Create(tailPart,tailPartTweenInfo,{
        Transparency = 1;
        CFrame = PartCFrame * CFrame.Angles(0.001 * randomSign(),0.001 * randomSign(),1 * randomSign());
    });
    tailPartTween:Play();

    local meshTween = tween:Create(mesh,meshTweenInfo,{
        Scale = Vector3.new(0.26,0.26,meshScale);
    });
    meshTween:Play();

    delay(1.8,function()
        tailPart:Destroy();
        hitPart:Destroy();
        hitPartTween:Destroy();
        tailPartTween:Destroy();
        meshTween:Destroy();
    end);
end

--- 모듈을 초기화하여 모듈을 준비시킵니다
function module.init()
    thisPlayer = players.LocalPlayer;
    mouse = thisPlayer:GetMouse();
    ui = uiRender.init();

    ammoHolder = Instance.new("Folder",Workspace);
    ammoHolder.Name = "qGun_ammoHolder";

    rayCastParams = RaycastParams.new()
    rayCastIgnore = {ammoHolder};
    rayCastParams.FilterDescendantsInstances = rayCastIgnore;
    rayCastParams.FilterType = Enum.RaycastFilterType.Blacklist;

    local function characterUpdate(this)
        if not this then
            return;
        end
        table.insert(rayCastIgnore,this);
        rayCastParams.FilterDescendantsInstances = rayCastIgnore;
        character = this;
        humanoid = this:WaitForChild("Humanoid");

        local function update()
            ui.hud.updateHealthPercent(humanoid.Health / humanoid.MaxHealth);
        end
        update();
        humanoid:GetPropertyChangedSignal("Health"):Connect(update);
    end
    characterUpdate(thisPlayer.Character);
    thisPlayer.CharacterAdded:Connect(characterUpdate);

    userInput.InputBegan:Connect(function (input, gameProcessed)
        if gameProcessed then
            return;
        end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            keyDown_Fire();
        elseif input.KeyCode == Enum.KeyCode.LeftShift then
            keyDown_Run();
        elseif input.KeyCode == Enum.KeyCode.R then
            keyDown_Reload();
        end
    end);
    userInput.InputEnded:Connect(function (input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            keyUp_Fire();
        elseif input.KeyCode == Enum.KeyCode.LeftShift then
            keyUp_Run();
        --elseif input.KeyCode == Enum.KeyCode.R then
        --    keyUp_Reload();
        end
    end);
end

-- CLASS:gun
local gunClassMt = {};
gunClassMt.__index = gunClassMt;

--- 총을 발사시킵니다, 마우스 위치를 이용해 계산을 시도하고 ui 를 업데이트하기를 시도합니다
---@param time number time that fire is started
function gunClassMt:fire(time)
    -- 총알이 없음
    if self.ammo <= 0 then
        setMouseDown(false);
        return;
    end

    local settings = self.settings;
    lastFireTime = time + settings.FireLate;

    local FirePos = self.tool.Handle.FirePos.WorldPosition;

    local SpreadMax = settings.SpreadMax;
    local SpreadMin = settings.SpreadMin;
    local SpreadUnit = settings.SpreadUnit;

    local SpreadX = random(SpreadMin,SpreadMax) * SpreadUnit * randomSign();
    local SpreadY = random(SpreadMin,SpreadMax) * SpreadUnit * randomSign();

    -- 머리위치,마우스위치 두개로 총알이 날라가야할 방향을 만들고 탄퍼짐 적용후 바라보는 방향으로 변환후 최대 거리를 곱함
    local LastTargetFilter = mouse.TargetFilter;
    mouse.TargetFilter = ammoHolder
    local lookAt = ((
        CFrame.new(FirePos,mouse.Hit.Position)
        * CFrame.Angles(math.rad(SpreadX),math.rad(SpreadY),0)
    ).LookVector * settings.MaxRange);
    mouse.TargetFilter = LastTargetFilter;

    local RaycastResult = workspace:Raycast(FirePos,lookAt,rayCastParams); -- ray 를 쏨
    local HitPos,hitPart,hitMaterial;
    if RaycastResult then
        HitPos = RaycastResult.Position; -- 부딧힌 위치
        hitPart = RaycastResult.Instance;
        hitMaterial = RaycastResult.Material;
    else
        HitPos = FirePos + lookAt;
    end

    local hitPartParent = hitPart and hitPart.Parent;
    local hitHumanoid = hitPartParent and hitPartParent:FindFirstChildOfClass("Humanoid");
    if hitPartParent and (not hitHumanoid) then
        local PParent = hitPartParent.Parent;
        hitHumanoid = PParent and PParent:FindFirstChildOfClass("Humanoid");
    end
    local hitPlayer = hitHumanoid and players:GetPlayerFromCharacter(hitHumanoid.Parent);

    drawBullet(FirePos,HitPos,settings);
    self.ammo = self.ammo - 1;
    ui.hud.updateAmmo(self.ammo);
    self:emitEvent("fire",thisPlayer,FirePos,HitPos,hitPart,hitHumanoid,hitPlayer,hitMaterial); -- 이벤트 이밋
end

--- 달리기 상태를 설정합니다
---@param isRunning boolean
function gunClassMt:setRunning(isRunning)
    if not humanoid then
        warn("humanoid not found; ignored set run request");
        return;
    end
    local settings = self.settings;
    if isRunning then
        humanoid.WalkSpeed = settings.RunSpeed;
        self:emitEvent("run",thisPlayer);
    else
        humanoid.WalkSpeed = settings.WalkSpeed;
        self:emitEvent("idle",thisPlayer);
    end
end

function gunClassMt:reload()
    -- 이미 장전중
    if self.isReloading then
        return;
    end

    local settings = self.settings;
    local nowAmmo = self.ammo;
    local clip = settings.ClipSize;
    local maxClip = settings.MaxClipSize;
    local targetAmmo = 0;
    local reloadTime = settings.ReloadTime;
    local nowStorage = self.storage;

    -- 이미 가득찬 경우
    if nowAmmo >= maxClip then
        return;
    end

    -- 리로드 총알 목표치 잡음
    if nowAmmo == clip then
        targetAmmo = maxClip;
    elseif nowAmmo < clip then
        targetAmmo = clip;
    end

    -- 저장된 총알 갯수 확인
    if nowStorage < targetAmmo then
        targetAmmo = nowStorage;
    end

    -- 총알이 더이상 없음
    if targetAmmo == 0 or (not targetAmmo) then
        return;
    end

    self.isReloading = true;
    spawn(function () -- 분리된 새로운 스레드 생성
        self:emitEvent("reloadStarted",thisPlayer,nowAmmo,targetAmmo);
        ui.hud.updateReloadFrameVisible(true); -- 리로드 창 띄움
        ui.hud.updateReloadFrameStatus(reloadTime,0); -- ui 에 남은초 / 그래프 표시
        local isStopped = cwait:Wait(reloadTime,function(leftTime)
            if not reloadStatus then
                return true; -- break
            end
            ui.hud.updateReloadFrameStatus(leftTime,1 - (leftTime / reloadTime)); -- ui 에 남은초 / 그래프 표시
        end);
        if not isStopped then -- 만약 장전에 성공한 경우
            self.ammo = targetAmmo; -- 총알 갯수 업데이트
            self.storage = self.storage - targetAmmo + nowAmmo;
            ui.hud.updateAmmo(targetAmmo);
            ui.hud.updateStorage(self.storage);
            self:emitEvent("reloadEnded",thisPlayer,nowAmmo,targetAmmo);
        end
        self.isReloading = false;
        ui.hud.updateReloadFrameVisible(false); -- 리로드 창 끔
    end);
end

--- 이벤트에 함수를 연결시킵니다, 연결 후 바인딩 해제 이벤트를 리턴합니다
--- 바인딩은 이 개체가 파기 되는 경우는 자동으로 모두 파기됩니다
---@param eventName string name of event
---@param func function bindingFunction
---@return function unbindFunction
function gunClassMt:bind(eventName,func)
    local bindings = self.bindings[eventName];

    if not bindings then
        error(("Binding '%s' was not found from object 'qGun_Client'"):format(eventName));
    elseif tableFind(bindings,func) then
        warn(("'%s' was binded already! ignored binding function"):format(tostring(func)));
        return;
    end

    table.insert(bindings,func);

    return function () -- return unbind function
        local index = tableFind(bindings,func);
        if not index then
            warn(("'%s' was unbinded or not found from bindings! ignored unbinding function"):format(tostring(func)));
            return;
        end
        table.remove(bindings,index);
    end
end

--- 등록된 이벤트를 실행시킵니다, 뒤에 이벤트 이밋으로 넘겨줄 인자를 쓸 수있습니다
--- 기본적으로 외부에서 사용해서는 안됩니다
--- @param eventName string
--- @meta tag:private
function gunClassMt:emitEvent(eventName,...)
    local bindings = self.bindings[eventName];

    if not bindings then
        error(("Binding '%s' was not found from object 'qGun_Client'"):format(eventName));
    end

    for _,binding in pairs(bindings) do
        binding(...);
    end
end

--- 새로운 총 개체를 만듭니다
---@param data table 총 정보를 담은 테이블입니다
---@return table 총 클래스를 반환합니다
function module.new(data)
    local this = data or {};
    local settings = data.settings;
    this.bindings = {fire = {},run = {},idle = {},none = {},kill = {},reloadStarted = {},reloadEnded = {},reloadStopped = {}};
    this.ammo = settings.ClipSize;
    this.isReloading = false;
    --this.clip = settings.ClipSize;
    --this.maxClip = settings.MaxClipSize;
    this.storage = settings.StorageSize;

    this.tool.Equipped:Connect(function()
        ui.hud.updateName(settings.Name);
        ui.hud.updateVisible(true);
        ui.hud.updateAmmo(this.ammo);
        ui.hud.updateStorage(this.storage);
        equipped = this;
        humanoid.WalkSpeed = settings.WalkSpeed;
    end);
    this.tool.Unequipped:Connect(function()
        ui.hud.updateVisible(false);
        equipped = nil;
        humanoid.WalkSpeed = defaultWalkSpeed;
        lastFireTime = 0;
        setMouseDown(false);
        setReloading(false);
        this:emitEvent("none",thisPlayer);
    end);

    setmetatable(this,gunClassMt);

    return this;
end

return module;