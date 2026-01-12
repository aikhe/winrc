-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux

-- Initialize configuration
local config = wezterm.config_builder()

-- ============================================================================
-- PERFORMANCE & RENDERING
-- ============================================================================
config.prefer_egl = true
config.term = "xterm-256color"

-- ============================================================================
-- FONT CONFIGURATION
-- ============================================================================
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 9.2
config.line_height = 0.8
config.use_cap_height_to_scale_fallback_fonts = true

-- ============================================================================
-- CURSOR
-- ============================================================================
config.default_cursor_style = "BlinkingBlock"

-- ============================================================================
-- WINDOW SETTINGS
-- ============================================================================
config.window_padding = {
	left = 10,
	right = 10,
	top = 8,
	bottom = 8,
}

config.window_decorations = "NONE"
config.window_background_opacity = 1.0
config.default_prog = { "powershell.exe", "-NoLogo" }
config.default_cwd = "C:/Users/aikhe/Desktop/ike/local"

config.window_frame = {
	font = wezterm.font({ family = "JetBrainsMono Nerd Font", weight = "Bold" }),
	font_size = 9.0,
	active_titlebar_bg = "rgba(0, 0, 0, 80%)",
	inactive_titlebar_bg = "rgba(0, 0, 0, 80%)",
}

-- ============================================================================
-- TAB BAR
-- ============================================================================
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true

-- ============================================================================
-- KEYBOARD
-- ============================================================================
config.enable_kitty_keyboard = true

-- ============================================================================
-- COLOR SCHEME
-- ============================================================================
config.colors = {
	foreground = "silver",
	background = "#000000",

	cursor_bg = "#ffffff",
	cursor_fg = "black",
	cursor_border = "#ffffff",

	selection_fg = "black",
	selection_bg = "#aaaaaa",

	scrollbar_thumb = "#222222",
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

	indexed = { [136] = "#af8700" },
	compose_cursor = "orange",

	copy_mode_active_highlight_bg = { Color = "#000000" },
	copy_mode_active_highlight_fg = { AnsiColor = "Black" },
	copy_mode_inactive_highlight_bg = { Color = "#789978" },
	copy_mode_inactive_highlight_fg = { AnsiColor = "White" },

	quick_select_label_bg = { Color = "peru" },
	quick_select_label_fg = { Color = "#ffffff" },
	quick_select_match_bg = { AnsiColor = "Navy" },
	quick_select_match_fg = { Color = "#ffffff" },

	tab_bar = {
		background = "rgba(0, 0, 0, 0%)",
		active_tab = {
			bg_color = "rgba(0, 0, 0, 0%)",
			fg_color = "#aaaaaa",
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},
		inactive_tab = {
			bg_color = "rgba(0, 0, 0, 0%)",
			fg_color = "#555555",
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},
	},
}

-- ============================================================================
-- KEY BINDINGS
-- ============================================================================
config.keys = {
	-- Color scheme toggle
	{
		key = "E",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.EmitEvent("toggle-colorscheme"),
	},

	-- Opacity toggle
	{
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
	},

	-- Tab navigation
	{ key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },

	-- Pane splitting
	{
		key = "h",
		mods = "CTRL|SHIFT|ALT",
		action = act.SplitPane({ direction = "Right", size = { Percent = 50 } }),
	},
	{
		key = "v",
		mods = "CTRL|SHIFT|ALT",
		action = act.SplitPane({ direction = "Down", size = { Percent = 50 } }),
	},

	-- Pane navigation
	{ key = "h", mods = "CTRL|ALT", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "CTRL|ALT", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "CTRL|ALT", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "CTRL|ALT", action = act.ActivatePaneDirection("Right") },

	-- Pane resizing
	{ key = "h", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },
	{ key = "j", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },
	{ key = "i", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
	{ key = "l", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },

	-- Pane management
	{ key = "o", mods = "CTRL", action = act.PaneSelect },
	{ key = "9", mods = "CTRL", action = act.PaneSelect },
	{ key = "q", mods = "CTRL|SHIFT", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "w", mods = "CTRL|SHIFT", action = act.CloseCurrentPane({ confirm = false }) },

	-- Debug
	{ key = "0", mods = "CTRL", action = act.ShowDebugOverlay },
}

-- Tab activation keybindings (Ctrl+Alt+1-9)
for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "CTRL|ALT",
		action = act.ActivateTab(i - 1),
	})
end

-- ============================================================================
-- EVENTS
-- ============================================================================
wezterm.on("toggle-colorscheme", function(window)
	local overrides = window:get_config_overrides() or {}
	if overrides.color_scheme == "Zenburn" then
		overrides.color_scheme = "Cloud (terminal.sexy)"
	else
		overrides.color_scheme = "Zenburn"
	end
	window:set_config_overrides(overrides)
end)

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

-- ============================================================================
-- PLUGINS
-- ============================================================================
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
