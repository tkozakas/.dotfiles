local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

require('core.options')
require('core.keymaps')
require('core.autocmds')
require('core.commands')
require('core.functions')
require('lazy').setup('plugins')

-- Auto-reload config on SIGUSR1
local signal = vim.loop.new_signal()
signal:start(10, function()
  vim.cmd('source $MYVIMRC')
  vim.notify('Neovim config reloaded', vim.log.levels.INFO)
end)
