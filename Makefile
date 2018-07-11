# Makefile for Tech Squares constitution and bylaws
# Stephen Gildea <gildea@alum> April 1998
# Time-stamp: <2006-04-29 09:26:09 gildea>
# $Id$
# This Makefile tested with GNU make

SRCS = constit.tex policies.tex safer-dances.tex safer-dances-procedures.tex photo.tex

ALLSRCS = $(SRCS) 2015faq.tex


all: all-pdf all-html

all-dvi: $(ALLSRCS:.tex=.dvi)
all-ps: $(ALLSRCS:.tex=.ps)
all-pdf: $(ALLSRCS:.tex=.pdf)
all-html: $(ALLSRCS:.tex=.html)

LOCKER_PATH = /mit/tech-squares
ifneq (,$(wildcard $(LOCKER_PATH)))
 TS_HTML_CONVERT = $(LOCKER_PATH)/arch/@sys/bin/ts-html-convert
 TS_TEX_LIBS = $(LOCKER_PATH)/lib/tex/macros
else
 TS_HTML_CONVERT = local/bin/ts-html-convert
 TS_TEX_LIBS = local/lib/tex/macros
endif

 TEXLIBDIR=$(TS_TEX_LIBS)

 LATEX_ENV=TEXINPUTS=.:$(TEXLIBDIR):
 DVIPS_ENV=DVIPSHEADERS=.:$(TEXLIBDIR):

 LATEX = latex
 DVIPS = dvips -Ppdf
 PS2PDF = ps2pdf
 LATEX2HTML = latex2html
 MAKEINDEX = makeindex

.SUFFIXES: .tex .dvi .ps .pdf .html

ifeq ($(ALLOW_FETCH),1)
local/bin/ts-html-convert:
	mkdir -p local/bin/
	wget https://tech-squares.scripts.mit.edu/ts-html-convert --output-document="$@"
	#sed --in-place -e 's#/usr/athena/bin/perl#/usr/bin/perl#' "$@"
	chmod +x "$@"

local/lib/tex/macros:
	git clone https://github.com/tech-squares/tex-libs local/lib/tex
else
local/bin/ts-html-convert:
	@echo "AFS is not accessible, and you aren't allowing fetching. Fix AFS, or pass ALLOW_FETCH=1."
	@exit 1

local/lib/tex/macros:
	@echo "AFS is not accessible, and you aren't allowing fetching. Fix AFS, or pass ALLOW_FETCH=1."
	@exit 1
endif

%.old-$(HASH).tex:
	git show $(HASH):$*.tex > $*.old-$(HASH).tex

%.diff-$(HASH).tex: %.old-$(HASH).tex %.tex
	latexdiff "$<" "$*.tex" > "$*.diff-$(HASH).tex"

%.dvi : %.tex
	$(LATEX_ENV) $(LATEX) -halt-on-error $<
	$(LATEX_ENV) $(LATEX) -halt-on-error $<

# dvips version 5.86e and 5.92b fail to write a %%CreationDate
%.ps : %.dvi
	$(DVIPS_ENV) $(DVIPS) $(DVIPS_FLAGS) -o - $< | \
	  sed -e "`echo '1a\'; echo '%%CreationDate:'` `date`" > $@

%.pdf : %.ps
	$(PS2PDF) $(PS2PDF_FLAGS) $< $@

%.html : %.tex $(TS_HTML_CONVERT)
	$(LATEX2HTML) $< && \
	$(TS_HTML_CONVERT) govdocs/ $*/$@ > $@
	rm -r $*/

$(ALLSRCS:.tex=.dvi): bylaws.cls | $(TS_TEX_LIBS)
$(ALLSRCS:.tex=.html): bylaws.perl $(TS_HTML_CONVERT)
safer-dances.html safer-dances-procedures.html photo.html : article.perl hyperref.perl
2015faq.html : hyperref.perl


mostlyclean:
	-rm *.aux *.out *.log *.dvi *.ilg *.ind *.ps web.tar

localclean:
ifeq ($(ALLOW_FETCH),1)
	-rm local/bin/ts-html-convert
endif

clean: mostlyclean localclean
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
