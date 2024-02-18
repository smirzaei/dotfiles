return {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
    config = function()
        vim.keymap.set("n", "<leader>dh", function()
            vim.cmd.RustLsp("renderDiagnostic")
        end, { desc = "Rust Diagnostics Hover" })
    end,
}
