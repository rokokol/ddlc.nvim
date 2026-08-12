<div align="center">

# ddlc.nvim

**Цветовая схема Doki Doki Literature Club для neovim, светлая и тёмная** （´ω｀♡%）

![neovim](https://img.shields.io/badge/neovim-0.10%2B-76C332?style=flat&logo=neovim&logoColor=white)
![Nix](https://img.shields.io/badge/Nix-flake-7EBAE4?style=flat&logo=nixos&logoColor=white)
[![palette](https://img.shields.io/badge/colours-ddlc--palette-FF80C0?style=flat)](https://github.com/rokokol/ddlc-palette)
[![license](https://img.shields.io/badge/MIT-3DA639?style=flat)](LICENSE)
[![build](https://github.com/rokokol/ddlc.nvim/actions/workflows/build.yml/badge.svg)](https://github.com/rokokol/ddlc.nvim/actions/workflows/build.yml)

[English](README.md)

</div>

Каждый цвет снят с [ddlc.moe](https://ddlc.moe) палитрой [ddlc-palette](https://github.com/rokokol/ddlc-palette) и приезжает сюда base16-схемой — тема решает только то, какой слот куда идёт. Базовые группы, захваты treesitter, семантические токены и диагностика LSP, плюс интеграция с telescope

Приехало из моего райса, **[rokokol/huix](https://github.com/rokokol/huix)**

## Содержание

- [Как выглядит](#как-выглядит)
- [Установка](#установка)
  - [lazy.nvim](#lazynvim)
  - [nixvim](#nixvim)
  - [Без менеджера плагинов](#без-менеджера-плагинов)
- [Опции](#опции)
- [Прозрачность](#прозрачность)
- [Что покрыто](#что-покрыто)
- [Тесты](#тесты)
- [Структура](#структура)
- [Лицензия](#лицензия)

## Как выглядит

![neovim в тёмном варианте, с деревом файлов и стартовым экраном](docs/screenshot.png)
> У дерева файлов, стартового экрана и полосы вкладок своей интеграции нет — они берут базовые группы, и чем реже интеграция вообще нужна, тем лучше

## Установка

### lazy.nvim

```lua
{
  "rokokol/ddlc.nvim",
  lazy = false,
  priority = 1000,
  opts = {},          -- см. ниже; по умолчанию тёмная и непрозрачная
}
```

`opts` — это `require("ddlc").setup`, так что любой другой менеджер работает так же: плагину нужен только этот вызов и `:colorscheme ddlc` после него

### nixvim

```nix
{
  inputs.ddlc-nvim.url = "github:rokokol/ddlc.nvim";

  # в nixvim-конфигурации
  programs.nixvim = {
    imports = [ inputs.ddlc-nvim.nixvimModules.ddlc ];

    ddlc.nixvim = {
      enable = true;
      settings.transparent = true;   # та же таблица, что принимает setup
    };
  };
}
```

Это ставит плагин, зовёт `setup` до того, как лягут цвета, и называет `ddlc` схемой. Сам плагин подменяется через `package`

### Без менеджера плагинов

```sh
git clone https://github.com/rokokol/ddlc.nvim ~/.local/share/nvim/site/pack/themes/start/ddlc.nvim
```

Дальше `:colorscheme ddlc`. `setup` необязателен — без него тема берёт свои умолчания

## Опции

```lua
require("ddlc").setup({
  variant = "auto",
  transparent = false,
  italic_comments = true,
  integrations = { telescope = true },
  overrides = {},
})
```

| | | |
| --- | --- | --- |
| `variant` | `"auto"`, `"dark"`, `"light"` | `auto` читает `vim.o.background`, поэтому `:set background=light` переключает тему |
| `transparent` | `false` | см. ниже |
| `italic_comments` | `true` | комментарии и цитаты |
| `integrations.telescope` | `true` | выключенная не трогает группы `Telescope*` |
| `overrides` | `{}` | `{ Normal = { fg = "#FF0000" } }` — мержится последней, чтобы подвинуть одну группу без форка темы |

`:colorscheme ddlc-dark` и `:colorscheme ddlc-light` называют вариант прямо, что бы ни стояло в `variant`

## Прозрачность

`transparent` убирает фоны, закрашенные `base00`, и только их. Строка курсора, плавающее окно и меню автодополнения стоят на `base01`, и если убрать и их, у редактора не останется формы — смысл в том, чтобы через текст просвечивал фон терминала, а не в том, чтобы стереть все поверхности

Это один проход по готовой таблице, а не флаг, продетый в каждую группу: непрозрачным окно делает сам цвет фона. Единственный случай, до которого так не дотянуться, — плагин, который на своём setup читает `Normal` и красит из него свою полосу: он уже скопировал цвет, которого больше нет, и его нужно попросить перечитать

## Что покрыто

| | |
| --- | --- |
| базовые | всё, что определяют vim и neovim — обвязка редактора, синтаксические группы, на которые падает файл без парсера, диффы, проверка орфографии |
| treesitter | `@`-захваты в написании neovim 0.10, вместе с markup, так что заметки рендерятся |
| LSP | диагностика пяти уровней, ссылки, inlay hints и семантические токены, слинкованные в захваты treesitter — сервер, не согласный с парсером, всё равно выглядит как файл |
| telescope | у панелей нет своего фона, форму несёт рамка |

Палитра терминала (`:terminal`) тоже выставляется — слот в слот с ANSI-таблицей, которую [ddlc-terminal-themes](https://github.com/rokokol/ddlc-terminal-themes) отдаёт kitty, так что встроенная оболочка согласуется с внешней

## Тесты

```sh
tests/run.sh   # headless neovim на одноразовом каталоге состояния
```

`nix flake check` гоняет их против **собранного плагина**, а не против чекаута, так что заодно проверяется упаковка, плюс: сгенерированная таблица палитры совпадает с ddlc-palette, модуль nixvim подключается (и ничего не течёт, когда выключен), а stylua, luacheck, shellcheck и shfmt чисты

## Структура

```
colors/           ddlc.lua и по файлу на вариант, чтобы назвать его прямо
lua/ddlc/         setup, загрузка и таблицы групп
lua/ddlc/palette.lua   генерируется из base16-схем — единственный такой файл здесь
generate.sh       его и генерирует
nix/              package.nix, module.nix, module-test.nix
```

## Лицензия

MIT. Цвета — Team Salvato
