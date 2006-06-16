# Makefile for Tech Squares constitution and bylaws
# Stephen Gildea <gildea@alum> April 1998
# Time-stamp: <2006-04-29 09:26:09 gildea>
# $Id$
# This Makefile tested with GNU make

SRCS = constit.tex bylaws.tex

ALLSRCS = $(SRCS)


all: all-pdf all-html

all-dvi: $(ALLSRCS:.tex=.dvi)
all-ps: $(ALLSRCS:.tex=.PS)
all-pdf: $(ALLSRCS:.tex=.pdf)
all-html: $(ALLSRCS:.tex=.html)

 TEXLIBDIR=/mit/tech-squares/lib/tex/macros:../../lib/tex/macros

 LATEX_ENV=TEXINPUTS=.:$(TEXLIBDIR):
 DVIPS_ENV=DVIPSHEADERS=.:$(TEXLIBDIR):

 LATEX = latex
 DVIPS = dvips -Ppdf
 PS2PDF = $(ATHRUN_GNU) ps2pdf
 LATEX2HTML = $(ATHRUN_INFOAGENTS) latex2html
 MAKEINDEX = makeindex

 ATHRUN := $(shell test -x /usr/athena/bin/athrun && echo "athrun")
 ATHRUN_GNU := $(if $(ATHRUN), $(ATHRUN) gnu)
 ATHRUN_INFOAGENTS := $(if $(ATHRUN), $(ATHRUN) infoagents)

.SUFFIXES: .tex .dvi .PS .pdf .html

.tex.dvi:
	$(LATEX_ENV) $(LATEX) $<

# dvips version 5.86e and 5.92b fail to write a %%CreationDate
.dvi.PS:
	$(DVIPS_ENV) $(DVIPS) $(DVIPS_FLAGS) -o - $< | \
	  sed -e "`echo '1a\'; echo '%%CreationDate:'` `date`" > $@

.PS.pdf:
	$(PS2PDF) $(PS2PDF_FLAGS) $< $@

.tex.html:
	$(LATEX2HTML) $< && \
	ts-latex2html2web bylaws/ $*/$@ > $@
	rm -r $*/

$(ALLSRCS:.tex=.dvi): bylaws.cls
$(ALLSRCS:.tex=.html): bylaws.perl


mostlyclean:
	-rm *.aux *.out *.log *.dvi *.ilg *.ind *.PS

clean: mostlyclean
	-rm *.idx *.pdf *.html

distclean: clean
	-rm *~

# Make the tar files for distributing these files.

web.tar: $(ALLSRCS:.tex=.pdf) $(ALLSRCS:.tex=.html)
	tar cf $@ $^
	@echo " ---"
	@echo "move $@ to /mit/tech-squares/www/bylaws, then unpack it with this command:"
	@echo "tar xpfv $@"
