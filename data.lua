require 'data.styles'
require 'data.sounds'

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