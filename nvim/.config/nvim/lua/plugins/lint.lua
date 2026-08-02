return {
  {
    -- Linting
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      linters_by_ft = {
        text = { "vale" },
      },
      project_linters = {},
    },
    config = function(_, opts)
      local lint = require("lint")

      lint.linters_by_ft = opts.linters_by_ft

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
          local project_linters = opts.project_linters[vim.bo[bufnr].filetype]
          if not project_linters then
            lint.try_lint()
            return
          end

          local linters = {}
          for _, project_linter in ipairs(project_linters) do
            if has_config(bufnr, project_linter.configs) then
              table.insert(linters, project_linter.name)
            end
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
