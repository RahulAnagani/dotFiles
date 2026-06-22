---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"
require("variables")

--APPS
hl.bind(mainMod .. "+ B", hl.dsp.exec_cmd(browser))
hl.bind("CTRL + SHIFT + S", hl.dsp.exec_cmd(screenshot))
hl.bind(mainMod .. "+ V", hl.dsp.exec_cmd(vscode))
hl.bind(mainMod .. "+ F", hl.dsp.window.float())
-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))

--SHORTCUTS
hl.bind(mainMod .. "+ Q", hl.dsp.window.close())
hl.bind(mainMod .. " + M",
    hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

local current = hl.dsp.exec_cmd("hyprctl activeworkspace -j")
-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("special"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
-- hl.bind(mainMod .. " + SHIFT + G", hl.dsp.window.move({ workspace = 100 }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 2%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 7%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })


-- PERSONAL MODIFICATIONS
-- hl.bind(mainMod .. " + TAB", function()
--     local current_tab = hl.exec_cmd("hyprctl activeworkspace | grep ")
--     hl.exec_cmd("notify-send jo")
-- end)

-- Debuggin Purpose
-- hl.bind("CTRL + G", function()
--     local workspaces = hl.get_workspaces()
--     local f = io.open("/tmp/hyprlua.log", "a")
--     f:write("hi" .. "\n")
--     for k, v in pairs(workspaces) do
--         if not v.special then
--             f:write(v.id .. " " .. tostring(v.last_window.class) .. "\n")
--         end
--     end
--     f:close()
-- end)

-- Slide through workspaces
hl.bind(mainMod .. "+ TAB", function()
    -- local f = io.open("/tmp/hyprlua.log", "w")
    -- f:write(currentWorkspace.id)
    local workspaces = hl.get_workspaces()
    local current_workspace = -1
    local ids = {}
    for _, ws in pairs(workspaces) do
        if not ws.special and not is_empty then
            table.insert(ids, ws.id)
        end
        if ws.active then
            current_workspace = ws.id
        end
    end
    table.sort(ids)
    local next_ws_id = -1
    for ind, id in pairs(ids) do
        if id == current_workspace then
            next_ws_id = ids[ind + 1] or ids[1]
        end
    end
    -- f:write("\n")
    -- f:write(current_workspace)
    hl.dispatch(
        hl.dsp.focus({ workspace = next_ws_id })
    )
    -- f:close()
end)
