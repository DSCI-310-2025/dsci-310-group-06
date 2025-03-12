.PHONY: all clean report

all:
	make clean
	make index.html

# output-dir from _quarto.yml is docs, so moving is unnecessary
index.html: index.qmd output/coef.csv output/fig.png
	quarto render index.qmd

report:
	make index.html

clean:
	rm -f output/*
	rm -f data/clean/*
	rm -f index.html
	rm -f *.pdf
	rm -rf docs/* # Remove docs directory, r to make it recursive
