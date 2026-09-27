# CLAUDE.md

This is the source for the tico editor project website, https://tico-edit.github.io.
The production site is served by GitHub Pages from the `docs/` directory.

## How the site is built

Pages are written in Markdown and turned into static HTML by `XOR`, the
maintainer's own Perl module (installed locally, not vendored in this repo).
`./build.pl` sets up XOR (`org => 'tico-edit'`, `site_name => 'tico'`) and runs the build.

```sh
./build.pl
```

The build needs network access: every run calls the GitHub API to regenerate
`docs/pod/`. If it fails in a sandbox or offline, that's the likely cause.

What the build does:

- Finds every `*.md` file under `docs/` (recursively) and writes a sibling `.html` file:
  `docs/foo.md` becomes `docs/foo.html`.
- If a page's first line is a Markdown heading, that heading becomes the page `<title>`
  and the header text. Otherwise the title falls back to the site name (`tico`).
- Uses the `simple` template by default. A file named `foo.NAME.md` renders with
  template `NAME` into `foo.html`. Templates are looked up in `./templates/NAME.html.tt`
  first, then in XOR's share dir (which provides `simple` and `wrapper`).
- Deletes `docs/pod/` and regenerates it from the POD in the release tarballs of the
  `tico-edit` GitHub org's repos.
- Copies a default `docs/favicon.ico` if one is missing.
- Regenerates `test.psgi`.

## Editing rules

- Edit the `.md` sources, never the generated `.html`. Run `./build.pl` afterward and
  commit both the `.md` and the regenerated `.html`, because GitHub Pages serves the
  committed HTML as-is and does not run the build.
- Don't hand-edit `test.psgi` or anything under `docs/pod/`. The build overwrites them.

## Local testing

`test.psgi` is a PSGI app (using `Plack::App::GitHubPages::Faux`) that serves `docs/`
roughly the way GitHub Pages does:

```sh
plackup test.psgi
```

It isn't a perfect copy of GitHub Pages, but it's close enough for the kinds of pages
on this site.
