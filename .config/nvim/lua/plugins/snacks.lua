return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          files = {
            hidden = true, -- Show hidden files (dot files)
            follow = false, -- Also follow symlinks
          },
          grep = {
            hidden = true,
            follow = false,
          },
        },
      },
    },
  },
}

