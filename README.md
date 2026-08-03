# 🍌 BananiUI

BananiUI is a public Roblox Lua interface library based on a modified Rayfield Interface Suite build.

It includes:

- Window, tab, section, button, toggle, slider, dropdown, input, color-picker, keybind, label, and paragraph components
- Success, error, warning, and information notifications
- `SafeCall` callback error handling
- Automatic loaded-script notification with the current game name
- Configuration saving
- Multiple themes
- No analytics reporter or heartbeat telemetry in this public build
- Readable, unobfuscated source

## Installation

```lua
local BananiUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/YOUR_USERNAME/BananiUI/main/source.lua"
))()
```

Replace `YOUR_USERNAME` after uploading the project to GitHub.

## Minimal example

```lua
local BananiUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/YOUR_USERNAME/BananiUI/main/source.lua"
))()

local Window = BananiUI:CreateWindow({
    Name = "My Script",
    LoadingTitle = "My Script",
    LoadingSubtitle = "Powered by BananiUI",
    Theme = "Default",

    ConfigurationSaving = {
        Enabled = true,
        FolderName = "MyScript",
        FileName = "Settings"
    },

    Discord = {
        Enabled = false
    },

    KeySystem = false
})

local Home = Window:CreateTab("Home", 4483362458)

Home:CreateButton({
    Name = "Test Button",
    Callback = function()
        BananiUI:NotifySuccess("The button worked.", "My Script")
    end
})

BananiUI:LoadConfiguration()
```

## Notification helpers

```lua
BananiUI:NotifySuccess("Saved successfully.")
BananiUI:NotifyError("Something failed.")
BananiUI:NotifyWarning("Check this setting.")
BananiUI:NotifyInfo("Update available.")
```

## Safe callbacks

```lua
BananiUI:SafeCall("Load profile", function()
    error("Example failure")
end)
```

If the callback fails, BananiUI warns in the console and shows an error notification.

## Privacy

This public build removes the former analytics reporter, collection endpoint, heartbeat request, remote prompt helper, and remote Discord boost helper.

Read [PRIVACY.md](PRIVACY.md) for the remaining network and asset disclosure.

## Attribution and license

BananiUI is a modified distribution based on Rayfield Interface Suite by SiriusSoftwareLtd and its contributors. It must not be described as code written entirely from scratch.

Keep:

- `NOTICE.md`
- `PRIVACY.md`
- The original Rayfield repository `LICENSE` file
- Original contributor credits inside `source.lua`

See [NOTICE.md](NOTICE.md).

## Repository layout

```text
BananiUI/
├── source.lua
├── README.md
├── NOTICE.md
├── PRIVACY.md
├── CHANGELOG.md
├── CONTRIBUTING.md
├── SECURITY.md
├── LICENSE-SETUP.md
├── examples/
│   ├── minimal.lua
│   └── full-example.lua
└── docs/
    ├── notifications.md
    └── publishing.md
```

## Important

Never place passwords, private webhook URLs, API keys, authentication tokens, personal email addresses, or private repository credentials in public source code.
