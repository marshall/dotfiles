local telescope = require('telescope')
local utils = require('utils')

telescope.setup {
  extensions = {
    project = {
      base_dirs = {
        {'~/Code', max_depth = 3},
        {'~/Code/loft-orbital/products/oort'},
        {'~/Code/loft-orbital/engineering/software', max_depth = 3},
      },
      hidden_files = true, -- default: false
      theme = "dropdown",
      sync_with_nvim_tree = true, -- default false
      on_project_selected = function(prompt_bufnr)
        local project_actions = require("telescope._extensions.project.actions")
        project_actions.change_working_directory(prompt_bufnr, false)
      end
    }
  }
}

telescope.load_extension('project')
utils.map('n', '<leader>p',
        ":lua require'telescope'.extensions.project.project { display_type = 'full' }<CR>",
        {noremap = true, silent = true}
)
