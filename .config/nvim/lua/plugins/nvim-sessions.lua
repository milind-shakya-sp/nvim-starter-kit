-- Nvim sessions
-- https://github.com/rmagatti/auto-session
return {
      'rmagatti/auto-session',
      opts = {
        auto_session_enable_last_session = vim.loop.cwd() == vim.loop.os_homedir(),
  }
}
