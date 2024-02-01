return {
  "emmanueltouzery/elixir-extras.nvim",
  -- ft = "elixir",
  config = function()
    require("elixir-extras").setup_multiple_clause_gutter()
    vim.keymap.set('n', '<leader>de', ":lua require('elixir-extras').elixir_view_docs({})<CR>",
      { noremap = true, silent = true, desc = "Search Elixir hexdocs" })
    vim.keymap.set('n', '<leader>dm', ":lua require('elixir-extras').elixir_view_docs({include_mix_libs=true})<CR>",
      { noremap = true, silent = true, desc = "Search Elixir hexdocs with mix libraries" })
  end
}
