return {
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",
    },
    config = function()
      local dap = require("dap")

      require("mason-nvim-dap").setup({
        -- Makes a best effort to setup the various debuggers with
        -- reasonable debug configurations
        automatic_installation = true,

        -- You can provide additional configuration to the handlers,
        -- see mason-nvim-dap README for more information
        handlers = {},

        -- You'll need to check that you have the required things installed
        -- online, please don't ask me how to install them :)
        ensure_installed = {
          -- Update this to ensure that you have the debuggers for the langs you want
          "delve",
        },
      })

      -- Basic debugging keymaps, feel free to change to your liking!
      vim.keymap.set("n", "<leader>dg", dap.session, { desc = "[g]et session" })
      vim.keymap.set("n", "<leader>ds", dap.continue, { desc = "[s]tart" })
      vim.keymap.set("n", "<leader>dp", dap.pause, { desc = "[p]ause" })
      vim.keymap.set("n", "<leader>dd", dap.disconnect, { desc = "[d]isconnect" })
      vim.keymap.set("n", "<leader>dq", dap.close, { desc = "[q]uit" })

      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "[c]ontinue" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "step [i]nto" })
      vim.keymap.set("n", "<leader>db", dap.step_back, { desc = "step [b]ack" })
      vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "step [o]ver" })
      vim.keymap.set("n", "<leader>du", dap.step_out, { desc = "step o[u]t" })

      vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint, { desc = "[t]oggle breakpoint" })

      local dap_signs = {
        breakpoint = {
          text = "",
          texthl = "DiagnosticSignError",
          linehl = "",
          numhl = "",
        },
        breakpoint_rejected = {
          text = "",
          texthl = "DiagnosticSignError",
          linehl = "",
          numhl = "",
        },
        stopped = {
          text = "",
          texthl = "DiagnosticSignWarn",
          linehl = "Visual",
          numhl = "DiagnosticSignWarn",
        },
      }

      vim.fn.sign_define("DapBreakpoint", dap_signs.breakpoint)
      vim.fn.sign_define("DapBreakpointRejected", dap_signs.breakpoint_rejected)
      vim.fn.sign_define("DapStopped", dap_signs.stopped)
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Dap UI setup
      -- For more information, see |:help nvim-dap-ui|
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
        controls = {
          icons = {
            pause = "⏸",
            play = "▶",
            step_into = "⏎",
            step_over = "⏭",
            step_out = "⏮",
            step_back = "b",
            run_last = "▶▶",
            terminate = "⏹",
            disconnect = "⏏",
          },
        },
      })

      dap.listeners.after.event_initialized["dapui_config"] = dapui.open
      dap.listeners.before.event_terminated["dapui_config"] = dapui.close
      dap.listeners.before.event_exited["dapui_config"] = dapui.close

      vim.keymap.set("n", "<leader>dU", dapui.toggle, { desc = "toggle [U]I" })
      vim.keymap.set("n", "<leader>de", dapui.eval, { desc = "[e]val" })
      vim.keymap.set("v", "<leader>de", dapui.eval, { desc = "[e]val" })
      vim.keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "[r]epl" })
    end,
  },
  {
    "leoluz/nvim-dap-go",
    opts = {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has("win32") == 0,
      },
    },
    ft = "go",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
  },
  {
    "nicholasmata/nvim-dap-cs",
    ft = "cs",
    dir = "~/Developer/nvim-dap-cs",
    config = true,
    dependencies = {
      "mfussenegger/nvim-dap",
    },
  },
}
