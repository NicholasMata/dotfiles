return {
  {
    "andymass/vim-matchup",
    opts = {
      treesitter = {
        stopline = 500,
      },
    },
  },
  { "nvim-treesitter/nvim-treesitter-context", event = "BufReadPost", config = true },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    opts = {
      install_dir = vim.fn.stdpath("data") .. "/site",
      ensure_installed = {
        "regex",
        "c",
        "diff",
        "gitcommit",
        "git_rebase",
        "vim",
        "vimdoc",
      },
      highlight_filetypes = {
        "c",
        "diff",
        "gitcommit",
        "gitrebase",
        "tmux",
        "vim",
      },
      indent_filetypes = {
        "c",
        "tmux",
        "vim",
      },
    },
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)

      require("nvim-treesitter").install(opts.ensure_installed)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = opts.highlight_filetypes,
        callback = function()
          -- Parser installation is asynchronous on a fresh setup. If the
          -- parser is not ready yet, highlighting starts the next time a
          -- buffer with this filetype opens.
          pcall(vim.treesitter.start)
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = opts.indent_filetypes,
        callback = function()
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
}
