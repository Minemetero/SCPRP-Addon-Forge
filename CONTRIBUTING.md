# Contributing

## Folder Layout (required)
```
addons/<your-username>/<addon-name>/
  README.md
  addon.lua
```

## Header Block (required)
Every `addon.lua` must start with:
```lua
----------------------------------------------------------------------
-- <Name>
-- Author: <your-handle>
-- Version: <x.y.z>
-- Features:
--  - <bullet>
--  - <bullet>
--  - <bullet>
--  - <bullet>
----------------------------------------------------------------------
```

## Comments (recommended)
Use section dividers to make scripts readable:
```lua
------------------------------------------------------
-- Events
------------------------------------------------------
```

## Commits (recommended)
Use short, descriptive commits with a tag prefix:
- feat: …
- fix: …
- docs: …
- chore: …

### PR Checklist
- [ ] Files live under `addons/<username>/<addon-name>/`
- [ ] `README.md` + `addon.lua` both present
- [ ] Proper header block included
- [ ] No secrets (placeholders like `XXXX/REPLACE_ME`)
- [ ] Tested once on a server (if applicable)
