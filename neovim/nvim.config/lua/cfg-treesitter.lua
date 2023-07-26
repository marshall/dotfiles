require('nvim-treesitter.configs').setup {
  -- One of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = {
    'bash',
    'c',
    'cmake',
    'cpp',
    'css',
    'cue',
    'dockerfile',
    'go',
    'graphql',
    'html',
    'java',
    'javascript',
    'jsdoc',
    'json',
    'kotlin',
    'lalrpop',
    'llvm',
    'lua',
    'make',
    'markdown',
    'ninja',
    'nix',
    'perl',
    'php',
    'python',
    'rst',
    'ruby',
    'rust',
    'scss',
    'solidity',
    'svelte',
    'toml',
    'tsx',
    'typescript',
    'vim',
    'vue',
    'yaml',
    'zig',
  },

  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
