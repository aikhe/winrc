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

-- config.front_end = "OpenGL"
-- config.max_fps = 144
config.default_cursor_style = "BlinkingBlock"
-- config.animation_fps = 1
-- config.cursor_blink_rate = 500
config.term = "xterm-256color"

-- config.cell_width = 1
config.line_height = 0.8
-- config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font = wezterm.font("JetBrainsMono Nerd Font")
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

config.use_fancy_tab_bar = false
config.enable_kitty_keyboard = true

-- Tabs
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true

-- Panes
-- config.inactive_pane_hsb = {
-- 	saturation = 0.0,
-- 	brightness = 1.0,
-- }

-- This is where you actually apply your config choices
-- color scheme toggling
wezterm.on("toggle-colorscheme", function(window)
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
	{ key = "0", mods = "CTRL", action = act.ShowDebugOverlay },
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

-- Pane Navigation
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
	font = wezterm.font({ family = "JetBrainsMono Nerd Font", weight = "Bold" }),
	font_size = 9.0,
	active_titlebar_bg = "rgba(0, 0, 0,80%)",
	inactive_titlebar_bg = "rgba(0, 0, 0, 80%)",
}

config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"
config.window_decorations = "NONE"
config.window_background_opacity = 1.0
config.default_prog = { "powershell.exe", "-NoLogo" }

-- Background Image
-- config.window_background_image = "C:/dev/misc/berk.png"
-- config.window_background_image_hsb = {
-- 	brightness = 0.1,
-- }

config.default_cwd = "C:/Users/aikhe/Desktop/ike/local"

wezterm.on("gui-startup", function()
	mux.spawn_window({
		width = 134,
		height = 43,
		position = {
			x = -10,
			y = -2,
		},
	})
end)

local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

tabline.setup({
	options = {
		icons_enabled = true,
		theme = "Catppuccin Mocha",
		tabs_enabled = true,
		theme_overrides = {},
		section_separators = {
			left = wezterm.nerdfonts.pl_left_hard_divider,
			right = wezterm.nerdfonts.pl_right_hard_divider,
		},
		component_separators = {
			left = wezterm.nerdfonts.pl_left_soft_divider,
			right = wezterm.nerdfonts.pl_right_soft_divider,
		},
		tab_separators = {
			left = wezterm.nerdfonts.pl_left_hard_divider,
			right = wezterm.nerdfonts.pl_right_hard_divider,
		},
	},
	sections = {
		tabline_a = { "mode" },
		tabline_b = { "workspace" },
		tabline_c = { " " },
		tab_active = {
			"index",
			{ "parent", padding = 0 },
			"/",
			{ "cwd", padding = { left = 0, right = 1 } },
			{ "zoomed", padding = 0 },
		},
		tab_inactive = { "index", { "process", padding = { left = 0, right = 1 } } },
		tabline_x = { "ram", "cpu" },
		tabline_y = { "datetime", "battery" },
		tabline_z = { "domain" },
	},
	extensions = {},
})

return config
