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

data:extend({
    {
        type = "custom-input",
        name = "pe_toggle_interface",
        key_sequence = "CONTROL + I",
        order = "a"
    }
})