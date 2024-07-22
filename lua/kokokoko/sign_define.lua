--- サインを定義するモジュール
local M = {
}

local KOKOKOKO_SIGN = {
  default = {
    { shape = '󰝥', color = '#E60012',},
    { shape = '󰝥', color = '#F39800',},
    { shape = '●', color = '#FFF100',},
    { shape = '•', color = '#009944',},
    { shape = '•', color = '#0068B7',},
    { shape = '∙', color = '#1D2088',},
    { shape = '∙', color = '#920783',},
  },
};



function M.setup()
  vim.fn.sign_define('kokokoko_dummy', { text = " ", texthl = nil, linehl = nil, })
  vim.fn.sign_define('kokokoko_current_0', { text = "▷", texthl = nil, linehl = nil, })
  vim.api.nvim_set_hl(0, 'KokokokoCurrent', { bg = nil, fg = '#E60012', default = true })

  local sign_name = "default"

  for i = 1, 7, 1 do
      vim.api.nvim_set_hl(0, 'KokokokoColor' .. sign_name .. i, { bg = nil, fg = KOKOKOKO_SIGN[sign_name][i]["color"], default = true })
  end

  -- Lua のテーブルの index は 1 からスタートする
  -- defalut で作る
  for i = 1, 7, 1 do
    vim.fn.sign_define(
      "kokokoko_sign_" .. sign_name .. "_" .. i,
      {
        text = KOKOKOKO_SIGN[sign_name][i]["shape"],
        texthl = "KokokokoColor" .. sign_name .. i,
        linehl = nil,
      })
  end
end

function M.get_point_sign_name(_type, _n)
  return 'kokokoko_sign_' .. _type .. "_"  .. _n
end

return M

