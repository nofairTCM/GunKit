return {
    Color = Color3.fromRGB(243, 255, 0); -- 총알 색깔
    ReloadTime = 1.35;
    Name = "TestGun"; -- 총 이름
    WalkSpeed = 15; -- 걷는 속도
    RunSpeed = 22; -- 뛰는 속도
    Damage = {20,28}; -- 원 데미지
    HeadDamage = {32,42}; -- 헤드 데미지
    FireLate = 1 / 10; -- 초당 10발
    ClipSize = 30; -- 탄창 크기
    MaxClipSize = 31; -- 약실에 총알이 1개 남아서 총합 31 개가 최대가 되도록 만들기 위해 사용됩니다
    StorageSize = math.huge; -- 총알 총 갯수, math.huge 쓰면 총알 갯수 무제한됨
    MaxRange = 600; -- 날아갈 수 있는 총 거리
    SpreadMax = 80; -- 탄이 퍼지는 최대치
    SpreadMin = 0; -- 탄이 퍼지는 최소치
    SpreadUnit = 1 / 100; -- 탄퍼짐 단위 (탄퍼짐 = rand(최소,최대)*유닛 )
};
