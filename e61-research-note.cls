%% ============================================================================
%%  e61-research-note.cls
%%
%%  LaTeX class for e61 Institute research notes. Built on top of the
%%  standard "book" class. Must be compiled with XeLaTeX (or LuaLaTeX)
%%  because it loads fonts directly from ./fonts/ via fontspec.
%%
%%  Contents of this file:
%%    1. Class setup & page geometry
%%    2. Fonts
%%    3. Language & general-purpose packages
%%    4. Bibliography
%%    5. Captions
%%    6. Colours
%%    7. Paragraph & equation spacing
%%    8. Boxed content (tcolorbox)
%%    9. Graphics
%%   10. Lists (itemize / enumerate, incl. custom "C" variants)
%%   11. TikZ & table-width helpers
%%   12. Heading styles (chapter / section / subsection / subsubsection / paragraph)
%%   13. Title page (\maketitle)
%%   14. Page styles (fancyhdr)
%%   15. Cross-reference numbering & hyperref
%%   16. Footnotes
%%   17. Figure/table/footnote counters
%%   18. Appendix (lettered chapters, restarted counters, custom heading)
%% ============================================================================

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{e61-research-note}
          [2024/11/22 v1 e61 Research Note]

%% ----------------------------------------------------------------------
%%  1. CLASS SETUP & PAGE GEOMETRY
%% ----------------------------------------------------------------------

% Pass any options given to this class straight through to "book"
% (e.g. \documentclass[11pt]{e61-research-note}).
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptions\relax

\LoadClass[10pt,twoside]{book}

% Base page size/margins. Individual page styles further down
% (see "PAGE STYLES") call \newgeometry to override this per page,
% e.g. the title page uses a shorter paperheight.
\RequirePackage[
    paperwidth  = 215.9mm,
    paperheight = 279.4mm,
    top         = 9mm,
    bottom      = 18mm,
    left        = 15mm,
    right       = 15mm,
    footskip    = 10mm,
    marginparwidth = 0in
]{geometry}
\setlength{\columnsep}{19mm}

%% ----------------------------------------------------------------------
%%  2. FONTS
%% ----------------------------------------------------------------------
% Font files live in ./fonts/ relative to the document being compiled.
% fontspec selects fonts directly by file/Unicode glyph under XeLaTeX,
% so fontenc's 8-bit encoding setup is unnecessary here.
\RequirePackage[no-math]{fontspec}

\setmainfont{PTSans-Regular.ttf}[
    Path           = ./fonts/,
    BoldFont       = PTSans-Bold.ttf,
    ItalicFont     = PTSans-Italic.ttf,
    BoldItalicFont = PTSans-BoldItalic.ttf
]
\RequirePackage[italic]{mathastext} % typeset maths in the body font instead of Computer Modern

% Named font families for specific design elements, used by name
% (e.g. {\Bebas ...}) rather than as the running body font.
\newfontfamily{\Bebas}{BebasNeue Bold.ttf}[Path=./fonts/]              % title page heading
\newfontfamily{\Author}{PTSans-Bold.ttf}[Path=./fonts/,LetterSpace=15] % available for author-name styling
% Figure/table caption font: the same PT Sans files as \setmainfont
% above, kept as a separate family so captions can be restyled
% independently of the body text.
\newfontfamily{\Caption}{PTSans-Regular.ttf}[Path=./fonts/,
    BoldFont       = PTSans-Bold.ttf,
    ItalicFont     = PTSans-Italic.ttf,
    BoldItalicFont = PTSans-BoldItalic.ttf]

%% ----------------------------------------------------------------------
%%  3. LANGUAGE & GENERAL-PURPOSE PACKAGES
%% ----------------------------------------------------------------------

\RequirePackage[english]{babel}
\RequirePackage[all]{nowidow} % discourage orphan/widow lines at page breaks
\RequirePackage{microtype}

% Utility packages made available to authors writing notes, beyond
% what's exercised by this class file itself.
\RequirePackage{rotating}  % \begin{sidewaystable}/{sidewaysfigure}
\RequirePackage{float}     % extra float placement specifiers, e.g. [H]
\RequirePackage{ifthen}    % \ifthenelse for conditional logic in custom commands
\RequirePackage{booktabs}  % \toprule/\midrule/\bottomrule for tables
\RequirePackage[table]{xcolor}
\RequirePackage{wrapfig}   % \begin{wrapfigure}
\RequirePackage{placeins}  % \FloatBarrier
\RequirePackage{amsmath}
\RequirePackage{setspace}  % \setstretch, \singlespacing, etc.

\RequirePackage{siunitx}
\sisetup{
    group-digits             = integer,
    table-align-text-pre     = false,
    table-align-text-post    = false,
    input-symbols            = ( ) [ ] - + *,
}
% \sym{a} typesets a superscript symbol (e.g. significance stars) that
% behaves correctly both inside and outside siunitx table columns.
\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}

%% ----------------------------------------------------------------------
%%  4. BIBLIOGRAPHY
%% ----------------------------------------------------------------------

\RequirePackage[backend=biber,natbib=true,style=apa]{biblatex}
\setlength\bibitemsep{0.33\baselineskip}
\RequirePackage{csquotes}

%% ----------------------------------------------------------------------
%%  5. CAPTIONS
%% ----------------------------------------------------------------------

\RequirePackage{subcaption}
\DeclareCaptionFont{ninept}{\fontsize{10pt}{11}\selectfont \Caption}
\DeclareCaptionLabelFormat{r-parens}{#2} % subfigure labels as "A)" rather than "(a)"

\captionsetup[figure]{
    labelfont     = {bf,ninept},
    labelsep      = colon,
    belowskip     = 0pt,
    aboveskip     = 0pt,
    justification = raggedright, % left-aligned, to match theme61's left-aligned graph titles
    singlelinecheck = false,
    font          = {bf,ninept}
}
\captionsetup[table]{
    skip          = 8pt,
    labelfont     = {bf,ninept},
    labelsep      = colon,
    justification = centering,
    singlelinecheck = false,
    font          = {bf,ninept}
}
\captionsetup[subfigure]{
    labelformat = r-parens,
    labelsep    = colon,
    labelfont   = bf,
    font        = {bf,footnotesize},
    justification = raggedright, % match the left-aligned figure captions above
    belowskip   = 0pt,
    aboveskip   = 6pt
}
\renewcommand{\thesubfigure}{\Alph{subfigure}} % A, B, C, ... instead of a, b, c, ...

% \contentsname ("Contents") is defined per babel language variant, so
% it's patched via \captionsenglish to match the [english] babel option above.
\addto\captionsenglish{
  \renewcommand{\contentsname}{Contents}
}

%% ----------------------------------------------------------------------
%%  6. COLOURS
%% ----------------------------------------------------------------------

\definecolor{green0}{RGB}{37,74,83}   % title-page/appendix-banner background
\definecolor{green1}{RGB}{0,128,128}  % bullet colour (Citemize), accent
\definecolor{green3}{RGB}{0,48,57}    % section headings, box frames
\definecolor{gray1}{RGB}{227,230,230} % summarybox background
\definecolor{boxback}{RGB}{236,249,250} % Boxx background

%% ----------------------------------------------------------------------
%%  7. PARAGRAPH & EQUATION SPACING
%% ----------------------------------------------------------------------

\parindent=0pt
\parskip=6pt plus 2pt minus 2pt

\AtBeginDocument{%
  % Tighten the default (large) spacing above/below display equations.
  \addtolength\abovedisplayskip{-1\baselineskip}
  \addtolength\belowdisplayskip{-1\baselineskip}
}

%% ----------------------------------------------------------------------
%%  8. BOXED CONTENT
%% ----------------------------------------------------------------------
% All boxed environments below (summarybox, Boxx) are built on
% tcolorbox, so they share one consistent styling engine.

\RequirePackage[many]{tcolorbox}

% Base font size for boxed content (summarybox, Boxx) -- 1pt smaller than
% the document's own base size by default, matching e61 house style. Change
% the default everywhere by redefining \BoxFontSize/\BoxBaselineSkip, or
% override a single box via the boxfontsize key, e.g.
% \begin{Boxx}[boxfontsize=8pt]{Title}.
\newcommand{\BoxFontSize}{9pt}
\newcommand{\BoxBaselineSkip}{12pt}
\tcbset{boxfontsize/.store in=\tcb@boxfontsize}

% \begin{summarybox} ... \end{summarybox}
% Shaded box with no title, used for "key findings" style summaries.
\newtcolorbox{summarybox}[1][]{%
    enhanced, breakable,
    detach title,
    boxfontsize = \BoxFontSize,
    % \parskip is set explicitly (matching the document's own \parskip,
    % see PARAGRAPH & EQUATION SPACING above) rather than left to inherit
    % from context -- multi-paragraph box content was otherwise spacing
    % paragraphs differently than the surrounding body text.
    before upper = {\fontsize{\tcb@boxfontsize}{14}\selectfont\baselineskip=16pt
                    \parskip=6pt plus 2pt minus 2pt},
    colupper = black, colback = gray1,
    boxrule = 0pt, frame hidden,
    left = 0.5mm, right = 0.5mm,
    top = 0.5mm, bottom = 0.5mm,
    boxsep = 2mm, arc = 0mm,
    #1
}

% \begin{Boxx}[label=...]{Title text} ... \end{Boxx}
% Titled, outlined box, auto-numbered as "Box 1", "Box 2", etc.
% Pass an empty title (i.e. {}) to get just "Box <n>" with no colon/text -
% the \ifx\hfuzz#2\hfuzz test below detects that case (\hfuzz is simply
% used as an arbitrary token to compare #2 against for emptiness).
\newtcolorbox[auto counter,
              number freestyle={\noexpand\arabic{\tcbcounter}}]{Boxx}[2][]{%
    enhanced,
    breakable,
    detach title,
    boxfontsize = \BoxFontSize,
    % See summarybox above re: explicit \parskip.
    before upper = {\fontsize{\tcb@boxfontsize}{\BoxBaselineSkip}\selectfont
                    \parskip=6pt plus 2pt minus 2pt},
    colframe = green3,
    attach boxed title to top center = {yshift=-\tcboxedtitleheight,yshifttext=-5mm},
    colupper = black,
    colback  = boxback,
    boxed title style = {empty},
    coltitle = black,
    fonttitle = \bfseries,
    center title,
    left = 0mm, right = 0mm,
    top = 0mm, bottom = 0mm,
    boxsep = 2mm,
    arc = 0mm,
    boxrule = 1.5pt,
    title = Box~\thetcbcounter\ifx\hfuzz#2\hfuzz\else:~~#2\fi,
    #1
}

%% ----------------------------------------------------------------------
%%  9. GRAPHICS
%% ----------------------------------------------------------------------

\RequirePackage{graphicx}
\graphicspath{{./figures/}}
\RequirePackage{soul} % \hl, \st, etc. - has built-in UTF-8 support
\RequirePackage{xurl}     % allow URLs to break across lines
\urlstyle{same}

% \circled{1} draws a small filled circle containing "1" (or any short text).
\newcommand*\circled[1]{\tikz[baseline=(char.base)]{%
    \node[shape=circle,fill=green0,inner sep=2.5pt] (char) {\color{white}#1};}}

%% ----------------------------------------------------------------------
%%  10. LISTS
%% ----------------------------------------------------------------------

\RequirePackage{enumitem}

\setlist[enumerate]{
    nosep, label=\arabic*., itemsep=4pt, labelindent=4pt, leftmargin=*,
    labelsep=3pt, before={\vspace{0\baselineskip}}, align=left,
    after={\vspace{0.5\baselineskip}}
}
\setlist[itemize,1]{
    nosep, itemsep=2pt, labelindent=4pt, leftmargin=*,
    before={\vspace{0.25\baselineskip}}, after={\vspace{0.1\baselineskip}}
}

% "Cenumerate"/"Citemize": drop-in replacements for enumerate/itemize
% with e61-branded markers (a circled number, and a large bullet).
\newlist{Cenumerate}{enumerate}{1}
\setlist[Cenumerate]{
    nosep, label=\protect\circled{\arabic*.}, itemsep=4pt, labelindent=!,
    leftmargin=*, labelsep=3pt,
    before={\vspace{0\baselineskip}}, align=left,
    after={\vspace{0.5\baselineskip}}
}

\newlist{Citemize}{itemize}{1}
\setlist[Citemize]{
    nosep, itemsep=2pt, labelindent=!, leftmargin=*,
    before={\vspace{0.25\baselineskip}}, after={\vspace{0.1\baselineskip}},
    label=\raisebox{-0.4\height}{\scalebox{2.2}{\color{green1}\textbullet}}
}

%% ----------------------------------------------------------------------
%%  11. TIKZ & TABLE-WIDTH HELPERS
%% ----------------------------------------------------------------------

\RequirePackage{tikzpagenodes} % gives the "current page text area" node used by \maketitle
\RequirePackage{tikz}
\usetikzlibrary{tikzmark,positioning,fit,calc}
\usetikzlibrary{external}

\RequirePackage{calc}
\RequirePackage{array}
% Convenience lengths for sizing a table column to fill the full text
% width/column width once tabcolsep and rule widths are accounted for,
% e.g. \begin{tabular}{p{\mylengtht}} ... \end{tabular}.
\def\mylengtht{\textwidth-2\tabcolsep-1.25\arrayrulewidth}
\def\mylengthc{\columnwidth-2\tabcolsep-1.25\arrayrulewidth}

% Table content is 1pt smaller than body text by default (e61 house
% style), applied at the environment level so it's automatic for every
% table without authors needing to add a \small themselves. Guarded with
% \AtBeginDocument since \AtBeginEnvironment requires the environment to
% already be defined -- \tabular always is (via array, above), but
% \longtable only exists if the document itself loads that package.
\RequirePackage{etoolbox}
\AtBeginDocument{%
    \AtBeginEnvironment{tabular}{\fontsize{9pt}{11}\selectfont}%
    \@ifundefined{longtable}{}{\AtBeginEnvironment{longtable}{\fontsize{9pt}{11}\selectfont}}%
}

\RequirePackage[explicit]{titlesec}
\setcounter{secnumdepth}{3}
\setcounter{tocdepth}{2}

\RequirePackage{multicol}

%% ----------------------------------------------------------------------
%%  12. HEADING STYLES
%% ----------------------------------------------------------------------

% --- Chapter -------------------------------------------------------------
% Chapters are not numbered in the main body (\thechapter is blank); the
% class only uses \chapter internally, restyled with letters, in the
% appendix (see "APPENDIX" below). The chapter heading also switches on
% the title-page style, since the first \chapter call starts the note.
\titleformat{\chapter}[display]
    {\thispagestyle{e61-rn-first-page}\raggedright\color{green1}}
    {}
    {0pt}
    {\fontsize{25}{32}\selectfont#1~\thechapter}
    []
\renewcommand\thechapter{}
\titlespacing*{\chapter}{0pt}{-52pt plus 6pt}{10pt plus 6pt minus 6pt}

% --- Section ---------------------------------------------------------
\titleformat{\section}
    {\color{green3}\fontsize{18pt}{22pt}\selectfont\normalfont}
    {\thesection.}
    {0.5em}
    {#1}
    []
\titleformat{name=\section,numberless}
    {\color{green3}\fontsize{18pt}{22pt}\selectfont\normalfont}
    {}
    {0em}
    {#1}
    []
\renewcommand{\thesection}{\arabic{section}}
\titlespacing*{\section}{0mm}{12pt plus 2pt minus 3pt}{1pt plus 1pt minus 1pt}[0pc]

% --- Subsection --------------------------------------------------------
\titleformat{\subsection}
    {\color{black}\fontsize{10pt}{10pt}\selectfont\bfseries}
    {\thesubsection}
    {0.5em}
    {#1}
    []
\titleformat{name=\subsection,numberless}
    {\color{black}\fontsize{12pt}{10pt}\selectfont\bfseries}
    {}
    {0em}
    {#1}
    []
\renewcommand{\thesubsection}{\thesection.\arabic{subsection}}
\titlespacing*{\subsection}{0mm}{12pt plus 2pt minus 3pt}{0pt plus 0pt minus 0pt}[0pc]

% --- Subsubsection -----------------------------------------------------
\titleformat{\subsubsection}
    {\color{black}\fontsize{10pt}{10pt}\selectfont\itshape}
    {\thesubsubsection}
    {0.5em}
    {#1}
    []
\renewcommand{\thesubsubsection}{\thesubsection.\arabic{subsubsection}}
\titlespacing*{\subsubsection}{0mm}{12pt plus 2pt minus 3pt}{0pt plus 0pt minus 0pt}[0pc]
\titleformat{name=\subsubsection,numberless}
    {\color{black}\fontsize{10pt}{10pt}\selectfont\itshape}
    {}
    {0em}
    {#1}
    []

% --- Paragraph -----------------------------------------------------------
\titleformat{\paragraph}
    {\color{black!70}\fontsize{10pt}{11pt}\selectfont\bfseries}
    {\theparagraph}
    {0em}
    {#1}
    []
\titlespacing*{\paragraph}{0mm}{12pt plus 2pt minus 3pt}{1pt plus 1pt minus 1pt}[0pc]

%% ----------------------------------------------------------------------
%%  13. TITLE PAGE
%% ----------------------------------------------------------------------

\newcommand{\SubTitle}[1]{\def\@SubTitle{#1}}
% \NoteNumber{...} sets this note's reference number (e.g. \NoteNumber{2025-03}),
% shown on the title page next to the subtitle. Left unset, nothing is shown.
\newcommand{\NoteNumber}[1]{\def\@NoteNumber{#1}}
\def\@NoteNumber{}
% \imagesource{...} typesets a small caption-style credit line, e.g.
% under a figure sourced from an external site.
\newcommand{\imagesource}[1]{{\parskip=0pt\baselineskip=13pt\fontsize{7pt}{9}\selectfont\par #1}}

% Draws the green title-page banner (logo, subtitle, title, author)
% using absolutely-positioned TikZ nodes anchored to the page corners,
% then switches to the "e61-research-note" page style for the rest of
% the note.
\renewcommand{\maketitle}{%
    \thispagestyle{e61-research-note}
    % \title/\author are set after \begin{document} in this class's usual
    % pattern, too late for hyperref's own automatic pdftitle/pdfauthor
    % capture (which runs at \begin{document}), so set them here instead -
    % this is what hyperxmp (see "CROSS-REFERENCE NUMBERING & HYPERREF") embeds as PDF metadata.
    \hypersetup{pdftitle={\@title}, pdfauthor={\@author}}
    \begin{tikzpicture}[remember picture,overlay]
        % Green banner background, anchored to the top of the page.
        \node[anchor=north west,rectangle,
              minimum width=\textwidth,minimum height=40mm,
              fill=green0]
             (GB) at (current page text area.north west) {};

        % e61 logo, top-right of the banner.
        \node[anchor=north east,inner sep=0]
             (LOG) at ([xshift=-5mm,yshift=-3.5mm]GB.north east)
             {\includegraphics[scale=1.0]{e61_logo1}};

        % Subtitle, top-left of the banner.
        \node[text width=155mm,inner sep=0pt,align=left,
              anchor=west,font={\bfseries\color{white}\fontsize{9pt}{9}\selectfont}]
             (STIT) at ([xshift=5mm,yshift=-4mm]GB.north west)
             {\@SubTitle\ifx\@NoteNumber\@empty\else\ |\ No.~\@NoteNumber\fi};

        % Author, bottom-left of the banner.
        \node[text width=155mm,inner sep=0pt,align=left,
              anchor=west,font={\bfseries\color{white}\fontsize{11pt}{11}\selectfont}]
             (AUT) at ([xshift=5mm,yshift=5mm]GB.south west)
             {\@author};

        % Title, vertically centred between the subtitle and author.
        \node[inner sep=0pt,align=flush left,
              text width=155mm,
              anchor=west,font={\color{white}\fontsize{20pt}{24}\selectfont\Bebas}]
             (TIT) at ($(STIT.south west)!0.5!(AUT.north west)$)
             {\MakeUppercase{\@title}};
    \end{tikzpicture}
    \vspace{35mm}
}

%% ----------------------------------------------------------------------
%%  14. PAGE STYLES
%% ----------------------------------------------------------------------

\RequirePackage{fancyhdr}
\pagestyle{fancy}

% Used for the title page: same page size but shorter, since the title
% banner occupies the top of the page.
\fancypagestyle{e61-rn-first-page}{%
    \renewcommand{\headrulewidth}{0pt}
    \fancyhf{}%
    \fancyfoot[C]{\thepage}%
    \newgeometry{
        paperwidth  = 215.9mm,
        paperheight = 150mm,
        top         = 9mm,
        bottom      = 18mm,
        left        = 15mm,
        right       = 15mm,
        footskip    = 10mm,
        marginparwidth = 0in
    }
}

% Used for all regular pages of the note (footer page number only).
\fancypagestyle{e61-research-note}{%
    \renewcommand{\headrulewidth}{0pt}
    \fancyhf{}%
    \fancyfoot[C]{\thepage}%
    \newgeometry{
        paperwidth  = 215.9mm,
        paperheight = 279.4mm,
        top         = 9mm,
        bottom      = 18mm,
        left        = 15mm,
        right       = 15mm,
        footskip    = 10mm,
        marginparwidth = 0in
    }
}

% Used for the first page of each appendix chapter (no page number
% resets here - that's handled separately, see "APPENDIX" below).
\fancypagestyle{first}{%
    \renewcommand{\headrulewidth}{0pt}
    \fancyhf{}%
    \fancyfoot[C]{\thepage}%
}

%% ----------------------------------------------------------------------
%%  15. CROSS-REFERENCE NUMBERING & HYPERREF
%% ----------------------------------------------------------------------

\RequirePackage[colorlinks,allcolors=blue]{hyperref}
\RequirePackage{bookmark} % more robust PDF bookmarks/outline than hyperref alone provides
% Embeds \title/\author/\date (already set via hyperref's pdftitle/pdfauthor)
% as XMP metadata in the PDF, which search engines and indexers such as
% Google Scholar read to identify a document's title and authors.
\RequirePackage{hyperxmp}

% Figures/tables/equations are numbered continuously (1, 2, 3, ...)
% rather than per-chapter; this is overridden again in the appendix.
\renewcommand{\thefigure}{\arabic{figure}}
\renewcommand{\thetable}{\arabic{table}}
\renewcommand{\theequation}{\arabic{equation}}

%% ----------------------------------------------------------------------
%%  16. FOOTNOTES
%% ----------------------------------------------------------------------

\RequirePackage{footmisc}
\enlargethispage{\baselineskip}
\interfootnotelinepenalty=100000 % strongly discourage footnotes splitting across pages
\interlinepenalty=0

\setlength{\skip\footins}{5mm} % extra space above the footnote block
\renewcommand{\footnoterule}{%
    \kern -3pt
    \hrule width 0.2\textwidth height 0.5pt
    \kern 5pt
}
\long\def\@makefntext#1{\parindent 1em\noindent\normalfont\@thefnmark~#1}
\renewcommand{\thefootnote}{\arabic{footnote}}

%% ----------------------------------------------------------------------
%%  17. FIGURE/TABLE/FOOTNOTE COUNTERS
%% ----------------------------------------------------------------------

% Since chapters aren't used/numbered in the main body, unlink these
% counters from the chapter counter so book.cls doesn't reset them at
% each \chapter. Re-linked again inside the appendix below.
\RequirePackage{chngcntr}
\counterwithout{figure}{chapter}
\counterwithout{table}{chapter}
\counterwithout{footnote}{chapter}

%% ----------------------------------------------------------------------
%%  18. APPENDIX
%% ----------------------------------------------------------------------
% Redefines \appendix (from book.cls) so that, from this point on:
%   - chapters are lettered ("Appendix A", "Appendix B", ...) instead
%     of the (blank) main-body chapter numbering;
%   - figures/tables are numbered per chapter again (A.1, A.2, B.1, ...);
%   - each chapter heading is drawn as a green banner (mirroring the
%     title page), via a redefinition of book.cls's internal \@chapter/
%     \@makechapterhead - rather than the \titleformat{\chapter} used
%     in the main body.

\let\oldappendix\appendix
\renewcommand{\appendix}{%
    \setcounter{figure}{0}\setcounter{table}{0}%
    \counterwithin{figure}{chapter}%
    \counterwithin{table}{chapter}%
    \oldappendix
    \renewcommand\thechapter{\Alph{chapter}}%
    \renewcommand\thesection{\thechapter.\arabic{section}}%
    \renewcommand\thefigure{\thechapter.\arabic{figure}}%
    \newcommand{\section@cntformat}{\thesection\quad}%
    % Adapted from book.cls's \@chapter: skip the "starred chapter"
    % handling we don't need, and always use \@makechapterhead (no
    % \@topnewpage) so the heading uses our custom page style.
    \def\@chapter[##1]##2{%
        \thispagestyle{first}%
        \refstepcounter{chapter}%
        \@makechapterhead{##2}%
        \if@twocolumn\else\@afterheading\fi
    }
    \def\@makechapterhead##1{%
        \pagestyle{first}%
        \vspace*{0\p@}%
        {\begin{tikzpicture}[remember picture,overlay]
            % Green banner background, top of page.
            \node[anchor=north west,rectangle,
                  minimum width=\textwidth,minimum height=20mm,
                  fill=green0]
                 (AB) at (current page text area.north west) {};

            % e61 logo, right-aligned within the banner.
            \node[anchor=east,inner sep=0]
                 (LOG) at ([xshift=-5mm,yshift=1.0mm]AB.east)
                 {\includegraphics[scale=1.0]{e61_logo1}};

            % "APPENDIX <letter>: <title>", vertically centred in the banner.
            % \thechapter is already the appendix letter (A, B, ...) here --
            % \refstepcounter{chapter} in \@chapter above runs before this.
            \node[inner sep=0pt,align=flush left,
                  text width=150mm,xshift=4mm,
                  anchor=west,font={\color{white}\Bebas\fontsize{19pt}{22}\selectfont}]
                 (TIT) at ($(AB.south west)!0.5!(AB.north west)$)
                 {APPENDIX~\thechapter:~\MakeUppercase{##1}};
        \end{tikzpicture}
        \par\nobreak
        \vskip 40\p@}
    }
}

\endinput
