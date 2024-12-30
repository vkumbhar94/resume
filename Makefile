all: index.html index.pdf index.docx index.txt

.PHONY: bd
bd:
	mkdir -p assets
index.html: bd index.md style.css ## generates html
	cp style.css assets/
	cp style.tex assets/
	cp icons8-*.svg assets/
	pandoc --standalone -c style.css --from markdown --to html -o assets/index.html index.md

index.pdf: bd index.html ## generates pdf from html using wkhtmltopdf
	wkhtmltopdf --enable-local-file-access assets/index.html assets/index.pdf

index.docx: bd index.md ## generates docx
	pandoc --from markdown --to docx -o assets/index.docx index.md

index.txt: bd index.md ## generates txt
	pandoc -s --from markdown --to plain -o assets/index.txt index.md

clean: ## removes all generated files
	rm -rf *.html *.pdf *.docx *.txt assets/*

docker-%: ## runs any make target in docker container
	docker build -t pandoc-base -q .
	docker run --rm --volume $(PWD):/code pandoc-base $(subst docker-,,$@)

.PHONY: help
help: ## shows help
	@printf "\nusage : make <commands> \n\nthe following commands are available : \n\n"
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

