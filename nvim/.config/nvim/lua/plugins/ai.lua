-- Default: Codex via ACP
local codex_strategy = {
  adapter = "codex",
  model = "gpt-5.6-sol",
}

-- Default: OpenAI GPT-5
local openai_strategy = {
  adapter = {
    name = "openai",
    model = "gpt-5.6-sol", -- make sure your account has access to GPT-5
  },
}

return {
  "olimorris/codecompanion.nvim",
  version = "^19.0.0",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    -- Default strategies: GPT-5
    interactions = {
      chat = codex_strategy,
      inline = openai_strategy,
    },
    opts = {
      log_level = "TRACE",
    },
    adapters = {
      http = {
        -- OpenAI GPT-5
        openai = function()
          return require("codecompanion.adapters").extend("openai", {
            env = {
              api_key = [[cmd:security find-generic-password -a openai -s OPENAI_API_KEY -w]],
            },
          })
        end,

        -- Ollama (manual use)
        ollama = function()
          return require("codecompanion.adapters").extend("ollama", {})
        end,
      },
      acp = {
        codex = function()
          return require("codecompanion.adapters").extend("codex", {
            defaults = {
              auth_method = "chatgpt",
            },
          })
        end,
      },
    },
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
}
