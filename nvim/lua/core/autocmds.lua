vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*Jenkinsfile*',
  callback = function()
    vim.bo.filetype = 'groovy'
  end,
  desc = 'Set Jenkinsfile filetype to groovy for syntax highlighting',
})

-- Auto-reload Neovim config
local reload_group = vim.api.nvim_create_augroup('auto-reload-config', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  group = reload_group,
  pattern = {
    vim.fn.stdpath('config') .. '/init.lua',
    vim.fn.stdpath('config') .. '/lua/**/*.lua',
  },
  callback = function()
    -- Clear all modules under lua/
    for k in pairs(package.loaded) do
      if k:match('^core') or k:match('^plugins') then
        package.loaded[k] = nil
      end
    end

    -- Re-run init.lua
    dofile(vim.fn.stdpath('config') .. '/init.lua')

    vim.notify('Nvim config reloaded!', vim.log.levels.INFO)
  end,
})
