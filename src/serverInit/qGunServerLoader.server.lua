
local qGunServer = require(game:GetService("ServerStorage"):WaitForChild("qGunServer"));

qGunServer.init();
-- 초기화를 진행함 (다른사람이 날린 총알 그리기 등을 위해서 서버와 이벤트 소캣을 만듬)
-- 처리는 모두 모듈이 하므로 여기는 그냥 로더 부분 정도밖에 안됨
-- 코드를 편집하고 싶으면 ServerStorage/qGunServer 로 이동 (src/server/init.lua)
