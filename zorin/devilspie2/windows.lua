-- Screen 1920x1080 -> 80% = 1536x864, centered (192px / 108px margins)
local managed = {
    ["com.mitchellh.ghostty"] = true,
    ["dev.zed.Zed"] = true,
}

if managed[get_window_class()] then
    unmaximize()
    set_window_geometry(192, 108, 1536, 864)
end
