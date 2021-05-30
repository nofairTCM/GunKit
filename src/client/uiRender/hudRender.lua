local module = {}

local import;
function module:setRender(newRender)
    import = newRender.Import;
    return module;
end

function module.init()
    local Frame = import("Frame");
    local ImageLabel = import("ImageLabel");
    local TextLabel = import("TextLabel");
    local ui = {}
    ui.hudHolder = Frame ("hudHolder") {
        Size = UDim2.fromOffset(200,80);
        BackgroundColor3 = Color3.fromRGB(45,45,45);
        BackgroundTransparency = 0.2;
        AnchorPoint = Vector2.new(1,1);
        BorderSizePixel = 0;
        Position = UDim2.new(1,-6,1,-30);
        Frame ("line") { -- 이름 경계선
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BackgroundTransparency = 0.2;
            BorderSizePixel = 0;
            Size = UDim2.new(0.8,0,0,1);
            Position = UDim2.fromOffset(0,28);
        };
        TextLabel ("gunName") { -- 총 이름 라벨 부분
            BorderSizePixel = 0;
            BackgroundTransparency = 1;
            Text = "NONE";
            Size = UDim2.new(1,-12,0,28);
            Position = UDim2.fromOffset(12,0);
            TextSize = 16;
            Font = Enum.Font.GothamBlack;
            TextColor3 = Color3.fromRGB(255,255,255);
            TextXAlignment = Enum.TextXAlignment.Left;
            whenCreated = function (this)
                ui.gunName = this;
            end;
        };
        TextLabel ("ammo") { -- 남은 총알
            BorderSizePixel = 0;
            BackgroundTransparency = 1;
            Text = "30";
            Size = UDim2.new(0.5,0,0,40);
            Position = UDim2.fromOffset(0,30);
            TextSize = 30;
            Font = Enum.Font.Gotham;
            TextColor3 = Color3.fromRGB(255,255,255);
            whenCreated = function (this)
                ui.ammo = this;
            end;
        };
        TextLabel ("store") { -- 스토리지됨
            BorderSizePixel = 0;
            BackgroundTransparency = 1;
            Text = "300";
            Size = UDim2.new(0.5,0,0,45);
            AnchorPoint = Vector2.new(0,1);
            Position = UDim2.new(0.5,0,1,0);
            TextSize = 20;
            Font = Enum.Font.Gotham;
            TextColor3 = Color3.fromRGB(255,255,255);
            whenCreated = function (this)
                ui.store = this;
            end;
        };
        TextLabel ("dash") { -- 남은 총알 / 스토리지됨 부분
            BorderSizePixel = 0;
            BackgroundTransparency = 1;
            Text = "/";
            Size = UDim2.fromOffset(0,24);
            Position = UDim2.new(0.5,0,0,42);
            TextSize = 20;
            Font = Enum.Font.Gotham;
            TextColor3 = Color3.fromRGB(255,255,255);
        };
    };
    ui.healthFrame = Frame ("HealthFrame") {
        BackgroundColor3 = Color3.fromRGB(25,25,25);
        BackgroundTransparency = 0.2;
        BorderSizePixel = 0;
        Position = UDim2.new(1,-6,1,-6);
        Size = UDim2.fromOffset(200,20);
        AnchorPoint = Vector2.new(1,1);
        ImageLabel ("icon") {
            BorderSizePixel = 0;
            AnchorPoint = Vector2.new(1, 0.5);
            Position = UDim2.new(0,-4,0.5,0);
            Size = UDim2.fromOffset(24,24);
            ImageColor3 = Color3.fromRGB(4,255,0);
            Image = "rbxassetid://3944675151";
            BackgroundTransparency = 1
        };
        Frame ("bar") {
            BackgroundColor3 = Color3.fromRGB(4,255,0);
            BorderSizePixel = 0;
            Size = UDim2.fromScale(0,1);
            ZIndex = 2;
            whenCreated = function (this)
                ui.healthBar = this;
            end;
        };
        Frame ("backgroundBar") {
            BackgroundColor3 = Color3.fromRGB(2,124,0);
            BorderSizePixel = 0;
            Size = UDim2.fromScale(0,1);
            whenCreated = function (this)
                ui.healthBackgroundBar = this;
            end;
        }
    };

    return {
        updateVisible = function (newVisible) -- update visible of ui
            ui.hudHolder.Visible = newVisible;
            ui.healthFrame.Visible = newVisible;
        end;
        updateParent = function (newParent) -- update parent of ui
            ui.hudHolder.Parent = newParent;
            ui.healthFrame.Parent = newParent;
        end;
        updateName = function (newName) -- update gun name
            ui.gunName.Text = newName;
        end;
        updateHealthPercent = function (newHealthPer) -- update health bar
            -- newHealthPer = 1 ~ 0 percent of health
            ui.healthBar:TweenSize(UDim2.fromScale(newHealthPer,1),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.25,true,nil);
            ui.healthBackgroundBar:TweenSize(UDim2.fromScale(newHealthPer,1),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.4,true,nil);
        end;
    };
end

return module
