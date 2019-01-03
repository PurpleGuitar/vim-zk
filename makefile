# Generate all HTML files from MD
.PHONY: all
all: _page_links.dot.png \
     $(patsubst %.md,%.html,$(wildcard *.md)) \
     $(patsubst %.dot,%.dot.png,$(wildcard *.dot))

# Generate page links diagram
_page_links.dot: $(wildcard *.md)
	python3 gen_page_links.py > _page_links.dot

# Convert DOT to PNG
%.dot.png : %.dot
	dot -Tpng -o$@ $<

# Convert HTML to MD
%.html : %.md
	pandoc --from=markdown --to=html --css=style.css --output $@ $<

# Clean up files
.PHONY: clean
clean:
	rm -f _page_links.*
ifneq ($(wildcard *.html),)
	rm $(wildcard *.html)
endif
