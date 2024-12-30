all: index.html index.pdf index.docx index.txt

index.html: index.md style.css ## generates html
	pandoc --standalone -c style.css --from markdown --to html -o index.html index.md

index.pdf: index.html ## generates pdf from html using wkhtmltopdf
	wkhtmltopdf --enable-local-file-access index.html index.pdf

index.docx: index.md ## generates docx
	pandoc --from markdown --to docx -o index.docx index.md

index.txt: index.md ## generates txt
	pandoc -s --from markdown --to plain -o index.txt index.md

clean: ## removes all generated files
	rm -f *.html *.pdf *.docx *.txt

docker-%: ## runs any make target in docker container
	docker build -t pandoc-base -q .
	docker run --rm --volume $(PWD):/code pandoc-base $(subst docker-,,$@)

.PHONY: help
help: ## shows help
	@printf "\nusage : make <commands> \n\nthe following commands are available : \n\n"
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

