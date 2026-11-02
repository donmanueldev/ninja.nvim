# NinjaNvim

Configuración de Neovim 0.12+ escrita en Lua para macOS. Sustituye a VS Code en JavaScript, TypeScript, React, React Native, Laravel, PHP, Blade, Java, Go, Rust, Swift, Kotlin, CSS, Tailwind, JSON y TOML.

## Instalación

```bash
brew install neovim ripgrep fd lazygit tree-sitter-cli openjdk@25
git clone https://github.com/donmanueldev/ninja.nvim ~/.config/nvim
nvim
```

Al abrir Neovim por primera vez se instalan solos los plugins, los parsers y las herramientas de Mason. Tarda unos minutos.

También necesitas:

- Una Nerd Font configurada en tu terminal, para ver los iconos.
- `claude` en el `PATH`, para la integración con Claude Code.
- Xcode, para Swift (LSP, formato y debug) y para depurar Rust.
- `rustfmt` y `clippy`, para formatear y analizar Rust: `rustup component add rustfmt clippy`.
- JDK 25, solo para el servidor de Java. Tus proyectos pueden compilar con otra versión.
- Xdebug, solo para depurar PHP: `pecl install xdebug`.

## Atajos

El leader es `Espacio`. Pulsa `Espacio` y espera para ver el menú con todas las opciones, o `Espacio ?` para ver todos los atajos.

### Lo esencial

| Atajo | Acción |
| --- | --- |
| `Ctrl-p` | Buscar archivo |
| `Espacio fg` | Buscar texto en el proyecto |
| `Ctrl-b` / `Espacio e` | Árbol de archivos |
| `Ctrl-s` / `Espacio w` | Guardar |
| `Espacio q` | Cerrar ventana |
| `Ctrl-/` | Comentar |
| `Ctrl-n` | Multicursor en la siguiente coincidencia |
| `Ctrl-\` / `Espacio t` | Terminal |
| `jk` | Salir de modo inserción |

### Buffers y ventanas

| Atajo | Acción |
| --- | --- |
| `Tab` / `Shift-Tab` | Buffer siguiente / anterior |
| `Espacio bd` / `Espacio bo` | Cerrar buffer / cerrar los demás |
| `Espacio sv` / `Espacio sh` | Dividir en vertical / horizontal |
| `Ctrl-h` `j` `k` `l` | Moverse entre ventanas |
| `Shift-flechas` | Redimensionar ventana |
| `Espacio sm` | Maximizar ventana |
| `Espacio sx` | Cerrar ventana |

### Código

| Atajo | Acción |
| --- | --- |
| `gd` / `gr` / `gi` / `gy` | Definición / referencias / implementación / tipo |
| `K` | Documentación |
| `Espacio ca` | Acciones de código |
| `Espacio cr` / `F2` | Renombrar |
| `Espacio cf` | Formatear |
| `Espacio cx` / `Espacio cX` | Problemas del archivo / del proyecto |
| `]d` / `[d` | Problema siguiente / anterior |

Al guardar se aplican los arreglos de ESLint y el formateador del lenguaje. `Espacio uf` lo apaga o lo enciende.

### Claude

| Atajo | Acción |
| --- | --- |
| `Espacio ac` | Abrir o cerrar Claude Code |
| `Espacio af` | Enfocar Claude |
| `Espacio as` | Enviar la selección (modo visual) |
| `Espacio ab` | Añadir el archivo actual |
| `Espacio aa` / `Espacio ad` | Aceptar / rechazar el cambio propuesto |
| `Espacio ar` / `Espacio aC` | Retomar sesión / continuar la última |
| `Ctrl-q` | Salir del terminal a modo normal |

### Git

| Atajo | Acción |
| --- | --- |
| `Espacio gg` | Lazygit |
| `Espacio gd` | Ver mis cambios en un diff |
| `Espacio gq` | Cerrar el diff |
| `Espacio gs` | Archivos cambiados |
| `Espacio gh` | Historial del archivo |
| `Espacio gw` | Cambiar de worktree |
| `]h` / `[h` | Cambio siguiente / anterior |
| `Espacio gp` / `ga` / `gr` | Ver / stage / descartar el cambio (tras `Espacio`) |
| `Espacio gb` | Blame de la línea |

### Debug

| Atajo | Acción |
| --- | --- |
| `Espacio db` / `F9` | Punto de interrupción |
| `Espacio dc` / `F5` | Iniciar o continuar |
| `Espacio do` / `F10` | Saltar |
| `Espacio di` / `F11` | Entrar |
| `Espacio dO` | Salir de la función |
| `Espacio de` | Evaluar expresión |
| `Espacio dt` | Terminar |

Si el proyecto tiene `.vscode/launch.json`, también se usa. En React Native, depura con React Native DevTools (tecla `j` en Metro).

### Tema

El tema es Catppuccin y sigue el modo claro u oscuro de macOS. `Espacio ut` lo cambia a mano y `Espacio uT` vuelve a seguir a macOS.

## Estructura

```text
init.lua
lua/config/    opciones, atajos, autocmds, tema y worktrees
lua/plugins/   ui, snacks, git, editor, completion, lsp, format, java, dap, ai
```

Para añadir un servidor de lenguaje, agrégalo a `servers` y a `ensure_installed` en `lua/plugins/lsp.lua`.
