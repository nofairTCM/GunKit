--- SETUP
local tool = script.Parent;
local client = require(game:GetService("ReplicatedStorage"):WaitForChild("nofairTCM_Client"):WaitForChild("GunKit"));
local this = client.new {
    tool = tool;
    settings = require(tool:WaitForChild("settings"));
};

--- BIND EVENT
this:bind("run",function(thisPlayer)
    -- 달리기가 시작되었을 때, (에니메이션 효과를 여기다 쓰셈)
    -- thisPlayer : 이 플레이어를 가르킴
end);

this:bind("fire",function(thisPlayer,firePos,hitPos,hitObj,hitHumanoid,hitPlayer,hitMaterial)
    -- print(thisPlayer,firePos,hitPos,hitObj,hitHumanoid,hitPlayer,hitMaterial);
    -- 총 발사가 되었을 때, (알아서)
    -- thisPlayer : 이 플레이어를 가르킴
    -- firePos : 발사한 위치 (총구)
    -- hitPos : 부딛힌 위치
    -- hitObj : 부딛힌것으로 판정되는 오브젝트, 없으면 nil
    -- hitHumanoid : 만약 부딛힌것이 휴머노이드가 있는 오브젝트라면 휴머노이드를 가르킴
    -- hitPlayer : 만약 부딛힌것이 플레이어라면 플레이어를 가르킴
    -- hitMaterial : 부딛힌 개체의 질감을 나타냄

    -- thisPlayer.Character 하면 쏜 캐릭터 가져와짐
end);

this:bind("idle",function(thisPlayer)
    -- 아무것도 안하는 상태가 시작되었을 때 (여기도 에니메이션 부여용)
    -- thisPlayer : 이 플레이어를 가르킴
end);

this:bind("none",function(thisPlayer)
    -- 툴을 내려놓을 때, 애니메이션 다 끄는걸 여기서 해야됨
    -- thisPlayer : 이 플레이어를 가르킴
end);

this:bind("kill",function(thisPlayer,killedHumanoidObj,killedPlayer)
    -- 무언가를 죽였을 때 실행됨
    -- thisPlayer : 죽이기를 한 플레이어
    -- killedHumanoidObj : 죽인 휴머노이드 오브젝트
    -- killedPlayer : 죽임을 당한 플레이어, 만약 npc 이면 nil 반환
end);

this:bind("reloadStarted",function(thisPlayer,beforeAmmo,afterAmmo)
    -- 장전 시작될때 실행됨, 소리나 애니메이션 여기다 붇여넣으면 됨
    -- thisPlayer : 이 플레이어
    -- beforeAmmo : 장전 전 총알 갯수
    -- afterAmmo : 장전 후 총알 갯수
end);

this:bind("reloadEnded",function(thisPlayer,beforeAmmo,afterAmmo)
    -- 장전 끝날때 실행됨, 여기서 소리나 애니메이션 끝내기
    -- thisPlayer : 이 플레이어
    -- beforeAmmo : 장전 전 총알 갯수
    -- afterAmmo : 장전 후 총알 갯수
end);

this:bind("reloadStopped",function(thisPlayer,beforeAmmo,afterAmmo)
    -- 장전이 도중에 해제됨 (장전을 캔슬함), 여기서 소리나 애니메이션 끝내기
    -- thisPlayer : 이 플레이어
    -- beforeAmmo : 장전 전 총알 갯수
    -- afterAmmo : 장전 후 총알 갯수
end);