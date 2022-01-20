local Suite = {}

local plugin = nil

local Widgets = {}
local DockWidgetReadList = {"InitialDockState", "EnabledOnInit", "OverridePreviousState", "FloatingSizeX", "FloatingSizeY", "MinimumSizeX", "MinimumSizeY"}

Suite.PrimaryWidget = nil
Suite.PrimaryButton = nil

local UIHandler = {} do
	local Objects = {}
	
	local Theme = {
		Background = Color3.fromRGB(46, 46, 46),

		Bar = {
			Background = Color3.fromRGB(0,0,0),
			BorderColor = Color3.fromRGB(21, 21, 21),
			BarColor = Color3.fromRGB(255,255,255)
		},

		Text = {
			Front = Color3.fromRGB(255,255,255),
			Back = Color3.fromRGB(0,0,0),
		}
	}
	
	function UIHandler:SetTheme(...)
		Theme = ...

		Objects.Background.BackgroundColor3 = Theme.Background
	end

	function UIHandler:GetTheme()
		return Theme
	end

	function UIHandler:NewObject(InstanceType, Properties)
		local Object = Instance.new(InstanceType)

		Objects[Properties.Name or ""] = Object

		if Properties.Parent == nil then
			Object.Parent = Objects.Background
		end

		for Index, Property in pairs(Properties) do
			Object[Index] = Property
		end

		return Object
	end

	function UIHandler:GetObject(...)
		return Objects[...]
	end

	function UIHandler:Init(Window)
		Window:ClearAllChildren()

		self:NewObject("Frame", {
			Name = "Background",
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			Parent = Window
		})

		self:NewObject("TextLabel", {
			Name = "TitleLabel",
			Size = UDim2.new(1, 0, 0.1, 0),
			BackgroundTransparency = 1,
			Text = "iG Studios",
			TextScaled = true,
			Font = Enum.Font.GothamBlack,
		})

		self:NewObject("ScrollingFrame", {
			Position = UDim2.new(0, 0, 0.1, 0),
			Size = UDim2.new(1, 0, 0.9, 0),
			BackgroundTransparency = 1,
		})
	end
end

function Suite:CreateWidget(WidgetInformation)
	local CompressedDockWidgetInformation = {}

	for Index = 1, #DockWidgetReadList do -- Convert the dictionary into an array
		local DictionaryIndex = DockWidgetReadList[Index]
		local DictionaryValue = WidgetInformation[DictionaryIndex]

		if DictionaryValue == nil then
			error("Expected value for index " .. DictionaryIndex .. ", got nil")
		else
			CompressedDockWidgetInformation[Index] = DictionaryValue
		end
	end

	local DockWidgetInformation = DockWidgetPluginGuiInfo.new(unpack(CompressedDockWidgetInformation))
	local WidgetName = WidgetInformation.Name
	local FormattedWidgetName = WidgetName:gsub(" ", "")
	local NewWidget = plugin:CreateDockWidgetPluginGui(WidgetName, DockWidgetInformation)

	NewWidget.Name = FormattedWidgetName
	NewWidget.Title = WidgetName

	Widgets[FormattedWidgetName] = NewWidget

	return NewWidget
end

function Suite:Load(Plugin)
	local Toolbar = Plugin:CreateToolbar("iG Plugin Suite")
	
	plugin = Plugin
	
	Suite.PrimaryWidget = Suite:CreateWidget({
		Name = "iG Suite",
		InitialDockState = Enum.InitialDockState.Float,
		EnabledOnInit = false,
		OverridePreviousState = false,
		FloatingSizeX = 500,
		FloatingSizeY = 300,
		MinimumSizeX = 500,
		MinimumSizeY = 300
	})
	
	Suite.PrimaryButton = Toolbar:CreateButton("Open", "Opens the suite", "rbxassetid://8567187012")
	
	Suite.PrimaryButton.Click:Connect(function()
		Suite.PrimaryWidget.Enabled = not Suite.PrimaryWidget.Enabled
	end)
	
	UIHandler:Init(Suite.PrimaryWidget)
	
	warn("iG suite loaded! Please DM @iGottic on the DevForum or Roblox if issues occur!")
end

return Suite