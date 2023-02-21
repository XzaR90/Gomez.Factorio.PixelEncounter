local UiUtil = {}

function UiUtil.update_if_exists(global_player, k, v)
    if global_player.elements.main_ui.controls["textfield_" .. k] then
        global_player.elements.main_ui.controls["textfield_" .. k].text = v
    end
end

function UiUtil.row_simple(global_player, content_frame, text, name, prefix)
    prefix = prefix or "app"
    local prefixed_name = prefix .. "_" .. name
    local controls_flow = content_frame.add{type="flow", name="controls_flow_" .. prefixed_name, direction="horizontal", style="pe_controls_flow"}
    local controls_label = controls_flow.add({type="label", caption={prefix .. "." .. name}, name="controls_label_" .. name, style="pe_controls_label"})
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

    global_player.elements.main_ui.controls["label_" .. prefixed_name] = controls_label
    global_player.elements.main_ui.controls["textfield_" .. prefixed_name] = controls_textfield
    global_player.elements.main_ui.controls["flow_" .. prefixed_name] = controls_flow
    return controls_flow
end

return UiUtil