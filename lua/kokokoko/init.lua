local render = require("kokokoko.cursor_sign_render")
-- テーブルを作る
-- テーブルというのは JS で Object にあたる Luaの何か
-- プラグインでは慣例として変数は大文字の M 一文字にするらしい
-- 今ここに剥き出しで書いている処理はモジュールとよばれる単位になっていて
-- この local というのはこのファイル内でスコープを閉じる変数ということ
local M = {}


-- セットアップ用の関数をモジュールに生やす
function M.setup()
  require("kokokoko.sign_define").setup()

  vim.api.nvim_create_augroup('kokokoko', { clear = true })
  -- バッファ を見る
  vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter', 'TermLeave' }, {
    group = 'kokokoko',
    callback = function()
      -- 戻った瞬間の位置を1個前の位置として記録する
      vim.api.nvim_buf_set_var(0, 'kokokoko_prev_lnum', vim.fn.line('.'))
      -- その対象のバッファ変数が存在するか確認する
      local exists, my_var = pcall(vim.api.nvim_buf_get_var, 0, 'kokokoko_exist_dummy_sign')
      if exists then
        -- 何もしない
      else
        -- 存在しない場合セットして作る
        vim.api.nvim_buf_set_var(0, 'kokokoko_exist_dummy_sign', true)
        vim.fn.sign_place(0, "", "kokokoko_dummy", vim.api.nvim_get_current_buf(), { lnum = 1, priority = 0, })
      end
    end,
  })
  -- カーソルの動きを見る
  vim.api.nvim_create_autocmd(
    { 'CursorMoved', 'CursorMovedI', 'CmdlineChanged' },
    {
      group = 'kokokoko',
      callback = function()
        local cb = vim.api.nvim_get_current_buf()
        local prev_lnum = vim.api.nvim_buf_get_var(0, 'kokokoko_prev_lnum')
        local curt_lnum = vim.fn.line('.')
        local top_lnum = vim.fn.line('w0')
        local bottom_lnum = vim.fn.line('w$')
        local from_lnum = prev_lnum

        local speed = 300

        -- 動いてないならしない
        if curt_lnum == prev_lnum then
          return
        end
        -- 上から来ることを想定
        --
        if prev_lnum < top_lnum then
          from_lnum = top_lnum
        end
        -- 下から来ること想定
        if prev_lnum > bottom_lnum then
          from_lnum = bottom_lnum
        end

        render.render_range(cb, from_lnum, curt_lnum, speed)

        vim.api.nvim_buf_set_var(0, 'kokokoko_prev_lnum', curt_lnum)
      end,
    }
  )
end

-- テーブルを返す
-- モジュールを require された結果がこれになる。
return M
