DIAGNOSTICS_LEVEL = 4
---@param param number|table
---  - number: Set absolute diagnostic level (1-6)
---  - table: Relative change with {change=number}
---@return nil
ChangeDiagnosticsLevel = function(param)
  local diagnostics_signs = { text = { " ", " ", " ", " " } }
  local diagnostics_virtual_text = { prefix = "●", source = "if_many", spacing = 4 }
  local diagnostics_configs = {
    -- off
    { signs = false, underline = false, virtual_text = false, virtual_lines = false },
    -- +signs
    { signs = diagnostics_signs, underline = false, virtual_text = false, virtual_lines = false },
    -- +underline
    { signs = diagnostics_signs, underline = true, virtual_text = false, virtual_lines = false },
    -- +text but only for errors
    {
      signs = diagnostics_signs,
      underline = true,
      virtual_text = {
        prefix = "●",
        source = "if_many",
        spacing = 4,
        severity = vim.diagnostic.severity.ERROR,
      },
      virtual_lines = false,
    },
    -- +text at end of line
    { signs = diagnostics_signs, underline = true, virtual_text = diagnostics_virtual_text, virtual_lines = false },
    -- text as multiline
    { signs = diagnostics_signs, underline = true, virtual_text = false, virtual_lines = true },
  }

  local new_level
  if type(param) == "table" then
    new_level = DIAGNOSTICS_LEVEL + param.change
  else
    new_level = param
  end

  if diagnostics_configs[new_level] then
    DIAGNOSTICS_LEVEL = new_level
    vim.diagnostic.config(diagnostics_configs[DIAGNOSTICS_LEVEL])
  end

  if DIAGNOSTICS_LEVEL == 1 then
    print("Diagnostics at minimum")
  elseif DIAGNOSTICS_LEVEL == #diagnostics_configs then
    print("Diagnostics at maximum")
  end
end
