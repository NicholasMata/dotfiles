return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers.cssls = {}
      opts.servers.vtsls = {}
      for _, tool in ipairs({
        "biome",
        "oxlint",
        "prettierd",
      }) do
        if not vim.tbl_contains(opts.ensure_installed, tool) then
          table.insert(opts.ensure_installed, tool)
        end
      end
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        css = { "prettierd" },
        javascript = { "biome", "prettierd", stop_after_first = true },
        javascriptreact = { "biome", "prettierd", stop_after_first = true },
        typescript = { "biome", "prettierd", stop_after_first = true },
        typescriptreact = { "biome", "prettierd", stop_after_first = true },
      },
      formatters = {
        biome = {
          require_cwd = true,
        },
        prettierd = {
          require_cwd = true,
        },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      local project_linters = {
        {
          name = "oxlint",
          configs = {
            ".oxlintrc.json",
            ".oxlintrc.jsonc",
            "oxlint.config.ts",
            "oxlint.config.mts",
          },
        },
        {
          name = "eslint",
          configs = {
            "eslint.config.js",
            "eslint.config.mjs",
            "eslint.config.cjs",
            "eslint.config.ts",
            "eslint.config.mts",
            "eslint.config.cts",
            ".eslintrc",
            ".eslintrc.js",
            ".eslintrc.cjs",
            ".eslintrc.json",
          },
        },
      }

      for _, filetype in ipairs({ "javascript", "javascriptreact", "typescript", "typescriptreact" }) do
        opts.project_linters[filetype] = project_linters
      end
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "css",
        "html",
        "javascript",
        "typescript",
        "tsx",
      })
      vim.list_extend(opts.highlight_filetypes, {
        "css",
        "html",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
      })
      vim.list_extend(opts.indent_filetypes, {
        "css",
        "html",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "js")
      table.insert(opts.setup, function(dap)
        dap.adapters["pwa-node"] = {
          type = "server",
          host = "127.0.0.1",
          port = "${port}",
          executable = {
            command = "js-debug-adapter",
            args = { "${port}" },
          },
        }
        dap.adapters["pwa-chrome"] = dap.adapters["pwa-node"]

        local node_configurations = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch current file",
            program = "${file}",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to a Node process",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
            sourceMaps = true,
          },
        }

        for _, filetype in ipairs({ "javascript", "typescript" }) do
          dap.configurations[filetype] = node_configurations
        end

        local browser_configurations = {
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Launch browser application",
            url = function()
              return vim.fn.input("Application URL: ", "http://localhost:5173")
            end,
            webRoot = "${workspaceFolder}",
            sourceMaps = true,
          },
        }

        for _, filetype in ipairs({ "javascriptreact", "typescriptreact" }) do
          dap.configurations[filetype] = browser_configurations
        end
      end)
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-jest",
      "marilari88/neotest-vitest",
    },
    opts = function(_, opts)
      opts.adapters.jest = function()
        return require("neotest-jest")({})
      end
      opts.adapters.vitest = function()
        return require("neotest-vitest")({})
      end
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },

  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    event = { "BufReadPost package.json", "BufNewFile package.json" },
    opts = {
      autostart = false,
    },
    keys = {
      {
        "<leader>nt",
        function()
          require("package-info").toggle()
        end,
        ft = "json",
        desc = "Toggle Package Info",
      },
      {
        "<leader>nu",
        function()
          require("package-info").update()
        end,
        ft = "json",
        desc = "Update Package",
      },
      {
        "<leader>ni",
        function()
          require("package-info").install()
        end,
        ft = "json",
        desc = "Install Package",
      },
      {
        "<leader>nd",
        function()
          require("package-info").delete()
        end,
        ft = "json",
        desc = "Delete Package",
      },
      {
        "<leader>np",
        function()
          require("package-info").change_version()
        end,
        ft = "json",
        desc = "Change Package Version",
      },
    },
  },
}
