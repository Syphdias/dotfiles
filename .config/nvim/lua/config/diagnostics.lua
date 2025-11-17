---@type integer
DIAGNOSTICS_LEVEL = 5 -- TODO: test 3

---@alias DiagnosticsOnCursor false|"virtual_text"|"virtual_text_or_lines"
---@type DiagnosticsOnCursor
DIAGNOSTICS_ON_CURSOR = false

local signs = { text = { " ", " ", " ", " " } }
local virtual_text = { prefix = "●", source = "if_many", spacing = 4 }
local virtual_text_error = vim.tbl_extend("force", virtual_text, { severity = vim.diagnostic.severity.ERROR })
local current_line_error = { current_line = true, severity = vim.diagnostic.severity.ERROR }
local current_line = { current_line = true }
local virtual_text_current_line = vim.tbl_extend("force", virtual_text, current_line)

---@param param integer|table
---  - number: Set absolute diagnostic level (1-7)
---  - table: Relative change with {change=number}
---@param notify? boolean: Notify current level and if at min/max
---@return nil
ChangeDiagnosticsLevel = function(param, notify)
  if notify == nil then
    notify = true
  end
  ---@type {name: string, config: vim.diagnostic.Opts, cursor: DiagnosticsOnCursor}[]
  local diagnostics_levels = {
    {
      name = "Off",
      config = { signs = false, underline = false, virtual_text = false, virtual_lines = false },
      cursor = false,
    },
    {
      name = "Signs and Underline",
      config = { signs = signs, underline = true, virtual_text = false, virtual_lines = false },
      cursor = false,
    },
    {
      name = "Text on current",
      config = { signs = signs, underline = true, virtual_text = virtual_text_current_line, virtual_lines = false },
      cursor = false,
    },
    {
      name = "Error only, text on current (requires hack)",
      config = { signs = signs, underline = true, virtual_text = virtual_text_error, virtual_lines = false },
      cursor = "virtual_text",
    },
    {
      name = "Error only, text/lines on current (requires hack)",
      config = { signs = signs, underline = true, virtual_text = virtual_text_error, virtual_lines = false },
      cursor = "virtual_text_or_lines", -- separeate ns for curline needed, as long as it is not smart (1:text, >1:lines)
    },
    {
      name = "Errors only, errors lines on current",
      config = {
        signs = signs,
        underline = true,
        virtual_text = virtual_text_error,
        virtual_lines = current_line_error,
      },
      cursor = false,
    },
    {
      name = "All text",
      config = { signs = signs, underline = true, virtual_text = virtual_text, virtual_lines = false },
      cursor = false,
    },
    {
      name = "All text, lines on current",
      config = { signs = signs, underline = true, virtual_text = virtual_text, virtual_lines = current_line },
      cursor = false,
    },
    {
      name = "All lines",
      config = { signs = signs, underline = true, virtual_text = false, virtual_lines = true },
      cursor = false,
    },
  }

  local new_level
  if type(param) == "table" then
    new_level = DIAGNOSTICS_LEVEL + param.change
  else
    new_level = param
  end

  if diagnostics_levels[new_level]["config"] then
    DIAGNOSTICS_LEVEL = new_level
    DIAGNOSTICS_ON_CURSOR = diagnostics_levels[DIAGNOSTICS_LEVEL]["cursor"]
    vim.diagnostic.config(diagnostics_levels[DIAGNOSTICS_LEVEL]["config"])
    if notify then
      vim.notify(
        "Diagnostics at "
          .. DIAGNOSTICS_LEVEL
          .. "/"
          .. #diagnostics_levels
          .. "\n"
          .. diagnostics_levels[DIAGNOSTICS_LEVEL]["name"]
      )
    end
  end

  if DIAGNOSTICS_LEVEL == 1 then
    vim.notify("Diagnostics at minimum\n" .. diagnostics_levels[DIAGNOSTICS_LEVEL]["name"])
  elseif DIAGNOSTICS_LEVEL == #diagnostics_levels then
    vim.notify("Diagnostics at maximum\n" .. diagnostics_levels[DIAGNOSTICS_LEVEL]["name"] .. " " .. DIAGNOSTICS_LEVEL)
  end
end

local ns = vim.api.nvim_create_namespace("CurlineDiag")

vim.api.nvim_create_autocmd("LspDetach", {
  callback = function(args)
    vim.diagnostic.hide(ns, args.buf)
  end,
})

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function(args)
    if DIAGNOSTICS_ON_CURSOR == false then
      vim.diagnostic.hide(ns, args.buf)
      return
    end

    -- dismiss other lines
    pcall(vim.api.nvim_buf_clear_namespace, args.buf, ns, 0, -1)

    local curline = vim.api.nvim_win_get_cursor(0)[1]
    local diagnostics = vim.diagnostic.get(args.buf, { lnum = curline - 1 })

    if DIAGNOSTICS_ON_CURSOR == "virtual_text_or_lines" and #diagnostics > 1 then
      vim.diagnostic.show(ns, args.buf, diagnostics, {
        signs = signs,
        underline = true,
        virtual_text = false,
        virtual_lines = current_line,
      })
    else
      vim.diagnostic.show(ns, args.buf, diagnostics, {
        signs = signs,
        underline = true,
        virtual_text = virtual_text_current_line,
        virtual_lines = false,
      })
    end
  end,
})

-- set default diagnostics level once
local diagnostics_initialized = false
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function()
    if not diagnostics_initialized then
      ChangeDiagnosticsLevel(DIAGNOSTICS_LEVEL, false)
      diagnostics_initialized = true
    end
  end,
})
