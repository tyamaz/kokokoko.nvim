local timer_util = require("kokokoko.timer_util")
local sign = require("kokokoko.sign_define")
local M = {}

--- 対象行が折りたたまれているか否か
--- @param buffer any 対象のバッファ
--- @param line any 対象の行 1 始まり
--- @return unknown
local function is_folded(buffer, line)
  return vim.api.nvim_buf_call(buffer, function()
    return vim.fn.foldclosed(line) ~= -1
  end)
end

local function count_line_without_folded(buffer, from_lnum, to_lnum)
  local updown = from_lnum > to_lnum and -1 or 1
  local cnt = 0

  for i = from_lnum, to_lnum, updown do
    -- 折れて表示されてなかったら
    if is_folded(buffer, i) then
      cnt = cnt + 1
    end
  end

  return cnt
end


--- 1コマ分のサイン描画
--- 描画されたサインは指定時間後に勝手に消える
--- @param buffer any
--- @param lnum any
--- @param sign any
--- @param priority any
--- @param delay any
local function render_one(buffer, lnum, sign, priority, delay)
  -- サイン描画
  -- 明示的な溜めはなくおそらく即時に画面描画される
  local current_pointer_sign_id = vim.fn.sign_place(
    0,  -- sign_id の自動採番指定
    "kokokoko_current_pointer_group",   -- 一応グループ指定 現状の実装では何も使って無い
    sign,                               -- 描画したいサインそのもの
    buffer,  -- 現在のバッファ
    {
      lnum = lnum,  -- 行指定
      priority = priority,  -- priority 指定 数字がデカいほど優先で描画される
    }
  )

  -- 指定秒後に勝手に消す
  timer_util.setTimeout(
      function()
        -- ローカル変数をクロージャで関数内に持ち込んでいるため外部で管理しなくてもよい
        -- id 指定で入れ込んだサインを消す
         -- 明示的な溜めはなくおそらく即時に消える
        vim.fn.sign_unplace('kokokoko_current_pointer_group', { buffer = buffer, id = current_pointer_sign_id })
      end,
      delay)  -- 消すまでの時間、
end

--- 1行分の描画
---@param buffer any 対象のバッファ
---@param lnum any 対象の行
---@param speed any 何ミリ秒 表示するか
function M.render(buffer, lnum, speed)
  -- 最低の優先度、優先度で重ね合わせで表示コントロールしている
  local base_priority = 1000

  -- 1コマに使える秒数計算
  local koma_msec = math.floor(speed / 7)

  -- 優先度を変えて7個の違うサインを同じ行に同時描画する
  -- 優先度の高いサインほど描画されている時間を短く指定しているので
  -- 優先度高 → 低 に向かって表示が切り替わるかのように表示される
  -- つまりアニメーションする
  for i = 1, 7, 1 do
    render_one(buffer, lnum, sign.get_point_sign_name("default", i), base_priority + 8 - i, koma_msec * i)
  end
end

--- from to を指定してその間を連続的にカーソルの軌跡を示すためのサインを描画する
---@param buffer any 対象のバッファ
---@param from_lnum  any 出発の行番号
---@param to_lnum any 到達の行番号
---@param speed any その間に何ミリ秒で到達するか
function M.render_range(buffer, from_lnum, to_lnum, speed)
  -- 移動方向を決める up -1   down 1
  local updown = from_lnum > to_lnum and -1 or 1

  -- 1つ手前までとする
  -- 短い距離での移動で、始点終点が被るのを避ける
  local goal_lnum = to_lnum - updown
  -- 距離を求める
  local dist = math.abs(from_lnum - to_lnum)
  dist = dist - count_line_without_folded(buffer, from_lnum, to_lnum)

  -- 1行あたりに使える秒数(ミリ)
  local line_msec = math.floor(speed / dist)
  -- 最低を調整
  if line_msec == 0 then
    line_msec = 1
  end

  -- 何行折りたたみ行を抜けたかのカウンタ
  local count_fold_line = 0

  -- 複数行にアニメーションするサインを入れ込む
  -- 終点に近い側を少しずつ遅延させて描画開始することによって
  -- 始点側から進んでいるように思わせる画
  -- 出発から到達まで1行ずつループする
  for i = from_lnum, goal_lnum, updown do
    -- 折れて表示されてなかったら
    if is_folded(buffer, i) then
      count_fold_line = count_fold_line + 1
      goto continue
    end
    -- 到達点に近いほど長時間表示されている必要がある
    -- ので描画開始を遅延する 実際の行よりも折りたたみがあった場合は遅延が減る
    local order = math.abs(i - from_lnum) - count_fold_line
    -- 出発点に近いほうから処理
    -- 実際には高速にループしているので描画は全行同時に行われる
    -- 出発点近い方がより速く減衰する
    timer_util.setTimeout(
      function()
        M.render(buffer, i, speed)
      end,
      line_msec * order  -- これが軌跡の進むスピード
    )
    -- 見えない行はスキップ
    ::continue::
  end
end

return M

