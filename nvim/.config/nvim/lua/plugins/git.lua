-- Git signs, history, and repository integrations
-- NOTE: gitsigns is already included in init.lua but contains only the base
-- config. This will add also the recommended keymaps.

return {
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      signcolumn = false,
      numhl = true,
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "<leader>ghn", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gitsigns.nav_hunk("next")
          end
        end, { desc = "[n]ext hunk" })

        map("n", "<leader>ghp", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gitsigns.nav_hunk("prev")
          end
        end, { desc = "[p]rev hunk" })

        -- Actions
        -- visual mode
        map("v", "<leader>ghs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "[s]tage hunk" })
        -- map("v", "<leader>ghr", function()
        --   gitsigns.undo_stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        -- end, { desc = "[r]eset hunk" })
        -- normal mode
        map("n", "<leader>ghr", gitsigns.reset_hunk, { desc = "[r]eset hunk" })
        map("n", "<leader>ghR", gitsigns.reset_buffer, { desc = "[R]eset buffer" })
        map("n", "<leader>ghs", gitsigns.stage_hunk, { desc = "[s]tage hunk" })
        map("n", "<leader>ghS", gitsigns.stage_buffer, { desc = "[S]tage buffer" })
        -- map("n", "<leader>ghu", gitsigns.undo_stage_hunk, { desc = "[u]ndo staged hunk" })
        map("n", "<leader>ghP", gitsigns.preview_hunk, { desc = "[P]review hunk" })
        -- map("n", "<leader>ghd", gitsigns.diffthis, { desc = "[d]iff against index" })
        -- map("n", "<leader>ghD", function()
        --   gitsigns.diffthis("@")
        -- end, { desc = "[D]iff against last commit" })
        -- -- Toggles
        map("n", "<leader>gtb", gitsigns.toggle_current_line_blame, { desc = "show [b]lame line" })
        map("n", "<leader>gtD", gitsigns.preview_hunk_inline, { desc = "show [D]eleted" })
      end,
    },
  },
  {
    "rbong/vim-flog",
    cmd = { "Flog", "Flogsplit", "Floggit" },
    dependencies = { "tpope/vim-fugitive" },
    keys = {
      { "<leader>gv", "<cmd>Flog<cr>", desc = "[v]iew commit graph" },
    },
  },
}
