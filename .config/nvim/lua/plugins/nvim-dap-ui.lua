-- Debugging Support
return {
  -- https://github.com/rcarriga/nvim-dap-ui
  'rcarriga/nvim-dap-ui',
  event = 'VeryLazy',
  dependencies = {
    -- https://github.com/mfussenegger/nvim-dap
    'mfussenegger/nvim-dap',
    -- https://github.com/theHamsta/nvim-dap-virtual-text
    'theHamsta/nvim-dap-virtual-text', -- inline variable text while debugging
    -- https://github.com/nvim-telescope/telescope-dap.nvim
    'nvim-telescope/telescope-dap.nvim', -- telescope integration with dap
  },
  opts = {
    controls = {
      element = "repl",
      enabled = false,
      icons = {
        disconnect = "",
        pause = "",
        play = "",
        run_last = "",
        step_back = "",
        step_into = "",
        step_out = "",
        step_over = "",
        terminate = ""
      }
    },
    element_mappings = {},
    expand_lines = true,
    floating = {
      border = "single",
      mappings = {
        close = { "q", "<Esc>" }
      }
    },
    force_buffers = true,
    icons = {
      collapsed = "",
      current_frame = "",
      expanded = ""
    },
    layouts = {
      {
        elements = {
          {
            id = "scopes",
            size = 0.50
          },
          {
            id = "stacks",
            size = 0.30
          },
          {
            id = "watches",
            size = 0.10
          },
          {
            id = "breakpoints",
            size = 0.10
          }
        },
        size = 40,
        position = "left", -- Can be "left" or "right"
      },
      {
        elements = {
          "repl",
          "console",
        },
        size = 10,
        position = "bottom", -- Can be "bottom" or "top"
      }
    },
    mappings = {
      edit = "e",
      expand = { "<CR>", "<2-LeftMouse>" },
      open = "o",
      remove = "d",
      repl = "r",
      toggle = "t"
    },
    render = {
      indent = 1,
      max_value_lines = 100
    }
  },
  config = function (_, opts)
    local dap = require('dap')
    require('dapui').setup(opts)

    dap.listeners.after.event_initialized["dapui_config"] = function()
      require('dapui').open()
    end

    dap.listeners.before.event_terminated["dapui_config"] = function()
      -- Commented to prevent DAP UI from closing when unit tests finish
      -- require('dapui').close()
    end

    dap.listeners.before.event_exited["dapui_config"] = function()
      -- Commented to prevent DAP UI from closing when unit tests finish
      -- require('dapui').close()
    end

    -- Add dap configurations based on your language/adapter settings
    -- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
    dap.configurations.java = {
      {
        --  gw integrationTest --tests com.tripadvisor.service.aps.web.queryAppListWebTest -Precord.contract=true --debug-jvm
        --  Set up port forwarding if you are debugging from intellij or remote machine
        --  ssh -L 5005:yoursled.sleds.dev.tripadvisor.com:5005 -o ServerAliveInterval=100 yoursled.sleds.dev.tripadvisor.com
        name = "Debug (Attach) - Remote used for tests",
        type = "java",
        request = "attach",
        hostName = "127.0.0.1",
        port = 5005,
      },
      {
        name = "Debug (Attach) - wps",
        type = "java",
        request = "attach",
        hostName = "mshakya-exp.sleds.dev.tripadvisor.com",
        vmArgs = '-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:17755',
        port = 17755,
      },
      {
        name = "Debug (Attach) - odmt",
        type = "java",
        request = "attach",
        hostName = "mshakya-exp.sleds.dev.tripadvisor.com",
        vmArgs = '-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:19433',
        port = 19433,
      },
      {
        name = "Debug (Attach) - shelf-service",
        type = "java",
        request = "attach",
        hostName = "mshakya-exp.sleds.dev.tripadvisor.com",
        vmArgs = '-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:18443',
        port = 18443,
      },
      {
        name = "Debug Non-Project class",
        type = "java",
        request = "launch",
        program = "${file}",
      },
    }
  end
}
