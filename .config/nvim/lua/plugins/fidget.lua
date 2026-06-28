-- Fidget: LSP progress notifications.
-- Handles LSP servers (like dartls) that send non-string progress message data.

return {
  {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    opts = {
      notification = {
        override_vim_notify = false,
        window = {
          winblend = 0,
          border = "none",
          normal_hl = "Normal",
          name = "Fidget",
        },
      },
      progress = {
        display = {
          done_ttl = 1,
          done_icon = "✓",
          spinner = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
          format_message = function(msg)
            local m = msg.message
            if type(m) ~= "string" then
              m = vim.inspect(m)
            end
            if m == "" or m == nil then
              m = msg.done and "Completed" or "In progress..."
            end
            if type(msg.percentage) == "number" then
              m = string.format("%s (%.0f%%)", m, msg.percentage)
            elseif type(msg.percentage) == "string" then
              m = string.format("%s (%s)", m, msg.percentage)
            end
            return m
          end,
        },
      },
    },
    config = function(_, opts)
      require("fidget").setup(opts)
    end,
  },
}
