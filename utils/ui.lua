local UiUtil = {}

function UiUtil.row_simple(global_player, content_frame, text, name)
    local controls_flow = content_frame.add{type="flow", name="controls_flow_" .. name, direction="horizontal", style="pe_controls_flow"}
    local controls_label = controls_flow.add({type="label", caption={"app." .. name}, name="controls_label_" .. name, style="pe_controls_label"})
    local controls_textfield = controls_flow.add(
        {
            type="textfield",
            name="pe_controls_textfield_" .. name,
            text=text,
            numeric=true,
            allow_decimal=false,
            allow_negative=false,
            style="pe_controls_textfield",
            enabled=false
        })

    global_player.elements.main_ui.controls["label_" .. name] = controls_label
    global_player.elements.main_ui.controls["textfield_" .. name] = controls_textfield
    global_player.elements.main_ui.controls["flow_" .. name] = controls_flow
    return controls_flow
end

return UiUtil