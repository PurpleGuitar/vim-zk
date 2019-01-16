.PHONY: all gen_metadata gen_graphs gen_html clean

all: gen_metadata gen_graphs gen_html

gen_metadata: _page_links.dot.png _page_links.dot.svg

_page_links.dot: _page_links.html $(wildcard *.md)
	python3 gen_page_links.py > _page_links.dot

_page_links.dot.svg: _page_links.dot _page_links.html
	dot -Tsvg -o _page_links.dot.svg _page_links.dot

_page_links.html:
	echo "<html><head><title>Page Links</title>\
              <link rel='stylesheet' href='style.css' type='text/css' /></head>\
              <body><a href='#' class='svg'><object width='100%' height='100%' data='_page_links.dot.svg' type='image/svg+xml'><img src='_page_links.dot.png' /></object></a></body></html>\
             " > _page_links.html

gen_graphs: $(patsubst %.dot,%.dot.png,$(wildcard *.dot))

gen_html: $(patsubst %.md,%.html,$(wildcard *.md))

%.dot.png : %.dot
	dot -Tpng -o$@ $<

%.html : %.md
	pandoc --from=markdown --to=html --css=style.css --toc --output $@ $<

clean:
ifneq ($(wildcard _page_links.dot),)
	rm -f _page_links.dot
endif
ifneq ($(wildcard _page_links.dot.svg),)
	rm -f _page_links.dot.svg
endif
ifneq ($(wildcard *.dot.png),)
	rm $(wildcard *.dot.png)
endif
ifneq ($(wildcard *.html),)
	rm $(wildcard *.html)
endif
