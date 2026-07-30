return {
  -- lazy
  {
    "sontungexpt/witch-line",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false, -- Almost component is lazy load by default. So you can set lazy to false
    opts = {},
    config = function(_, opts)
      local statusline = vim.deepcopy(require("witch-line.constant.default"))
      local colors = require("witch-line.constant.color")

      local modified_buffers = {
        id = "buffers.modified",
        version = 2,
        static = {
          current = colors.red,
          current_with_others = colors.orange,
          others = colors.yellow,
        },
        events = {
          "BufEnter",
          "BufWritePost",
          "TextChanged",
          "TextChangedI",
          "BufModifiedSet",
          "BufDelete",
          "BufWipeout",
        },
        update = function(self)
          local count = 0
          local current_buf = vim.api.nvim_get_current_buf()
          local current_modified = false

          for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buflisted and vim.bo[bufnr].modified then
              count = count + 1
              current_modified = current_modified or bufnr == current_buf
            end
          end

          if count == 0 then
            return ""
          end

          local static = self.static
          local color = current_modified and count > 1 and static.current_with_others
            or current_modified and static.current
            or static.others

          return count == 1 and "" or (" " .. count), { fg = color }
        end,
      }

      for index, component in ipairs(statusline) do
        if component == "file.modifier" then
          statusline[index] = modified_buffers
          break
        end
      end

      opts = vim.tbl_deep_extend("force", opts, {
        statusline = {
          global = statusline,
        },
      })

      require("witch-line").setup(opts)
      vim.opt.laststatus = 3
    end,
  },
}
