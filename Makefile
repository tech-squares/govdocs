# Makefile for Tech Squares constitution and bylaws
# Stephen Gildea <gildea@alum> April 1998
# Time-stamp: <2006-04-29 09:26:09 gildea>
# $Id$
# This Makefile tested with GNU make

SRCS = constit.tex policies.tex safer-dances.tex

ALLSRCS = $(SRCS) 2015faq.tex


all: all-pdf all-html

all-dvi: $(ALLSRCS:.tex=.dvi)
all-ps: $(ALLSRCS:.tex=.ps)
all-pdf: $(ALLSRCS:.tex=.pdf)
all-html: $(ALLSRCS:.tex=.html)

 TEXLIBDIR=/mit/tech-squares/lib/tex/macros:../../lib/tex/macros

 LATEX_ENV=TEXINPUTS=.:$(TEXLIBDIR):
 DVIPS_ENV=DVIPSHEADERS=.:$(TEXLIBDIR):

 LATEX = latex
 DVIPS = dvips -Ppdf
 PS2PDF = ps2pdf
 LATEX2HTML = latex2html
 MAKEINDEX = makeindex

.SUFFIXES: .tex .dvi .ps .pdf .html

.tex.dvi:
	$(LATEX_ENV) $(LATEX) $<

# dvips version 5.86e and 5.92b fail to write a %%CreationDate
.dvi.ps:
	$(DVIPS_ENV) $(DVIPS) $(DVIPS_FLAGS) -o - $< | \
	  sed -e "`echo '1a\'; echo '%%CreationDate:'` `date`" > $@

.ps.pdf:
	$(PS2PDF) $(PS2PDF_FLAGS) $< $@

.tex.html:
	$(LATEX2HTML) $< && \
	/mit/tech-squares/arch/@sys/bin/ts-html-convert govdocs/ $*/$@ > $@
	rm -r $*/

$(ALLSRCS:.tex=.dvi): bylaws.cls
$(ALLSRCS:.tex=.html): bylaws.perl
safer-dances.html : article.perl hyperref.perl

2015faq.html : hyperref.perl


mostlyclean:
	-rm *.aux *.out *.log *.dvi *.ilg *.ind *.ps web.tar

clean: mostlyclean
	-rm *.idx *.pdf *.html

distclean: clean
	-rm *~

# Make the tar files for distributing these files.

web.tar: $(SRCS:.tex=.pdf) $(SRCS:.tex=.html)
	tar cf $@ $^
	@echo " ---"
	@echo "move $@ to /mit/tech-squares/www/govdocs, then unpack it with this command:"
	@echo "tar xpfv $@"
	@echo "Alternatively, if you're on Athena already, just run"
	@echo "tar -vx -C /mit/tech-squares/www/govdocs/ -f web.tar"

install: web.tar
	tar xpfv web.tar -C /mit/tech-squares/www/govdocs

install-stage: web.tar
	tar xpfv web.tar -C /mit/tech-squares/www/govdocs-stage
