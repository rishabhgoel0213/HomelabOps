RESUME_SRC := Resume.typ
RESUME_PDF := Resume.pdf
RESUME_PREVIEW := /tmp/rishabh-resume-preview.png
TYPST_BIN := $(shell command -v typst 2>/dev/null)
TYPST_CMD := $(if $(TYPST_BIN),typst,docker run --rm -v $(CURDIR):/work -w /work ghcr.io/typst/typst:latest)

.PHONY: resume check-resume preview-resume site-up site-down site-logs cloudflare-dns deploy

resume:
	$(TYPST_CMD) compile $(RESUME_SRC) $(RESUME_PDF)

check-resume: resume
	python3 scripts/check-pdf-pages.py $(RESUME_PDF) 1

preview-resume: check-resume
	pdftoppm -png -singlefile -r 160 $(RESUME_PDF) /tmp/rishabh-resume-preview
	@echo $(RESUME_PREVIEW)

site-up:
	docker compose up -d

site-down:
	docker compose down

site-logs:
	docker compose logs -f site

cloudflare-dns:
	python3 scripts/configure-cloudflare.py

deploy: resume site-up
