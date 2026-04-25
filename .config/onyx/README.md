# ONYX User Config

## Hooks

Files in `~/.config/onyx/hooks/` are run automatically at specific events.
Remove the `.sample` extension to activate a hook.

| Hook          | When it runs                          | Arguments       |
|---------------|---------------------------------------|-----------------|
| `battery-low` | Battery reaches critical level        | `$1` = %        |
| `theme-set`   | After a theme is applied              | `$1` = name     |
| `font-set`    | After the font is changed             | `$1` = font     |
| `post-update` | After a successful system update      | —               |

## Migrations

`~/.local/state/onyx/migrations/` tracks which migrations have been run.
Do not delete this directory.
