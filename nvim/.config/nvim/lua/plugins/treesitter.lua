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
    },
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)

      require("nvim-treesitter").install({
        "regex",
        "bash",
        "c",
        "c_sharp",
        "diff",
        "html",
        "javascript",
        "json",
        "lua",
        "luadoc",
        "markdown",
        "typescript",
        "tsx",
        "vim",
        "vimdoc",
        "gitcommit",
        "git_rebase",
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "bash",
          "c",
          "cs",
          "diff",
          "gitcommit",
          "gitrebase",
          "html",
          "javascript",
          "javascriptreact",
          "json",
          "lua",
          "markdown",
          "tmux",
          "typescript",
          "typescriptreact",
          "vim",
        },
        callback = function()
          vim.treesitter.start()
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "bash",
          "c",
          "cs",
          "html",
          "javascript",
          "javascriptreact",
          "json",
          "lua",
          "markdown",
          "tmux",
          "typescript",
          "typescriptreact",
          "vim",
        },
        callback = function()
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
}
