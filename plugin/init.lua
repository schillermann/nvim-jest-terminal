local function get_current_line()
  local current_line_number = vim.fn.line('.')
  return vim.fn.getline(current_line_number)
end

local function get_test_description()
  return get_current_line():match('it%([\'"](.+)[\'"]')
end

local function start_terminal_with_insert_mode(directory)
  vim.cmd.vsplit()
  vim.cmd.terminal()
  vim.api.nvim_chan_send(vim.bo.channel, "cd " .. directory .. "\r")
  vim.api.nvim_feedkeys("a", "t", false)
end

vim.api.nvim_create_user_command('JestSingleInTerminal', function(opts)
  local testDescription = get_test_description()
  if testDescription == nil then
    vim.notify("No test description found under the cursor.", vim.log.levels.INFO)
    return
  end

  local fullPath = vim.api.nvim_buf_get_name(0)
  local filepath = vim.fn.fnamemodify(fullPath, ":h")
  local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':t')

  start_terminal_with_insert_mode(filepath)
  vim.api.nvim_feedkeys('jest ' .. filename .. ' -t "' .. testDescription .. '"', "t", true)
end, { nargs = 0 })

vim.api.nvim_create_user_command('JestFileInTerminal', function(opts)
  local fullPath = vim.api.nvim_buf_get_name(0)
  local filepath = vim.fn.fnamemodify(fullPath, ":h")
  local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':t')

  start_terminal_with_insert_mode(filepath)
  vim.api.nvim_feedkeys("jest " .. filename, "t", true)
end, { nargs = 0 })
