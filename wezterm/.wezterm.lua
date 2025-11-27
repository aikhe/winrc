-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux
-- This will hold the configuration.
local config = wezterm.config_builder()
-- local gpus = wezterm.gui.enumerate_gpus()
-- config.webgpu_preferred_adapter = gpus[1]
-- config.front_end = "WebGpu"
-- config.prefer_egl = false

config.front_end = "OpenGL"
-- config.max_fps = 144
config.default_cursor_style = "BlinkingBlock"
-- config.animation_fps = 1
-- config.cursor_blink_rate = 500
config.term = "xterm-256color"

-- config.cell_width = 1
config.line_height = 0.8
config.font = wezterm.font("JetBrainsMono Nerd Font")
-- config.font = wezterm.font("MesloLGLDZ Nerd Font Mono")
-- config.font = wezterm.font("Inconsolata Nerd Font Mono")

config.prefer_egl = true
config.font_size = 9.2
config.use_cap_height_to_scale_fallback_fonts = true

config.window_padding = {
	left = 10,
	right = 10,
	top = 8,
	bottom = 8,
}

config.use_fancy_tab_bar = true
config.enable_kitty_keyboard = true

-- TABS
config.hide_tab_bar_if_only_one_tab = true
-- config.use_fancy_tab_bar = false
-- config.tab_bar_at_bottom = true

-- PANES
-- config.inactive_pane_hsb = {
-- 	saturation = 0.0,
-- 	brightness = 1.0,
-- }

-- This is where you actually apply your config choices
-- color scheme toggling
wezterm.on("toggle-colorscheme", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	if overrides.color_scheme == "Zenburn" then
		overrides.color_scheme = "Cloud (terminal.sexy)"
	else
		overrides.color_scheme = "Zenburn"
	end
	window:set_config_overrides(overrides)
end)

-- keymaps
config.keys = {
	{
		key = "E",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.EmitEvent("toggle-colorscheme"),
	},
	{
		key = "Tab",
		mods = "CTRL",
		action = act.ActivateTabRelative(1), -- Next tab
	},
	{
		key = "h",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.SplitPane({
			direction = "Right",
			size = { Percent = 50 },
		}),
	},
	{
		key = "v",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.SplitPane({
			direction = "Down",
			size = { Percent = 50 },
		}),
	},
	{
		key = "h",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "j",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Down", 5 }),
	},
	{
		key = "i",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Up", 5 }),
	},
	{
		key = "l",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Right", 5 }),
	},
	{
		key = "q",
		mods = "CTRL|SHIFT",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{ key = "9", mods = "CTRL", action = act.PaneSelect },
	{ key = "q", mods = "CTRL", action = act.ShowDebugOverlay },
	{
		key = "O",
		mods = "CTRL|ALT",
		-- toggling opacity
		action = wezterm.action_callback(function(window, _)
			local overrides = window:get_config_overrides() or {}
			if overrides.window_background_opacity == 1.0 then
				overrides.window_background_opacity = 0.8
			else
				overrides.window_background_opacity = 1.0
			end
			window:set_config_overrides(overrides)
		end),
	},
	{
		key = "w",
		mods = "CTRL|SHIFT",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
}

for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "CTRL|ALT",
		action = act.ActivateTab(i - 1),
	})
end

table.insert(config.keys, { key = "h", mods = "CTRL|ALT", action = act.ActivatePaneDirection("Left") })
table.insert(config.keys, { key = "j", mods = "CTRL|ALT", action = act.ActivatePaneDirection("Down") })
table.insert(config.keys, { key = "k", mods = "CTRL|ALT", action = act.ActivatePaneDirection("Up") })
table.insert(config.keys, { key = "l", mods = "CTRL|ALT", action = act.ActivatePaneDirection("Right") })

-- Pane resizing
table.insert(config.keys, { key = "h", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) })
table.insert(config.keys, { key = "j", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) })
table.insert(config.keys, { key = "i", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) })
table.insert(config.keys, { key = "l", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) })

-- Other binds
table.insert(config.keys, { key = "o", mods = "CTRL", action = act.PaneSelect })
table.insert(config.keys, { key = "q", mods = "CTRL", action = act.ShowDebugOverlay })

-- Toggle opacity with CTRL+ALT+O
table.insert(config.keys, {
	key = "O",
	mods = "CTRL|ALT",
	action = wezterm.action_callback(function(window, _)
		local overrides = window:get_config_overrides() or {}
		if overrides.window_background_opacity == 1.0 then
			overrides.window_background_opacity = 0.8
		else
			overrides.window_background_opacity = 1.0
		end
		window:set_config_overrides(overrides)
	end),
})

-- For example, changing the color scheme:
-- config.color_scheme = "Cloud (terminal.sexy)"
config.colors = {
	-- The default text color
	foreground = "silver",
	-- The default background color
	background = "black",

	-- Overrides the cell background color when the current cell is occupied by the
	-- cursor and the cursor style is set to Block
	cursor_bg = "#789978",
	-- Overrides the text color when the current cell is occupied by the cursor
	cursor_fg = "black",
	-- Specifies the border color of the cursor when the cursor style is set to Block,
	-- or the color of the vertical or horizontal bar when the cursor style is set to
	-- Bar or Underline.
	cursor_border = "#789978",

	-- the foreground color of selected text
	selection_fg = "black",
	-- the background color of selected text
	selection_bg = "#aaaaaa",

	-- The color of the scrollbar "thumb"; the portion that represents the current viewport
	scrollbar_thumb = "#222222",

	-- The color of the split lines between panes
	split = "#191919",

	ansi = {
		"black",
		"#ffaa88",
		"#789978",
		"#555555",
		"navy",
		"purple",
		"#708090",
		"silver",
	},
	brights = {
		"grey",
		"#deeeed",
		"#ffaa88",
		"#7788aa",
		"blue",
		"fuchsia",
		"#708090",
		"white",
	},

	-- Arbitrary colors of the palette in the range from 16 to 255
	indexed = { [136] = "#af8700" },

	-- Since: 20220319-142410-0fcdea07
	-- When the IME, a dead key or a leader key are being processed and are effectively
	-- holding input pending the result of input composition, change the cursor
	-- to this color to give a visual cue about the compose state.
	compose_cursor = "orange",

	-- Colors for copy_mode and quick_select
	-- available since: 20220807-113146-c2fee766
	-- In copy_mode, the color of the active text is:
	-- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
	-- 2. selection_* otherwise
	copy_mode_active_highlight_bg = { Color = "#000000" },
	-- use `AnsiColor` to specify one of the ansi color palette values
	-- (index 0-15) using one of the names "Black", "Maroon", "Green",
	--  "Olive", "Navy", "Purple", "Teal", "Silver", "Grey", "Red", "Lime",
	-- "Yellow", "Blue", "Fuchsia", "Aqua" or "White".
	copy_mode_active_highlight_fg = { AnsiColor = "Black" },
	copy_mode_inactive_highlight_bg = { Color = "#789978" },
	copy_mode_inactive_highlight_fg = { AnsiColor = "White" },

	quick_select_label_bg = { Color = "peru" },
	quick_select_label_fg = { Color = "#ffffff" },
	quick_select_match_bg = { AnsiColor = "Navy" },
	quick_select_match_fg = { Color = "#ffffff" },

	background = "#000000", -- dark purple
	cursor_border = "#ffffff",
	-- cursor_fg = "#281733",
	cursor_bg = "#ffffff",
	-- selection_fg = '#281733',

	tab_bar = {
		background = "rgba(0,0,0,0%)",
		active_tab = {
			bg_color = "rgba(0,0,0,0%)",
			fg_color = "#aaaaaa",
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},
		inactive_tab = {
			bg_color = "rgba(0,0,0,0%)",
			fg_color = "#555555",
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},
	},
}

config.window_frame = {
	-- The font used in the tab bar.
	-- Roboto Bold is the default; this font is bundled
	-- with wezterm.
	-- Whatever font is selected here, it will have the
	-- main font setting appended to it to pick up any
	-- fallback fonts you may have used there.
	font = wezterm.font({ family = "JetBrainsMono Nerd Font", weight = "Bold" }),

	-- The size of the font in the tab bar.
	-- Default to 10.0 on Windows but 12.0 on other systems
	font_size = 9.0,

	-- The overall background color of the tab bar when
	-- the window is focused
	active_titlebar_bg = "rgba(0, 0, 0,80%)",

	-- The overall background color of the tab bar when
	-- the window is not focused
	inactive_titlebar_bg = "rgba(0, 0, 0, 80%)",
}

config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"
config.window_decorations = "NONE"
config.window_background_opacity = 0.8
config.default_prog = { "powershell.exe", "-NoLogo" }
-- config.initial_cols = 80
-- config.window_background_image = "C:/dev/misc/berk.png"
-- config.window_background_image_hsb = {
-- 	brightness = 0.1,
-- }

config.default_cwd = "C:/Users/aikhe/Desktop/ike/local"

wezterm.on("gui-startup", function(cmd)
	local args = {}
	if cmd then
		args = cmd.args
	end

	local tab, pane, window = mux.spawn_window({
		width = 140,
		height = 45,
		position = {
			x = -10,
			y = -2,
			-- Optional origin to use for x and y.
			-- Possible values:
			-- * "ScreenCoordinateSystem" (this is the default)
			-- * "MainScreen" (the primary or main screen)
			-- * "ActiveScreen" (whichever screen hosts the active/focused window)
			-- * {Named="HDMI-1"} - uses a screen by name. See wezterm.gui.screens()
			-- origin = "ScreenCoordinateSystem"
		},
	})
	-- window:gui_window():maximize()
	-- window:gui_window():set_position(0, 0)
end)

-- and finally, return the configuration to wezterm
return config
