--- サインを定義するモジュール
local M = {}


function M.setup()
  vim.api.nvim_set_hl(0, 'KokokokoCurrent', { bg = nil, fg = '#E60012', default = true })
  vim.api.nvim_set_hl(0, 'KokokokoCurrentRed', { bg = nil, fg = '#E60012', default = true })
  vim.api.nvim_set_hl(0, 'KokokokoCurrentOrange', { bg = nil, fg = '#F39800', default = true })
  vim.api.nvim_set_hl(0, 'KokokokoCurrentYellow', { bg = nil, fg = '#FFF100', default = true })
  vim.api.nvim_set_hl(0, 'KokokokoCurrentGreen', { bg = nil, fg = '#009944', default = true })
  vim.api.nvim_set_hl(0, 'KokokokoCurrentAqua', { bg = nil, fg = '#0068B7', default = true })
  vim.api.nvim_set_hl(0, 'KokokokoCurrentBlue', { bg = nil, fg = '#1D2088', default = true })
  vim.api.nvim_set_hl(0, 'KokokokoCurrentPurple', { bg = nil, fg = '#920783', default = true })

  vim.fn.sign_define('kokokoko_dummy', { text = " ", texthl = nil, linehl = nil, })
  vim.fn.sign_define('kokokoko_current_0', { text = "▷", texthl = nil, linehl = nil, })
  vim.fn.sign_define('kokokoko_current_1', { text = '󰝥', texthl = "KokokokoCurrentRed", linehl = nil, })
  vim.fn.sign_define('kokokoko_current_2', { text = '󰝥', texthl = "KokokokoCurrentOrange", linehl = nil, })
  vim.fn.sign_define('kokokoko_current_3', { text = '●', texthl = "KokokokoCurrentYellow", linehl = nil, })
  vim.fn.sign_define('kokokoko_current_4', { text = '•', texthl = "KokokokoCurrentGreen", linehl = nil, })
  vim.fn.sign_define('kokokoko_current_5', { text = '•', texthl = "KokokokoCurrentAqua", linehl = nil, })
  vim.fn.sign_define('kokokoko_current_6', { text = '∙', texthl = "KokokokoCurrentBlue", linehl = nil, })
  vim.fn.sign_define('kokokoko_current_7', { text = '∙', texthl = "KokokokoCurrentPurple", linehl = nil, })
end

return M

