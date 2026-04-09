# Copilot Instructions — beamerthemetechnikum Project

## Project Overview

This is a LaTeX Beamer presentation project using the `beamerthemetechnikum` theme. It is built with `xelatex` via `latexmk` and follows a strict directory layout for assets, content, and build artifacts.

## Tech Stack & Engine

- **Engine:** Always use `xelatex`. Do not suggest `pdflatex` or `lualatex`.
- **Compilation:** Build exclusively with `latexmk` configured via the local `.latexmkrc`. Do not suggest manual compilation commands.
- **Flags:** `--shell-escape` is enabled automatically to support `minted` and TikZ externalization.
- **Post-build:** `texlogsieve` runs automatically after successful builds to produce filtered log reports in `build/`.

## Directory Structure

```
project-root/
├── main.tex                  # Main document entry point
├── .latexmkrc                # latexmk configuration (engine, paths, build rules)
├── assets/
│   ├── preamble.sty          # Package imports only (no styling)
│   ├── acronyms.tex          # All acronym definitions (\ac{label})
│   ├── references.bib        # All bibliography entries (\cite{key})
│   ├── circuits/             # Standalone CircuiTikZ .tex files
│   ├── figures/              # Standalone TikZ .tex files and vector graphics
│   ├── images/               # Raster graphics (PNG, JPG, EPS) and embedded PDFs
│   ├── listings/             # External source code files for \inputminted
│   ├── tables/               # CSV data or externalized table .tex files
│   ├── tex/                  # Content .tex files (sections, slides)
│   │   ├── <section>.tex     # Section entry point
│   │   └── <section>/        # Individual slides for that section
│   │       └── <slide>.tex
│   ├── fonts/                # [submodule] beamerthemetechnikum-fonts
│   └── theme/technikum/      # [submodule] beamerthemetechnikum
└── build/                    # All output (PDF, aux, logs) — ignore for code generation
```

### Strict Rules

- **Acronyms** go in `assets/acronyms.tex`, never inline. Use `\ac{label}`.
- **Bibliography** goes in `assets/references.bib`, never inline. Use `\cite{key}`.
- **Package imports** go in `assets/preamble.sty` as `\RequirePackage` calls only. No styling here.
- **Package styling** (colors, keyword definitions, diagram defaults) belongs in the theme's `config/*.cfg` files using conditional guards.
- **Content files** in `assets/tex/` contain only slide content — no package imports, no style overrides.

### Git Submodules

- `assets/theme/technikum/`: Core Beamer theme (`beamerthemetechnikum`). Do not modify from this repository.
- `assets/fonts/`: Multi-script font definitions (`beamerthemetechnikum-fonts`). Provides `\newfontfamily` commands for Arabic, Armenian, Bengali, CJK, Devanagari, Georgian, Hebrew, Tamil, Thai, and Urdu scripts.

### Path Resolution

The `.latexmkrc` adds `assets/` and `build/` to `TEXINPUTS`:

| Command              | Path prefix needed? | Example                                           |
| -------------------- | ------------------- | ------------------------------------------------- |
| `\includegraphics`   | No                  | `\includegraphics{photo.jpg}`                     |
| `\input`             | No                  | `\input{tex/section/slide.tex}`                   |
| `\includestandalone` | No                  | `\includestandalone[width=…]{figures/diagram}`    |
| `\inputminted`       | Yes (`assets/`)     | `\inputminted{python}{assets/listings/script.py}` |

`\inputminted` resolves from the project root, not from `TEXINPUTS`.

## LaTeX Coding Standards

### Frame Options

- Any frame containing `minted`, `verbatim`, or raw code **MUST** include `[fragile]`.
- Use `[shrink]` when content overflows (e.g., large algorithms). Combine as `[fragile,shrink]`.

### Code Highlighting

- Always use the `minted` package. Never use `listings`.
- External source files go in `assets/listings/` and are included with `\inputminted`.

### TikZ

- **Overlays:** Use `\onslide<n>{}` for progressive reveals. Do not define custom `visible on` styles.
- **Standalone files** MUST use the beamer-aware pattern:

```latex
\documentclass[class=beamer]{standalone}
\usetheme{technikum}
\usepackage{preamble}

\begin{document}
\begin{tikzpicture}
    % drawing commands — theme colors (fhtw-blue, fhtw-green, …) are available
\end{tikzpicture}
\end{document}
```

- Include via `\includestandalone[width=…]{figures/name}`. The `standalone` package in `preamble.sty` handles sub-compilation.

### Algorithms

- Use `algorithm2e` (loaded with `[linesnumbered, noend]` in `preamble.sty`).
- Wrap in `\begin{algorithmdisplay}…\end{algorithmdisplay}`, caption with `\algocaption{title}`.
- Use theme keywords: `\KwAnd`, `\KwOr`, `\KwNot`, `\KwTo`, `\Return`.
- Keyword styling is handled by the theme's `algorithm2e.cfg`. Do not redefine styles in content files.

### Tables

- `booktabs` for simple tables (`\toprule`, `\midrule`, `\bottomrule`).
- `tabularray` for complex tables (spans, colors, advanced formatting).
- `siunitx` for all quantities: `\qty{}{}`, `\unit{}`, `\num{}`. Custom units `\bit` and `\byte` are defined in `preamble.sty`.

### Circuits

- Use `circuitikz`. Standalone circuit files go in `assets/circuits/`.
- Follow the same beamer-aware standalone pattern as TikZ files.

## Theme Architecture — Separation of Concerns

| Layer           | Location                              | Contains                                 |
| --------------- | ------------------------------------- | ---------------------------------------- |
| Package imports | `assets/preamble.sty`                 | `\RequirePackage` calls, minimal setup   |
| Package styling | `assets/theme/technikum/config/*.cfg` | Colors, keyword styles, diagram defaults |
| Content         | `assets/tex/**/*.tex`                 | Slide content only                       |

Theme config files use conditional guards — styles activate only when the user has loaded the corresponding package:

```latex
\AtBeginDocument{%
  \@ifpackageloaded{package-name}{%
    % styling using theme colors
  }{}%
}
```

Do not duplicate styling in `preamble.sty` that already exists in theme `config/` files.
