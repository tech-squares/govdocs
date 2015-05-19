% bylaws.cls -- LaTeX class for constitutions and bylaws
% Time-stamp: <2006-04-29 09:27:04 gildea>
% $Id$
%
% LaTeX macro package for the Tech Squares Constitution and Bylaws.
% Written Decemeber 1987 by Stephen Gildea <gildea@alum>
% as conmac.sty for LaTeX 2.09.
% April 1998: renamed bylaws.cls, rewritten for LaTeX 2e, added hyperref.
% May 1998: extended to support MITBDT Constitution.
% Feb 2001: use Text Companion encoding for bullet char.
% Sep 2002: corrected \article to not suppress indent of first section

\NeedsTeXFormat{LaTeX2e}[1994/12/01]	%for \textbullet
\ProvidesClass{bylaws}[2002/09/05 Constitutions and Bylaws]
\PassOptionsToClass{12pt}{article}	%force 12pt option

% option [secnames] makes \section take an argument
\newif\ifbl@secnames\bl@secnamesfalse
\DeclareOption{secnames}{\bl@secnamestrue}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions
\LoadClass{article}

\RequirePackage{headerfooter}


%%% Making good PDF files

\newif\ifbl@hyperref \bl@hyperreftrue

\IfFileExists{hyperref.sty}{\ifbl@hyperref
  \AtBeginDocument{\hypersetup{pdftitle=\@title}}
  \RequirePackage[ps2pdf]{hyperref}

  \IfFileExists{times.sty}{
    \RequirePackage{times}
    \RequirePackage{textcomp}}	%for \textbullet
   {}				%times else
  \fi}
 {}				%hyperref else

%%% Page dimensions

\oddsidemargin=.125in
\textwidth=6.25in

\topmargin=0in
\headheight=0in
\headsep=0in
\textheight=9in

\sloppy


%%% Title and page footer

\def\maketitle{
  \vskip 5\baselineskip
  \begin{center}
  {\Large\bf \@title} \\
  \vskip \baselineskip
  \end{center}
}

% Initially the title string is empty.
% The \title command sets it.
\def\@title{}

% This command is part of the headerfooter style macros included above.
\pagefooter{\@title}{-- \thepage\ --}{\@date}


%%% History

% Used to print out when the document was ratified, amended, etc.
\newenvironment{history}%
  {\begin{center}\obeylines}%
  {\par \end{center}}


%%% Instead of \section, \subsection, and \subsubsection,
%%% here we have \article, \subarticle, \section, \subsection, and \duty.
%%% \article and \subarticle take an argument, \subsection and \duty do not.
%%% \section takes an argument if the "secnames" option is specified.


% all the counters are one level off because hyperref assumes
% the highest-level is called "section".
\def\thesection{Article \Roman{section}.}

\def\article{\@startsection {section}{1}{\z@}%
                                     {7ex\@plus 1ex \@minus .6ex}%
                                     {2.3ex plus .3ex}
                                     {\large\bf\hfil}} %the \hfil centers the header

\def\policy{\@startsection {section}{1}{\z@}%
                                     {7ex\@plus 1ex \@minus .6ex}%
                                     {2.3ex plus .3ex}
                                     {\large\bf}}

\def\sectionmark#1{}

\newcommand\named@section{\@startsection{subsection}{2}{\z@}%
                                     {-3.25ex\@plus -1ex \@minus -.2ex}%
                                     {1.5ex \@plus .2ex}%
                                     {\normalfont\large\bfseries}}

\def\unnamed@section{\par\vskip 1ex 
  \stepcounter{subsection} \thesubsection \hskip 1em\relax}

\def\thesubsection{Section \arabic{subsection}.}

\ifbl@secnames
  \let\section\named@section
\else
  \let\section\unnamed@section
\fi

\newcommand\subarticle{\@startsection{subsection}{3}{\parindent}%
                                     {3.25ex\@plus -1ex \@minus -.2ex}%
                                     {1.5ex \@plus .2ex}%
                                     {\normalfont\normalsize\bfseries}}

\def\subsection{\par\vskip 1ex
  \stepcounter{subsubsection} \thesubsubsection \hskip 1em\relax}

\def\thesubsubsection{Section \arabic{subsection}.\Alph{subsubsection}.}


\newdimen\dutywidth

\newcommand\duty{\vskip .4ex
  \dutywidth=\textwidth
  \advance\dutywidth by -2\parindent
  \par \noindent
  \parshape 1 2\parindent \dutywidth
  \textbullet \hskip .1em\relax}

% should be \small w 11pt or \footnotesize w 10pt
\newenvironment{comment}{\small\sf}{\par}


%%% Macros for doing amendments

% a document which is amendments has different formatting,
% so add "amendment" to the style options
\def\amendment{\parskip=.4\baselineskip \parindent=0pt}

% I used \it for \add in 1988, but in 1994, noting that
% some of the changed text was already in italics, changed to \bf

% introduce the old and new text:
\newcommand\nextchange{\par\vskip.5\baselineskip}
\newcommand\current{Current:\ }
\newcommand\revised{Revised:\ }

% These commands set text in different fonts and sizes to
% draw attention to changes.

\newcommand\add[1]{{\bf #1\/}}

\newcommand\del[1]{{\small\sf [#1]\/}}

% used to denote any kind of change.
% If you use any \it inside a change, you will get
% the \sfit font defined below.
\newcommand\change[1]{{\def\it{\sfit}\sf #1}}

% I only have this font in 10pt, 
% so you must use 10pt for the document if you use any of this.
%% Comment this out so other people who don't have this font
%% don't get errors.
%%\font\sfit=amssi10


%%% Macros for listing issues

\newenvironment{issues}{\noindent\hrulefill
  \def\thesection{\hskip-1em\relax} %no number, remove the \quad
  \article{Issues}
  \def\thesubsection{Issue \arabic{subsection}.}
  }
  {}

% Issue number #1, text #2.
\def\issue#1#2{
  \setcounter{subsection}{#1}\addtocounter{subsection}{-1}
  \section{#2}}
