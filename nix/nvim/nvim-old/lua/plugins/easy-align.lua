return {
  "junegunn/vim-easy-align",
  config = function()
    vim.keymap.set('x', 'ga', '<Plug>(EasyAlign)',
      { noremap = true, desc = "Start interactive EasyAlign in visual mode" })
    vim.keymap.set('n', 'ga', '<Plug>(EasyAlign)',
      { noremap = true, desc = "Start interactive EasyAlign for motion/text object" })
  end
}
