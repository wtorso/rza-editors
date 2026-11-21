# RZA Editors

[Русская версия](README.ru.md)

Lightweight syntax highlighting for `.rza` files in Emacs and Neovim.
The RZA compiler is not required for highlighting, and no private repository
access is needed.

## Features

- All RZA instruction keywords.
- Layout names, `u8`, `i8`, `u16`, `i16`, `u32`, `i32`, and `i64` scalar types,
  and `.field` selectors.
- Registers from `%r0` through `%r15`.
- Procedure and ordinary labels.
- Decimal and hexadecimal integers, including negative values and array counts.
- The `field` constant and `;` comments.

These modes do not provide semantic diagnostics, LSP, tree-sitter parsing,
indentation, or formatting. Use the RZA compiler for validation. Separate Vim
support is not tested or promised; Neovim uses its built-in Vimscript support.

## Install

Clone the repository:

```sh
git clone --depth 1 https://github.com/wtorso/rza-editors.git
```

### Emacs

Add this to your Emacs configuration, replacing the path with your checkout:

```elisp
(add-to-list 'load-path "/absolute/path/to/rza-editors/emacs")
(require 'rza-mode)
```

Opening a `.rza` file now selects `rza-mode`. You can also run `M-x rza-mode`.
The mode uses only Emacs' built-in `prog-mode`, syntax table, and font-lock.

### Neovim

Add this to `init.lua`, replacing the path with your checkout:

```lua
vim.opt.runtimepath:append("/absolute/path/to/rza-editors/nvim")
vim.cmd("filetype plugin on")
vim.cmd("syntax enable")
```

Restart Neovim after changing the configuration. The plugin sets the `rza`
filetype and `; %s` comment string automatically. It requires no external plugin
manager or tree-sitter grammar.

## Verify

Install `emacs` and `nvim` with your package manager, then run:

```sh
bash test/run.sh
```

The runner checks byte compilation, seven ERT tests, and real headless Neovim
`synID`/filetype assertions. It covers instruction keywords, layout types,
registers, invalid `%r16`, numeric forms, fields, labels, and comment masking.

CI runs the same command on Ubuntu with `emacs-nox` and `neovim`.

## References

The repository layout follows [C3 editor plugins](https://github.com/c3lang/editor-plugins).
The simple Emacs approach is inspired by [rexim/simpc-mode](https://github.com/rexim/simpc-mode).
RZA token rules and tests are implemented independently for this language.

License: [MIT](LICENSE).
