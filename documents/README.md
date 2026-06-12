# Documents

This directory is the source of truth for important documents managed by the
server.

- `resume/Resume.typ` is the editable Typst resume source.
- `resume/Resume.pdf` is the canonical built resume PDF.
- `github-profile/README.md` is the managed source for the public
  `rishabhgoel0213/rishabhgoel0213` GitHub profile repository.

The public site deployment copies `resume/Resume.pdf` to
`/srv/state/public-site/rishabh-goel-resume.pdf`. Compatibility URLs such as
`/resume.pdf` and `/Resume.pdf` redirect to that public filename.
