-- These are some style prototypes that the tutorial uses
-- You don't need to understand how these work to follow along
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
    width = 36
}

styles["pe_controls_label"] = {
  type = "label_style",
  width = 100
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