local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local previewers = require "telescope.previewers"
local conf = require("telescope.config").values
local Job = require "plenary.job"

local M = {}

local git_commit_impl = function(opts)
  local default_opts = {
    cwd = vim.fn.expand "%:p:h",
    file = nil,
  }

  opts = vim.tbl_deep_extend("force", default_opts, opts or {})

  -- Base git log command
  local git_command = {
    "git",
    "-C",
    opts.cwd,
    "log",
    "--pretty=format:%h %ad %s",
    "--date=format:%Y-%d-%m",
    "--abbrev-commit",
  }

  if opts.file then
    vim.list_extend(git_command, { "--follow", "--", opts.file })
  end

  local make_preview_args = function(commit_hash)
    if opts.file then
      return { "-C", opts.cwd, "diff", commit_hash .. "^", commit_hash, "--", opts.file }
    else
      return { "-C", opts.cwd, "diff", commit_hash .. "^", commit_hash }
    end
  end

  Job:new({
    command = git_command[1],
    args = vim.list_slice(git_command, 2),
    on_exit = function(job, return_val)
      if return_val ~= 0 then
        vim.notify("Failed to fetch git logs", vim.log.levels.ERROR)
        return
      end

      local commits = job:result()

      vim.schedule(function()
        pickers
          .new({}, {
            prompt_title = "Buffer Commits",
            finder = finders.new_table {
              results = commits,
              entry_maker = function(entry)
                local commit_hash = entry:match "^(%S+)"
                local date, message = entry:match "^%S+%s+(%S+)%s+(.+)$"

                local displayer = require("telescope.pickers.entry_display").create {
                  separator = " ",
                  items = {
                    { width = 7 }, -- Commit hash
                    { width = 10 }, -- Date
                    { remaining = true }, -- Commit message
                  },
                }
                return {
                  value = entry,
                  display = function(_)
                    -- Create the display using the displayer
                    return displayer {
                      { commit_hash, "TelescopeResultsIdentifier" },
                      { date, "TelescopeResultsNumber" },
                      message,
                    }
                  end,
                  ordinal = message, -- Use the commit message for sorting
                }
              end,
            },
            sorter = conf.generic_sorter {},

            previewer = previewers.new_buffer_previewer {
              define_preview = function(self, entry, _)
                local commit_hash = entry.value:match "^%S+" -- Extract commit hash
                if not commit_hash then
                  return
                end

                -- Run `git diff` to get the diff for the selected commit
                Job:new({
                  command = "git",
                  args = make_preview_args(commit_hash),
                  on_exit = function(diff_job)
                    local diff_output = diff_job:result()
                    vim.schedule(function()
                      local bufnr = self.state.bufnr
                      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, diff_output)

                      -- Apply diff syntax highlighting
                      vim.api.nvim_set_option_value("filetype", "diff", { buf = bufnr })
                    end)
                  end,
                }):start()
              end,
            },
            attach_mappings = function(prompt_bufnr, map)
              local function get_selected_commit()
                local entry = action_state.get_selected_entry()
                return entry.value:match "^%S+"
              end

              -- Example mappings
              if opts.file then
                map("i", "<C-d>", function()
                  local commit_hash = get_selected_commit()
                  actions.close(prompt_bufnr)
                  vim.cmd("tabnew " .. opts.file .. "| Gdiffsplit " .. commit_hash)
                end)
              else
                map("i", "<C-d>", function()
                  local commit_hash = get_selected_commit()
                  actions.close(prompt_bufnr)
                  vim.cmd("tabnew  | Git difftool " .. commit_hash)
                end)
              end

              map("i", "<C-c>", function()
                local commit_hash = get_selected_commit()
                actions.close(prompt_bufnr)
                vim.cmd("Git checkout " .. commit_hash)
              end)

              map("i", "<C-y>", function()
                local commit_hash = get_selected_commit()
                vim.fn.setreg("+", commit_hash)
                vim.notify("Copied commit hash: " .. commit_hash, vim.log.levels.INFO)
              end)

              return true
            end,
          })
          :find()
      end)
    end,
  }):start()
end

M.buffer = function()
  git_commit_impl { file = vim.fn.expand "%:p" }
end

M.repo = function()
  git_commit_impl { file = nil }
end

return M
