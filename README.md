# OpenDCL Forums Archive

Read-only static archive of the historic OpenDCL SMF forum (2007–2026).

**Live site:** https://opendcl.github.io/forum-archive/

| Content | Count |
|---------|------:|
| Boards | 20 (public; restricted admin boards omitted) |
| Topics | 2,523 |
| Posts (searchable) | 12,743 |
| Attachments | 1,942 |

- **New discussion:** [opendcl/community Discussions](https://github.com/opendcl/community/discussions) *(when enabled)*
- **Main project:** [opendcl/OpenDCL](https://github.com/opendcl/OpenDCL)
- **Project website:** [opendcl.github.io](https://opendcl.github.io/)

Authors are original SMF display names, not verified GitHub accounts.

## Local preview

```powershell
python -m http.server 8765 --bind 127.0.0.1
```

## Regenerate

From the OpenDCL workspace (not this published tree alone):

```powershell
cd forum-archive-tools
python generate.py config.full.json
```

Then commit and push updates to this repository.
