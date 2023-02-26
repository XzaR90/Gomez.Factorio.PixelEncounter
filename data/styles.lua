require 'data.fonts'

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
  font = "pe_font_12",
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
    top_padding = 10,
    right_padding = 287,
  },
}