P = function(v)
  print(vim.inspect(v))
  return v
end

RELOAD = function(...)
  return require("plenary.reload").reload_module(...)
end

R = function(name)
  RELOAD(name)
  return require(name)
end

SafeRequire = function(moduleName)
  local success, result = pcall(require, moduleName)
  return success and result or {}
end

InterestingAurDiffs = function()
  local files = vim.fn.glob("*.diff", true, true)

  for _, file in ipairs(files) do
    local lines = {}
    for line in io.lines(file) do
      table.insert(lines, line)
    end

    for _, line in ipairs(lines) do
      -- lines that do not affect our choice to open the file or not
      if line:match("^[+-][+-][+-] ./PKGBUILD") then
      elseif line:match("^[+-]") then
        -- Exclude lines that change pkgver or sums only
        if
          not (
            line:match("pkgver=")
            or line:match("_subver=")
            or line:match("_commit=")
            or line:match("pkgrel=")
            or line:match("_pkgvernum=")
            or line:match("sha256sums=")
            or line:match("sha256sums_x86_64=")
            or line:match("sha256sums_i686=")
            or line:match("sha256sums_armv7h=")
            or line:match("sha256sums_aarch64=")
            or line:match("sha512sums=")
            or line:match("sha512sums_x86_64=")
            or line:match("sha512sums_i686=")
            or line:match("sha512sums_armv7h=")
            or line:match("sha512sums_aarch64=")
          )
        then
          vim.cmd("edit " .. file)
          break
        end
      end
    end
  end
end
