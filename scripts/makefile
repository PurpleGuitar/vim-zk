MAKEFILE_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

.PHONY: all gen_metadata _page_links gen_graphs gen_html clean

all: gen_metadata gen_graphs gen_html

gen_metadata: _page_links

_page_links: _page_links.dot.png _page_links.dot.svg

_page_links.dot: _metadata.yaml
	python3 $(MAKEFILE_DIR)/gen_page_links.py > _page_links.dot

_page_links.dot.svg: _page_links.dot
	dot -Tsvg -o _page_links.dot.svg _page_links.dot

_metadata.yaml: $(wildcard *.md)
	python3 $(MAKEFILE_DIR)/gen_metadata.py > _metadata.yaml

gen_graphs: $(patsubst %.dot,%.dot.png,$(wildcard *.dot))

gen_html: $(patsubst %.md,%.html,$(wildcard *.md))

%.dot.png : %.dot
	dot -Tpng -o$@ $<

%.html : %.md html-header
	pandoc \
		--from=markdown \
		--to=html \
		--css=style.css \
		--toc \
		--standalone \
		--include-in-header html-header \
		--output $@ $<

html-header:
	echo "<!-- vim: filetype=html -->\n<!-- Place your HTML header customizations here. -->" > html-header

clean:
ifneq ($(wildcard _metadata.yaml),)
	rm _metadata.yaml
endif
ifneq ($(wildcard _page_links.dot),)
	rm _page_links.dot
endif
ifneq ($(wildcard _page_links.dot.svg),)
	rm _page_links.dot.svg
endif
ifneq ($(wildcard *.dot.png),)
	rm $(wildcard *.dot.png)
endif
ifneq ($(wildcard *.html),)
	rm $(wildcard *.html)
endif
