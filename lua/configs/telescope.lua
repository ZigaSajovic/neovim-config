local nvt = require "nvchad.configs.telescope"
nvt.extensions_list = { "themes", "terms", "fzf" }
nvt.extensions = { ["ui-select"] = {
  require("telescope.themes").get_dropdown {},
} }
require("telescope").setup(nvt)
require("telescope").load_extension("ui-select")

return nvt
