require "nvchad.options"

vim.opt.termguicolors = true
vim.opt.clipboard = ""
vim.opt.mousemodel = "extend"
vim.cmd [[ set breakindent]]
vim.cmd [[ set copyindent]]
vim.cmd [[ set shiftround]]
vim.cmd [[ set undofile ]]
vim.cmd [[ set undodir=$HOME/.nvim/undo ]]
vim.cmd [[ set undolevels=1000 ]]
vim.cmd [[ set undoreload=10000 ]]
vim.cmd [[ set mat=1 ]]
vim.cmd [[ set showtabline=0 ]]
vim.cmd [[ set matchpairs+=<:> ]]
vim.o.guifont = "Liga SFMono Nerd Font"
if vim.g.neovide then
  vim.g.neovide_position_animation_length = 0
  vim.g.neovide_cursor_animation_length = 0.00
  vim.g.neovide_cursor_trail_size = 0
  vim.g.neovide_cursor_animate_in_insert_mode = false
  vim.g.neovide_cursor_animate_command_line = false
  vim.g.neovide_scroll_animation_far_lines = 0
  vim.g.neovide_scroll_animation_length = 0.00
  vim.g.neovide_floating_shadow = false
  vim.g.neovide_padding_top = 0
  vim.g.neovide_padding_bottom = 0
  vim.g.neovide_padding_right = 0
  vim.g.neovide_padding_left = 0
  vim.g.terminal_color_0 = "#003440"
  vim.g.terminal_color_1 = "#DC312E"
  vim.g.terminal_color_2 = "#859901"
  vim.g.terminal_color_3 = "#B58900"
  vim.g.terminal_color_4 = "#268AD2"
  vim.g.terminal_color_5 = "#D33582"
  vim.g.terminal_color_6 = "#2AA197"
  vim.g.terminal_color_7 = "#EEE8D5"
  vim.g.terminal_color_8 = "#002833"
  vim.g.terminal_color_9 = "#CB4A16"
  vim.g.terminal_color_10 = "#8DA634"
  vim.g.terminal_color_11 = "#C28F2C"
  vim.g.terminal_color_12 = "#0692D4"
  vim.g.terminal_color_13 = "#6C6EC6"
  vim.g.terminal_color_14 = "#00B3A7"
  vim.g.terminal_color_15 = "#FDF6E3"
  vim.api.nvim_set_keymap(
    "n",
    "<C-+>",
    ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.05<CR>",
    { silent = true }
  )
  vim.api.nvim_set_keymap(
    "n",
    "<C-->",
    ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.05<CR>",
    { silent = true }
  )
end
