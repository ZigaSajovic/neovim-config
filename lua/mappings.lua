require "nvchad.mappings"

local map = vim.keymap.set
local unmap = vim.keymap.del

local disabled_mappings =
  { "<C-c>", "<leader>b", "H", "L", "<leader>e", "<leader>q", "<C-n>", "<tab>", "<S-tab>", "<leader>x" }

for _, mapping in ipairs(disabled_mappings) do
  local _, _ = pcall(unmap, { "n" }, mapping)
end

map({ "n", "x" }, "j", "gj")
map({ "n", "x" }, "k", "gk")
map({ "n", "x" }, "<UP>", "gk")
map({ "n", "x" }, "<DOWN>", "gj")
map("v", "p", function()
  local register = vim.v.register -- Get the currently active register (e.g., "w, "e)
  vim.cmd 'normal! "_d' -- Delete the selection without affecting registers
  vim.cmd('normal! "' .. register .. "P") -- Paste using the specified register
end, { noremap = true, silent = true })
map({ "n", "x" }, "_d", [["_d]], { desc = "Delete to null" })
map({ "n", "x" }, "_D", [["_D]], { desc = "Delete to null" })
map({ "n", "x" }, ",d", [["+d]], { desc = "Cut to system register" })
map({ "n", "x" }, ",D", [["+D]], { desc = "Cut to system register" })
map({ "n", "x" }, ",p", [["+p]], { desc = "Paste from system register" })
map({ "n", "x" }, ",P", [["+P]], { desc = "Paste from system register" })
map({ "n", "x" }, ",y", [["+y]], { desc = "Yank to system register" })
map({ "n", "x" }, ",Y", [["+Y]], { desc = "Yank to system register" })
map({ "n", "x", "o" }, "H", "^", { desc = "Go to begining of line" })
map({ "n", "x", "o" }, "L", "g_", { desc = "Go to end of line" })
-- map({"n"}, "<leader>fm",  vim.lsp.buf.format, "Format file" },
map({ "n" }, "<C-M-J>", "<cmd> resize -5<cr>", { desc = "Horizontal resize -5" })
map({ "n" }, "<C-M-K>", "<cmd> resize +5<cr>", { desc = "Horizontal resize +5" })
map({ "n" }, "<C-M-H>", "<cmd> vertical resize -5<cr>", { desc = "Vertical resize -5" })
map({ "n" }, "<C-M-L>", "<cmd> vertical resize +5<cr>", { desc = "Vertical resize +5" })
map({ "n" }, "<leader>ln", "<cmd> lnext<cr>", { desc = "Loclist next" })
map({ "n" }, "<leader>lp", "<cmd> lnext<cr>", { desc = "Loclist prev" })
map({ "n" }, "<leader>lc", "<cmd> lnext<cr>", { desc = "Loclist close" })
map({ "n" }, "<leader>qn", "<cmd> cnext<cr>", { desc = "Quickfix next" })
map({ "n" }, "<leader>qp", "<cmd> cprev<cr>", { desc = "Quickfix prev" })
map({ "n" }, "<leader>qc", "<cmd> cclose<cr>", { desc = "Quickfix close" })
map({ "n" }, "<leader>qo", function()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win["quickfix"] == 1 then
      qf_exists = true
    end
  end
  if qf_exists == true then
    vim.cmd "cclose"
    return
  end
  if not vim.tbl_isempty(vim.fn.getqflist()) then
    vim.cmd "copen"
  end
end, { desc = "Toggle quickfix" })
map({ "n" }, "<leader>lo", function()
  for _, info in ipairs(vim.fn.getwininfo()) do
    if info.loclist == 1 then
      vim.cmd "lclose"
      return
    end
  end

  if next(vim.fn.getloclist(0)) == nil then
    print "loc list empty"
    return
  end
  vim.cmd "lopen"
end, { desc = "Toggle loclist" })

map({ "n" }, "<C-h>", "<C-w>h", { desc = "Window left" })
map({ "n" }, "<C-l>", "<C-w>l", { desc = "Window right" })
map({ "n" }, "<C-j>", "<C-w>j", { desc = "Window down" })
map({ "n" }, "<C-k>", "<C-w>k", { desc = "Window up" })

map({ "n" }, "<C-h>", [[<C-\><C-n><C-w>h]], { desc = "Window left" })
map({ "n" }, "<C-l>", [[<C-\><C-n><C-w>l]], { desc = "Window right" })
map({ "n" }, "<C-j>", [[<C-\><C-n><C-w>j]], { desc = "Window down" })
map({ "n" }, "<C-k>", [[<C-\><C-n><C-w>k]], { desc = "Window up" })

map({ "n" }, "<leader>tt", "<cmd> Telescope telescope-tabs list_tabs<cr>", { desc = "List of tabs" })
map("n", "<leader>tr", "<cmd> Telescope resume<cr>", { desc = "Resume telescope" })
map("n", "<leader>gr", "<cmd> Telescope lsp_references<cr>", { desc = "Lsp references" })
map("n", "<leader>gd", "<cmd> Telescope lsp_definitions<cr>", { desc = "Lsp definitions" })
map("n", "<leader>ds", "<cmd> Telescope lsp_document_symbols<cr>", { desc = "Lsp document symbols" })
map("n", "<leader>ps", "<cmd> Telescope lsp_workspace_symbols<cr>", { desc = "Lsp workspace symbols" })
map("n", "<leader>ws", "<cmd> Telescope lsp_dynamic_workspace_symbols<cr>", { desc = "Lsp dynamic workspace symbols" })
map("n", "<leader>ld", "<cmd> Telescope diagnostics<cr>", { desc = "Lsp diagnostics" })
map("n", "<leader>fg", "<cmd> Telescope git_files<cr>", { desc = "Find git files" })
map("n", "<leader>jl", "<cmd> Telescope jumplist<cr>", { desc = "Jump list" })
map("n", "<leader>qf", "<cmd> Telescope quickfix<cr>", { desc = "Quickfix" })
map("n", "<leader>qh", "<cmd> Telescope quickfixhistory<cr>", { desc = "Quickfix history" })
map("n", "<leader>ll", "<cmd> Telescope loclist<cr>", { desc = "Loclist" })

map("n", "<leader>fb", function()
  require("telescope.builtin").buffers {
    only_cwd = vim.fn.haslocaldir(-1) == 1,
  }
end, { desc = "Buffers" })

map("n", "<leader>tb", function()
  require("telescope.builtin").git_branches {
    cwd = vim.fn.expand "%:p:h",
  }
end, { desc = "Branches" })

map("n", "<leader>tc", function()
  require("functional.git.commits").buffer()
end, { desc = "Buffer commits" })

map("n", "<leader>tC", function()
  require("functional.git.commits").repo()
end, { desc = "Repo commits" })


map("n", "z=", "", { desc = "Unmap default spell suggest" }) -- Unmap default
map("n", "z=", function()
  require("telescope.builtin").spell_suggest()
end, {desc = "Spell suggest"})
