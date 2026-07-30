return {
  {
    -- Linting
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        markdown = { "markdownlint-cli2" },
        json = { "jsonlint" },
        text = { "vale" },
      }

      local javascript_filetypes = {
        javascript = true,
        javascriptreact = true,
        typescript = true,
        typescriptreact = true,
      }
      local oxlint_configs = {
        ".oxlintrc.json",
        ".oxlintrc.jsonc",
        "oxlint.config.ts",
        "oxlint.config.mts",
      }
      local eslint_configs = {
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
      }

      local function has_config(bufnr, config_names)
        local filename = vim.api.nvim_buf_get_name(bufnr)
        local start_path = filename ~= "" and vim.fs.dirname(filename) or vim.fn.getcwd()
        return vim.fs.find(config_names, {
          path = start_path,
          upward = true,
          stop = vim.uv.os_homedir(),
          type = "file",
        })[1] ~= nil
      end

      local function lint_buffer(bufnr)
        vim.api.nvim_buf_call(bufnr, function()
          if not javascript_filetypes[vim.bo[bufnr].filetype] then
            lint.try_lint()
            return
          end

          local linters = {}
          if has_config(bufnr, oxlint_configs) then
            table.insert(linters, "oxlint")
          end
          if has_config(bufnr, eslint_configs) then
            table.insert(linters, "eslint")
          end
          if #linters > 0 then
            lint.try_lint(linters)
          end
        end)
      end

      -- Project-aware linters can be expensive, so lint only after saving.
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd("BufWritePost", {
        group = lint_augroup,
        callback = function(args)
          lint_buffer(args.buf)
        end,
      })

      vim.keymap.set("n", "<leader>ll", function()
        lint_buffer(vim.api.nvim_get_current_buf())
      end, { desc = "[l]int" })
    end,
  },
}
