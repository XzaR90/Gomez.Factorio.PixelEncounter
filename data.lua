local styles = data.raw["gui-style"].default

styles["pe_content_frame"] = {
    type = "frame_style",
    parent = "inside_shallow_frame_with_padding",
    vertically_stretchable = "on"
}

styles["pe_controls_flow"] = {
    type = "horizontal_flow_style",
    vertical_align = "center",
    horizontal_spacing = 16
}

styles["pe_controls_textfield"] = {
    type = "textbox_style",
    width = 100
}

styles["pe_controls_label"] = {
  type = "label_style",
  width = 100
}

styles["pe_stats_ui_label"] = {
  type = "label_style",
  font = "default-game",
  font_color = default_font_color,
}

styles["pe_stats_ui_frame"] = {
  type = "frame_style",
  parent = "invisible_frame",
  horizontal_flow_style = {
    type = "horizontal_flow_style",
    horizontal_spacing = 20,
    horizontal_align = "right",
    horizontally_stretchable = "on",
    top_padding = 10,
    right_padding = 287 + 180,
  },
  vertical_flow_style = {
    type = "vertical_flow_style",
    vertical_spacing = 0,
    horizontal_align = "right",
    horizontally_stretchable = "on",
    top_padding = 38,
    right_padding = 287,
  },
}

data:extend({
    {
        type = "custom-input",
        name = "pe_toggle_interface",
        key_sequence = "CONTROL + I",
        order = "a"
    },
    {
        type = "shortcut",
        name = "pe_shortcut",
        localised_name = { "ui.shortcut_character"},
        order = "b[blueprints]-f[book]",
        action = "lua",
        style = "green",
        icon = {
          filename = "__pixelencounter-server-mod__/assets/icons/shortcut-toolbar/pixel-encounter-x32.png",
          flags = {
            "icon"
          },
          priority = "extra-high-no-scale",
          scale = 1,
          size = 32
        },
        disabled_icon = {
            filename = "__pixelencounter-server-mod__/assets/icons/shortcut-toolbar/pixel-encounter-disabled-x32.png",
            flags = {
              "icon"
            },
            priority = "extra-high-no-scale",
            scale = 1,
            size = 32
          },
        small_icon = {
          filename = "__pixelencounter-server-mod__/assets/icons/shortcut-toolbar/pixel-encounter-x24.png",
          flags = {
            "icon"
          },
          priority = "extra-high-no-scale",
          scale = 1,
          size = 24
        },
        disabled_small_icon = {
          filename = "__pixelencounter-server-mod__/assets/icons/shortcut-toolbar/pixel-encounter-disabled-x24.png",
          flags = {
            "icon"
          },
          priority = "extra-high-no-scale",
          scale = 1,
          size = 24
        },
      },
})