-- Stole these from @akinsho
-- =============================================================================
-- Fold Text
-- =============================================================================

local M = {}

-- List of file types to use default fold text for
local fold_exclusions = { "vim" }

local function contains(str, pattern)
	assert(str and pattern, "str and pattern are required")
	return vim.fn.match(str, pattern) >= 0
end

local function prepare_fold_section(value)
	-- 1. Replace tabs
	local str = vim.fn.substitute(value, "\t", string.rep(" ", vim.bo.tabstop), "g")
	-- 2. getline returns the line leading white space so we remove it
	-- CREDIT: https://stackoverflow.com/questions/5992336/indenting-fold-text
	return vim.fn.substitute(str, [[^\s*]], "", "g")
end

local function is_ignored()
	return vim.wo.diff or vim.tbl_contains(fold_exclusions, vim.bo.filetype)
end

local function is_import(item)
	return contains(item, "^import")
end

--[[
  Naive regex to match closing delimiters (undoubtedly there are edge cases)
  if the fold text doesn't include delimiter characters just append an
  empty string. This avoids folds that look like function … end or
  import 'package'…import 'second-package'
  this fold text should handle cases like
  value.Member{
    Field : String
  }.Method()
  turns into
  value.Member{…}.Method()
--]]
local function contains_delimiter(value)
	return contains(value, [[}\|)\|]\|`\|>\|<]])
end

--[[
  We initially check if the fold start text is an import by looking for the
  'import' keyword at the Start of a line. If it is we replace the line with
  import … although if the fold end text contains a delimiter
  e.g.
  import {
    thing
  } from 'apple'
  '}' being a delimiter we instead allow normal folding to happen
  i.e.
  import {…} from 'apple'
--]]
local function handle_fold_start(start_text, end_text, foldsymbol)
	if is_import(start_text) and not contains_delimiter(end_text) then
		--- This regex matches anything after an import followed by a space
		--- this might not hold true for all languages but think it does
		--- for all the ones I use
		return vim.fn.substitute(start_text, [[^import .\+]], "import " .. foldsymbol, "")
	end
	return prepare_fold_section(start_text) .. foldsymbol
end

local function handle_fold_end(item)
	if not contains_delimiter(item) or is_import(item) then
		return ""
	end
	return prepare_fold_section(item)
end

function M.folds()
	if is_ignored() then
		return vim.fn.foldtext()
	end
	local end_text = vim.fn.getline(vim.v.foldend)
	local start_text = vim.fn.getline(vim.v.foldstart)
	local line_end = handle_fold_end(end_text)
	local line_start = handle_fold_start(start_text, end_text, "…")
	local line = line_start .. line_end
	local lines_count = vim.v.foldend - vim.v.foldstart + 1
	local count_text = string.format("(%d lines)", lines_count)
	local indentation = vim.fn.indent(vim.v.foldstart)
	local fold_start = string.rep(" ", indentation) .. line
	local fold_end = count_text .. string.rep(" ", 2)
	-- NOTE: foldcolumn can now be set to a value of auto:Count e.g auto:5
	-- so we split off the auto portion so we can still get the line count
	local parts = vim.split(vim.wo.foldcolumn, ":")
	local column_size = parts[#parts]
	local text_length = #vim.fn.substitute(fold_start .. fold_end, ".", "x", "g") + column_size
	return fold_start .. string.rep(" ", vim.api.nvim_win_get_width(0) - text_length - 7) .. fold_end
end

return M
-- CREDIT: https://coderwall.com/p/usd_cw/a-pretty-vim-foldtext-function
