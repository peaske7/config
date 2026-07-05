local wezterm = require('wezterm')
local config = wezterm.config_builder()

-- On Windows, default to PowerShell 7 (pwsh) instead of cmd.exe so that modern
-- tooling install one-liners (e.g. `irm https://.../install | iex`) work out of
-- the box. Guarded by target_triple so this is a no-op on macOS/Linux, where the
-- login shell is used as usual.
if wezterm.target_triple:find('windows') then
  config.default_prog = { 'pwsh.exe', '-NoLogo' }
end

return config
