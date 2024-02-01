return {
  "nvim-telescope/telescope-symbols.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    vim.keymap.set("n", "<Leader>si", ":lua require'telescope.builtin'.symbols{ sources = {'gitmoji'} }<CR>",
      { noremap = true, silent = true, desc = "[S]earch [I]con" })
  end
}
