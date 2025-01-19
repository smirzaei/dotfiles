local copilot_conf = {
    suggestion = {
        enabled = false,
        auto_trigger = false,
    },
    panel = { enabled = false },
    filetypes = {
        rust = true,
        zig = true,
        go = true,
        lua = true,
        ["*"] = false,
    },
}

return {
    "zbirenbaum/copilot-cmp",
    opts = {},
    dependencies = {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        opts = copilot_conf,
    },
}
