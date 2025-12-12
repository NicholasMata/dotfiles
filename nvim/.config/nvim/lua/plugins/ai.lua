-- Default: OpenAI GPT-5
local gpt5_strategy = {
  adapter = {
    name = "openai",
    model = "gpt-5", -- make sure your account has access to GPT-5
  },
}

-- Optional: Ollama (manual use)
local ollama_strategy = {
  adapter = {
    name = "ollama",
    model = "codellama:7b",
  },
}

return {
  "olimorris/codecompanion.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function(_, opts)
    require("codecompanion").setup(opts)

    -- Keymaps
    vim.api.nvim_set_keymap("n", "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("v", "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap(
      "n",
      "<LocalLeader>a",
      "<cmd>CodeCompanionChat Toggle<cr>",
      { noremap = true, silent = true }
    )
    vim.api.nvim_set_keymap(
      "v",
      "<LocalLeader>a",
      "<cmd>CodeCompanionChat Toggle<cr>",
      { noremap = true, silent = true }
    )
    vim.api.nvim_set_keymap("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

    -- Expand 'cc' in command-line
    vim.cmd([[cab cc CodeCompanion]])
  end,
  opts = {
    -- Default strategies: GPT-5
    strategies = {
      chat = gpt5_strategy,
      inline = gpt5_strategy,
      agent = gpt5_strategy,
    },
    ignore_warnings = true,
    adapters = {
      http = {
        -- OpenAI GPT-5
        openai = function()
          return require("codecompanion.adapters").extend("openai", {
            env = {
              api_key = [[cmd:security find-generic-password -a openai -s OPENAI_API_KEY -w]],
            },
            schema = {
              model = { default = "gpt-5" },
            },
          })
        end,

        -- Ollama (manual use)
        ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            schema = {
              model = { default = ollama_strategy.adapter.model },
            },
          })
        end,
      },
    },

    opts = {
      log_level = "DEBUG",
    },
  },
}
