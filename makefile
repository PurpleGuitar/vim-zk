.PHONY: all gen_metadata gen_graphs gen_html clean

all: gen_metadata gen_graphs gen_html

gen_metadata: _page_links.dot.png

gen_graphs: $(patsubst %.dot,%.dot.png,$(wildcard *.dot))

gen_html: $(patsubst %.md,%.html,$(wildcard *.md))

_page_links.dot: $(wildcard *.md)
	python3 gen_page_links.py > _page_links.dot

%.dot.png : %.dot
	dot -Tpng -o$@ $<

%.html : %.md
	pandoc --from=markdown --to=html --css=style.css --output $@ $<

clean:
ifneq ($(wildcard _page_links.dot),)
	rm -f _page_links.dot
endif
ifneq ($(wildcard *.dot.png),)
	rm $(wildcard *.dot.png)
endif
ifneq ($(wildcard *.html),)
	rm $(wildcard *.html)
endif
