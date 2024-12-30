codes = true
cache = true
std = "max"
globals = { "xero" }
max_line_length = 120
max_cyclomatic_complexity = 20
read_globals = {
    "GAMESTATE";
    "SCREENMAN";
    "stable_sort";
}
ignore = {
    "413";
    "213";
    "561";
    "421";
    "422";
}

files['template/ease.lua'] = {
    ignore = {
        "111"; -- read unknown global
        "113"; -- write unknown global
    }
}

files['template/sort.lua'] = {
    ignore = {
        "412";
    }
}

files['template/std.lua'] = {
    globals = {
        "copy";
        "clear";
        "iclear";
        "perframe_data_structure";
    }
}
