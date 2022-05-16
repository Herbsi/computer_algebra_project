% turtwig.sty
% My general purpose, math-heavy LaTeX class
% 12021-12-29
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{turtwig}

\RequirePackage{etoolbox}
\RequirePackage{kvoptions}

% --- Class structure: declaration of options part
% ---
\SetupKeyvalOptions{family=turtwig, prefix=turtwig@}

\DeclareBoolOption{article}
\DeclareBoolOption{math}
\DeclareBoolOption{homework}

% Language
% Possible Values:
% - english
% - german
\DeclareStringOption[english]{language}

% Font
% Possible Values:
% - lmodern
% - libertinus
% - stix
\DeclareStringOption[lmodern]{font}

\DeclareDefaultOption{
  \ifbool{turtwig@article}{
    \PassOptionsToClass{\CurrentOption}{scrartcl}
  }{
    \PassOptionsToClass{\CurrentOption}{scrreprt}
  }
}

% --- Class structure: execution of options part
% ---
\ProcessKeyvalOptions*

% --- Class structure: declaration of options part
% ---
\ifbool{turtwig@article}{
  \LoadClass{scrartcl}
}{
  \LoadClass{scrreprt}
}

% --- Some nice packages
\RequirePackage{xparse}
\RequirePackage{enumitem}

% Hyperref
\RequirePackage[
  unicode=true,%
  pdfencoding=unicode,%
  %pdftex,%
  % backref,%
  bookmarks=true,%
  pdfpagemode=UseNone,%
]{hyperref}

% --- Language
\RequirePackage{polyglossia}
\ifdefstring{\turtwig@language}{english}{
  \setdefaultlanguage[variant=american]{english}
}{}
\ifdefstring{\turtwig@language}{german}{
  \setdefaultlanguage[variant=austrian,spelling=new]{german}
  \gappto\captionsgerman{\renewcommand{\chapterautorefname}{Kapitel}}
  \gappto\captionsgerman{\renewcommand{\chaptername}{Kapitel}}
  \gappto\captionsgerman{\renewcommand{\sectionautorefname}{Abschnitt}}
  % \gappto\captionsgerman{\renewcommand{\sectionname}{Abschnitt}}
}{}

% --- Font Loading
\RequirePackage[T1]{fontenc}
\RequirePackage{fontspec}
\ifdefstring{\turtwig@font}{lmodern}{
  \setmainfont{Latin Modern Roman}
}{}
\ifdefstring{\turtwig@font}{libertinus}{
  \setmainfont{Libertinus Serif}
  \setsansfont{Libertinus Sans}
}{}
\ifdefstring{\turtwig@font}{stix}{
  \setmainfont{STIX Two Text}
  \setsansfont{Source Sans Pro}
}{}

% Quotes
\RequirePackage[autostyle=true]{csquotes}

% --- Math Configuration
\ifbool{turtwig@math}
{
  % Load various packages
  \RequirePackage{amsmath,amssymb}
  \RequirePackage{mathtools}
  \RequirePackage{amsthm}
  \RequirePackage{thmtools}

  %% unicode-math turns the text produced by, say \symbf{foo} into actual unicode
  \RequirePackage[%
    math-style=ISO,%
    bold-style=TeX,%
    mathrm=sym,mathit=sym,mathsf=sym,mathbf=sym,mathtt=sym]%
  {unicode-math}
  \ifdefstring{\turtwig@font}{lmodern}{
    \setmathfont{Latin Modern Math}
  }{}
  \ifdefstring{\turtwig@font}{libertinus}{
    \setmathfont{Libertinus Math}
  }{}
  \ifdefstring{\turtwig@font}{stix}{
    \setmathfont{STIX Two Math}
  }{}


  % Deliminators
  \DeclarePairedDelimiterX{\abs}[1]{\lvert}{\rvert}{\ifblank{#1}{\:\cdot\:}{#1}}
  \DeclarePairedDelimiterX{\@norm}[1]{\lVert}{\rVert}{\ifblank{#1}{\:\cdot\:}{#1}}
  \NewDocumentCommand{\norm}{s o m}{%
    \IfBooleanTF#1%
    {\IfNoValueTF{#2}{\@norm*{#3}}{\@norm*{#3}_{#2}}}
    {\IfNoValueTF{#2}{\@norm{#3}}{\@norm*{#3}_{#2}}}
  }

  \DeclarePairedDelimiter{\ceil}{\lceil}{\rceil}
  \DeclarePairedDelimiter{\floor}{\lfloor}{\rfloor}
  \DeclarePairedDelimiter{\round}{\lfloor}{\rceil}

  \providecommand\given{\nonscript\:\vert\nonscript\:}
  \DeclarePairedDelimiterX%
  {\Set}[1]{\{}{\}}{%
    \renewcommand\given{%
      \nonscript\:\delimsize\vert\nonscript\:\mathopen{}}%
    \, #1 \,
  }

  %% Number Sets
  \newcommand{\RR}[1][]{\ensuremath{\ifstrempty{#1}{\mathbb{R}}{\mathbb{R}^{#1}}}}
  \newcommand{\NN}[1][]{\ensuremath{\ifstrempty{#1}{\mathbb{N}}{\mathbb{N}^{#1}}}}
  \newcommand{\ZZ}[1][]{\ensuremath{\ifstrempty{#1}{\mathbb{Z}}{\mathbb{Z}^{#1}}}}
  \newcommand{\QQ}[1][]{\ensuremath{\ifstrempty{#1}{\mathbb{Q}}{\mathbb{Q}^{#1}}}}
  \newcommand{\CC}[1][]{\ensuremath{\ifstrempty{#1}{\mathbb{C}}{\mathbb{C}^{#1}}}}
  \newcommand{\PP}[1][]{\ensuremath{\ifstrempty{#1}{\mathbb{P}}{\mathbb{P}^{#1}}}}
  \newcommand{\HH}[1][]{\ensuremath{\ifstrempty{#1}{\mathbb{H}}{\mathbb{H}^{#1}}}}
  \newcommand{\FF}[1][]{\ensuremath{\ifstrempty{#1}{\mathbb{F}}{\mathbb{F}_{\!#1}}}}

  % I prefer the slanted \leq
  \let\oldleq\leq % save them in case they're every wanted
  \let\oldgeq\geq
  \renewcommand{\leq}{\leqslant}
  \renewcommand{\geq}{\geqslant}

  % Commas, Semicolons, and periods at the end of equations
  \newcommand{\mcomma}[1][\mathrlap]{#1{,}}
  \newcommand{\msemicolon}[1][\mathrlap]{#1{;}}
  \newcommand{\mperiod}[1][\mathrlap]{#1{.}}
}{}

% --- Homework
\ifbool{turtwig@homework}{
  \declaretheoremstyle[%
    spaceabove=6pt, spacebelow=3pt,%
    headfont=\normalfont\bfseries,%
    notefont=\normalfont\bfseries,%
    bodyfont=\itshape,%
    postheadspace=1em
  ]{homework}

  \declaretheoremstyle[%
    spaceabove=0pt, spacebelow=6pt,%
    headfont=\normalfont\itshape,%
    headformat={\NAME},%
    bodyfont=\normalfont,%
    qed=\qedsymbol%
  ]{solution}
  \declaretheorem[name=Solution, style=solution]{solution}
}{}
