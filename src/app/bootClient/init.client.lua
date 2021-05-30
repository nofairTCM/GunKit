
local qGunClient = require(game:GetService("ReplicatedStorage"):WaitForChild("qGunClient"));

qGunClient.init();
-- 초기화를 진행함 (다른사람이 날린 총알 그리기 등을 위해서 서버와 이벤트 소캣을 연결함 + ui 의 기초를 그려놓음)
-- 처리는 모두 모듈이 하므로 여기는 그냥 로더 부분 정도밖에 안됨
-- 코드를 편집하고 싶으면 ReplicatedStorage/qGunClient 로 이동 (src/client/init.lua)
