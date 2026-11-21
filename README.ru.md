# RZA Editors

[English version](README.md)

Лёгкая подсветка синтаксиса `.rza` для Emacs и Neovim. Компилятор RZA для
подсветки не требуется, доступ к приватному репозиторию не нужен.

## Возможности

- Все ключевые слова инструкций RZA.
- Имена layouts, скалярные типы `u8`, `i8`, `u16`, `i16`, `u32`, `i32` и `i64`,
  селекторы `.field`.
- Регистры от `%r0` до `%r15`.
- Метки процедур и обычные метки.
- Десятичные и шестнадцатеричные числа, отрицательные значения и размеры массивов.
- Константа `field` и комментарии начиная с `;`.

Семантической диагностики, LSP, tree-sitter, indentation и форматирования нет.
Для проверки программы используйте компилятор RZA. Отдельная поддержка Vim не
тестируется и не обещается: Neovim использует встроенную поддержку Vimscript.

## Установка

Склонируйте репозиторий:

```sh
git clone --depth 1 https://github.com/wtorso/rza-editors.git
```

### Emacs

Добавьте в конфигурацию Emacs, заменив путь на расположение вашего checkout:

```elisp
(add-to-list 'load-path "/absolute/path/to/rza-editors/emacs")
(require 'rza-mode)
```

При открытии `.rza` включается `rza-mode`. Можно также выполнить `M-x rza-mode`.
Используются только встроенные `prog-mode`, syntax table и font-lock.

### Neovim

Добавьте в `init.lua`, заменив путь на расположение вашего checkout:

```lua
vim.opt.runtimepath:append("/absolute/path/to/rza-editors/nvim")
vim.cmd("filetype plugin on")
vim.cmd("syntax enable")
```

После изменения конфигурации перезапустите Neovim. Плагин автоматически задаёт
filetype `rza` и commentstring `; %s`. Менеджер плагинов и tree-sitter grammar
не требуются.

## Проверка

Установите `emacs` и `nvim` через пакетный менеджер, затем выполните:

```sh
bash test/run.sh
```

Runner проверяет byte compilation, семь ERT tests и настоящие headless Neovim
`synID`/filetype assertions: инструкции, layouts, регистры, неверный `%r16`,
числа, поля, метки и маскировку комментариев.

CI выполняет ту же команду на Ubuntu с `emacs-nox` и `neovim`.

## Источники

Структура репозитория повторяет [C3 editor plugins](https://github.com/c3lang/editor-plugins).
Простой подход к Emacs вдохновлён [rexim/simpc-mode](https://github.com/rexim/simpc-mode).
Правила токенов и тесты независимо реализованы для языка RZA.

Лицензия: [MIT](LICENSE).
