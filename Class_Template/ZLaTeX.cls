\ProvidesClass{ZLaTeX}[2023/09/12:Initial Template]
\NeedsTeXFormat{LaTeX2e}
\LoadClass{article}                             





% ----------------------------------------------------------------------
%                       1. kvoptions config 
% ----------------------------------------------------------------------
\RequirePackage{kvoptions}
\RequirePackage{etoolbox}
\SetupKeyvalOptions{%
    family=ZLATEX,
    prefix=ZLATEX@,
    setkeys=\kvsetkeys
}
\newcommand{\kvs}[1]{\kvsetkeys{ZLATEX}{#1}}
% MathFont Option
\DeclareVoidOption{eulervm}{\kvs{math=eulervm}} 
\DeclareVoidOption{mtpro}{\kvs{math=mtpro}} 
\DeclareVoidOption{mathptmx}{\kvs{math=mathptmx}} 
\DeclareStringOption[]{math}
% Template 'zLaTeX' lang prefer
\DeclareVoidOption{cn}{\kvs{lang=cn}}
\DeclareVoidOption{en}{\kvs{lang=en}}
\DeclareStringOption[cn]{lang}
% bibend and bibstyle setting
\DeclareVoidOption{biber}{\kvs{bibend=biber}}
\DeclareVoidOption{bibtex}{\kvs{bibend=bibtex}}
\DeclareStringOption[biber]{bibend}
\DeclareStringOption[numeric-comp]{citestyle}
\DeclareStringOption[numeric]{bibstyle}
% End of Option Declaration
\DeclareDefaultOption{
    \PassOptionsToClass{\CurrentOption}{article}
}
\ProcessKeyvalOptions*\relax





% ----------------------------------------------------------------------
%                           2.Check tenporary Compile Engine                                          
% ----------------------------------------------------------------------
\RequirePackage{ifxetex}
\ifdefstring{\ZLATEX@lang}{cn}{
    \ifxetex\relax
        \relax
    \else
        \ClassError{ZLaTeX}{Under class ZLATEX, Please Use XeTeX to compile the *.tex file} 
    \fi
}{\relax}





% ----------------------------------------------------------------------
%                               3.Page Layout 
% ----------------------------------------------------------------------
% 3.1 marginwidth, head, foot
% Standard A4 size(ISO 216, inch):8.27 × 11.69
\RequirePackage{geometry}
\RequirePackage{fancyhdr}
% length define
\newlength{\left@sep}
\newlength{\post@right@sep}
\newlength{\top@sep}
\newlength{\he@dheight}
\newlength{\hdr@ffset}
\setlength{\left@sep}{.1\paperwidth}
\setlength{\top@sep}{.1\paperheight}
\setlength{\he@dheight}{0.05\paperheight}
% Initial Seeting:left = 1.25right, bottom = 1.375top 
\geometry{
    % body settings(Clip paper, Ratio=sqrt(2))
    paperheight=12.02in, paperwidth=8.5in,                  
    left=\left@sep, 
    top=\top@sep, height=.9\paperheight,
    marginparsep=\dimexpr(1\paperwidth-2\left@sep)/25, marginparwidth=\dimexpr(1.3\left@sep),
    % body internal setting(Clip body)  
    width=\dimexpr(1\paperwidth-1\marginparsep-1\marginparwidth-2\left@sep),
    headheight=\he@dheight, headsep=.02\paperheight, footskip=.05\paperheight,
}
% store temporary \post@right@sep
\setlength{\post@right@sep}{\dimexpr(1\paperwidth-1\left@sep-1\textwidth-1\marginparsep-1\marginparwidth)}
% 3.2 define page style
\fancypagestyle{fancy}{%
    \fancyhf{}                                          
    \setlength{\hdr@ffset}{\dimexpr(1\paperwidth-1\textwidth-\marginparsep)/2}
    \fancyheadoffset[rh]{\hdr@ffset}
    % To redefine \headrule not \headrulelength 
    % \renewcommand{\headrule}{\color{black}\hrule width.8\paperwidth}
    \renewcommand{\headrulewidth}{1pt}
    \fancyhead[R]{\S\number\numexpr\value{chapter}-0\relax.\;\currentch@ptername}
    \fancyhead[L]{\thepage}
}
% define 'speci@l' pagestyle for nomargin page
\fancypagestyle{speci@l}{
    \fancyhf{}
    \setlength{\hdr@ffset}{0pt}
    \fancyheadoffset[rh]{\hdr@ffset}
    \renewcommand{\headrulewidth}{1pt}
    \fancyhead[R]{\S\number\numexpr\value{chapter}-0\relax.\;\currentch@ptername}
    \fancyhead[L]{\thepage}
}
\fancypagestyle{plain}{%
    \renewcommand{\headrulewidth}{0pt}
    \fancyhf{}
    \renewcommand{\headrule}{}
    \fancyfoot[C]{\Roman{page}}
    % To cancle page number in 'contents' page, You need to redefine the 'plain' pagestyle
    % Avoid using command '\addtocontents{toc}{\protect\thispagestyle{empty}}' 
}
\pagestyle{fancy}
% 3.3 change current geometry
\renewcommand{\newgeometry}[1]{
    \Gm@restore@org
    \Gm@initnewgm
    \Gm@newgmtrue
    \setkeys{Gm}{#1}
    \Gm@newgmfalse
    \Gm@process
    \ifnum\mag=\@m\else\Gm@magtooffset\fi
    \Gm@changelayout
    \Gm@showparams{newgeometry}
}
\renewcommand{\restoregeometry}{
    \Gm@restore@pkg
    \Gm@changelayout
}
\newcommand{\cancle@margin}[1][.8]{%
    \newgeometry{             
        left=\dimexpr(5\left@sep-#1\dimexpr(5\left@sep))\relax,
        top=\top@sep, height=.838\paperheight, 
        width=\dimexpr(.2\paperwidth+#1\paperwidth-1\left@sep-1.3\post@right@sep),
        headheight=\he@dheight, headsep=.02\paperheight, footskip=.05\paperheight,
    }
    \thispagestyle{speci@l}
    % restore origin geomtry the next page(temporary failed)
    % \afterpage{
    %     \restoregeometry
    % }
}
\newcommand{\start@margin}{\restoregeometry\relax}
\newcommand{\nomargin}[1][.8]{\clearpage\cancle@margin[#1]\relax}
\newcommand{\margin}{\clearpage\start@margin\relax}





% ----------------------------------------------------------------------
%                               4.Font Config
% ----------------------------------------------------------------------
\PassOptionsToPackage{quiet}{fontspec}
\RequirePackage{ctex}               % basic chinese font package
\RequirePackage{thmtools,amsmath}   % basic math package
\RequirePackage{amsfonts}           % which provide more math font 
\RequirePackage{bm}                 % bold math font 
\ifdefstring{\ZLATEX@math}{eulervm}{
    \RequirePackage[OT1, euler-digits]{eulervm}
}{\relax}
\ifdefstring{\ZLATEX@math}{mtpro}{
    \RequirePackage[lite,subscriptcorrection,slantedGreek,nofontinfo]{mtpro2}
}{\relax}
\ifdefstring{\ZLATEX@math}{mathptmx}{
    \RequirePackage[T1]{fontenc}
    \RequirePackage{mathptmx}
}{\relax}
% 4.1 Math Font
% 4.2 English font
\newfontfamily{\Marcellus}[Path=./Fonts/]{Marcellus.ttf}
% 4.3 chinese Font





% ----------------------------------------------------------------------
%                               5.Optional Package
% ----------------------------------------------------------------------
\RequirePackage{enumerate}          % 'enumerate' env personal config 
\RequirePackage{framed}             % framed box
\RequirePackage{booktabs}           % use three-line table 
\RequirePackage{multicol}           % use multicol table
\RequirePackage{marginnote}         % Margin setting
\let\m@rginnote\marginnote
\renewcommand{\marginnote}[2][-6em]{
    \m@rginnote[]{\kaishu #2}[#1]
}





% ----------------------------------------------------------------------
%                           6.TikZ Setting
% ----------------------------------------------------------------------
% 6.1 tikz config
\RequirePackage[usenames,dvipsnames]{xcolor}
\RequirePackage{tikz}
\RequirePackage{pgfplots}
\pgfplotsset{compat=1.18}       





% ----------------------------------------------------------------------
%                                   7.Graphics
% ----------------------------------------------------------------------
\RequirePackage{graphicx}
\RequirePackage{subcaption}
\RequirePackage{float}
\graphicspath{{./figure/}{./figures/}{./image/}{./images/}{./graphics/}{./graphic/}{./pictures/}{./picture/}{./Pics}{./pics}}





% ----------------------------------------------------------------------
%                               8.Reference Setting
% ----------------------------------------------------------------------
\bibliographystyle{plain}
\RequirePackage[
    backend=\ZLATEX@bibend,
    citestyle=\ZLATEX@citestyle,
    bibstyle=\ZLATEX@bibstyle
]{biblatex}





% ----------------------------------------------------------------------
%                               9.Counter
% ----------------------------------------------------------------------
% 9.1 Reset Counter 
\newcommand{\resetcount}{%
    \setcounter{section}{0}
    \setcounter{subsection}{0}
    \setcounter{equation}{0}
    % math env reset
    \setcounter{definition}{0}
    \setcounter{theorem}{0}
    \setcounter{proposition}{0}
    \setcounter{corollary}{0}
    \setcounter{lemma}{0}
}
% 9.2 chapter counter
\RequirePackage{tocloft}
\RequirePackage{titletoc}
\newcounter{chapter}
\newcommand{\currentch@ptername}{}
\newlength{\title@skip}
\newcommand{\chapter}[1]{%
    \clearpage
    \resetcount
    \stepcounter{chapter}
    \begin{tikzpicture}[overlay, remember picture]
        \node[anchor=north east, xshift=0cm, yshift=-7cm] at (current page.north east)
            {\color{gray} \sffamily \scalebox{4}{Chapter \Roman{chapter}}\hspace*{3em}};
        \node[anchor=north east, xshift=0cm, yshift=-11cm] at (current page.north east)
            {\color{gray} \sffamily \scalebox{2.5}{#1}\hspace*{3em}}; 
    \end{tikzpicture}
    % Get current chapter name
    \renewcommand{\currentch@ptername}{#1}%
    \ifnum\value{chapter}=1\relax
        \setcounter{page}{1}
        \thispagestyle{empty}
        \setlength{\title@skip}{0em}
    \else%
        \setlength{\title@skip}{0em}
    \fi
    % add 'chapter' to contents
    \addcontentsline{toc}{section}{%
        \kern-1em\large Chapter \Roman{chapter}: #1 
    }
    % \addtocounter{page}{-1}
    \thispagestyle{empty}
    \clearpage
}





% ----------------------------------------------------------------------
%                               10.Contents setting
% ----------------------------------------------------------------------
\newcommand{\ZLATEX@Author@Name}{作者}
\ifdefstring{\ZLATEX@lang}{en}{%
    \renewcommand{\ZLATEX@Author@Name}{Author}
}{\relax}
% 10.1 background picture
\usetikzlibrary{calc}
\newcommand{\cover}[3][./Pics/Cover_3.png]{%
    \begin{titlepage}
    \newlength{\note@name@width}
    \newlength{\author@name@width}
    \newlength{\note@name@push@left}
    \settowidth{\note@name@width}{\scalebox{3.5}{{\sffamily #2}}}
    \settowidth{\author@name@width}{\sffamily\color{gray}\huge \ZLATEX@Author@Name:\;#3}
    \setlength{\note@name@push@left}{5em}
    \begin{tikzpicture}[overlay, remember picture]
        % Backgroud Picture
        \node[anchor=north east, xshift=10pt, yshift=10pt] at (current page.north east)
            {\includegraphics[width=\dimexpr1\paperwidth+10pt]{#1}};
        % Blank space
        \draw[fill=white] (current page.south west) rectangle ++(1\paperwidth, 25em);
        \draw[fill=black, draw=black] (current page.south west)++(1\paperwidth-2em-\note@name@width-\note@name@push@left, 20.2em) rectangle ++(\note@name@width+\note@name@push@left, 2pt);
        % Note's Name
        \node[anchor=south west, xshift=\dimexpr(-\note@name@width-2em), yshift=16em]
            at (current page.south east) {\scalebox{3.5}{{\sffamily #2}}};
        % Author's Name
        \node[anchor=south west, xshift=\dimexpr(-\author@name@width-2em), yshift=10em]
            at (current page.south east) {\sffamily\color{gray}\huge \ZLATEX@Author@Name:\;#3};
    \end{tikzpicture}
    \setcounter{page}{0}
    \end{titlepage}
}
% 10.2 chapter redefine
\let\old@chapter\chapter                        
\renewcommand{\chapter}[1]{%
    \addtocontents{toc}{%
        \protect\mbox{}\protect\hspace*{1.7em}\rule[-2em]{.03\textwidth}{.006\textheight}%
        \rule[-2em]{\dimexpr.96\textwidth-2em}{.5pt}\par%
    }
    \old@chapter{#1}
}
\renewcommand{\cftsecindent}{3em}
\renewcommand{\cftsubsecindent}{4.5em}
\renewcommand{\cftsubsubsecindent}{6em}
\setlength{\cftsecnumwidth}{10pt}
% 10.3 output contents
\newcommand{\contents}[1][.83]{%
    \nomargin[#1]
    \setcounter{tocdepth}{2}
    \begin{center}
        \tableofcontents
    \end{center}
    \thispagestyle{plain}
    \margin
}
% 10.4 content name according to 'lang'
\ifdefstring{\ZLATEX@lang}{cn}{%
    \renewcommand{\contentsname}{目录}
}{\relax}
\ifdefstring{\ZLATEX@lang}{en}{%
    \renewcommand{\contentsname}{Contents}
}{\relax}





% ----------------------------------------------------------------------
%                               11.Math Environment
% ----------------------------------------------------------------------
\RequirePackage[most]{tcolorbox}
\RequirePackage[strict]{changepage}
\newcommand{\m@thenvfl@g}{}
% 11.1 definition,theorem Env
\newcounter{definition}
\newcounter{theorem}
\newcounter{proposition}
\newcounter{corollary}
\newcounter{lemma}
% 11.2 Math environments name according to 'lang'
\ifdefstring{\ZLATEX@lang}{cn}{%
    \newcommand{\ZLATEX@difinition@name}{定义}
    \newcommand{\ZLATEX@theorem@name}{定理}
    \newcommand{\ZLATEX@proposition@name}{命题}
    \newcommand{\ZLATEX@corollary@name}{推论}
    \newcommand{\ZLATEX@lemma@name}{引理}
}{\relax}
\ifdefstring{\ZLATEX@lang}{en}{%
    \newcommand{\ZLATEX@difinition@name}{Difinition}
    \newcommand{\ZLATEX@theorem@name}{Theorem}
    \newcommand{\ZLATEX@proposition@name}{Proposition}
    \newcommand{\ZLATEX@corollary@name}{Corollary}
    \newcommand{\ZLATEX@lemma@name}{Lemma}
}{\relax}
% 11.3 Muti Functions Env:definition@theorem & proposition@corollary@lemma
% definition, theorem Env
\newenvironment{definition@theorem}[2][]{% 
        % Params illustration
        % #1 --> definition@theorem's name
        % #2 --> Total background color
        \newcommand{\definition@theorem@title}{}
        \ifdefstring{\m@thenvfl@g}{definition}{
            \renewcommand{\definition@theorem@title}{\ZLATEX@difinition@name\;\thedefinition #1}
        }{%
            \ifdefstring{\m@thenvfl@g}{theorem}{
                \renewcommand{\definition@theorem@title}{\ZLATEX@theorem@name\;\thetheorem #1}
            }{\relax}
        }%
        \begin{tcolorbox}[%
            enhanced,
            arc=3pt,
            frame hidden,
            attach boxed title to top left={xshift=0pt, yshift=-1pt},%
            colback=#2,
            coltitle=black,
            title=\definition@theorem@title,
            boxed title style={arc=1.5pt, frame hidden, colback=#2}%
        ]%
        % \sffamily                 % en & zh font settings
        \Marcellus                  % en font settings
        \fangsong                   % zh font settings
        % \sansmath                 % math font settings
}{\end{tcolorbox}}
% proposition, corollary, lemma Env
\newenvironment{proposition@corollary@lemma}[2][]{%
    % Params illustration
    % #1 --> proposition@corollary@lemma's name
    % #2 --> proposition@corollary@lemma's background and face color
    % Warning: Use 'red' as default color to avoid writer's ignore
    \newcommand{\proposition@corollary@lemma@name}{}
    \ifdefstring{\m@thenvfl@g}{proposition}{
        \renewcommand{\proposition@corollary@lemma@name}{\textbf{\ZLATEX@proposition@name\;\theproposition #1}}
    }{%
        \ifdefstring{\m@thenvfl@g}{corollary}{
            \renewcommand{\proposition@corollary@lemma@name}{\textbf{\ZLATEX@corollary@name\;\theproposition #1}}
        }{%
            \ifdefstring{\m@thenvfl@g}{lemma}{
                \renewcommand{\proposition@corollary@lemma@name}{\textbf{\ZLATEX@lemma@name\;\theproposition #1}}
            }{\relax}
        }%
    }%
    \def\FrameCommand{%
        \hspace{1pt}%
        {\color{#2}\vrule width 1.5pt}%
        {\color{#2!10}\vrule width 2pt}%
        \colorbox{#2!10}%
    }%
    \MakeFramed{\advance\hsize-\width\FrameRestore}%
    \noindent\hspace{-4.55pt}%
    \begin{adjustwidth}{}{7pt}%
    \vspace{2pt}\vspace{2pt}%
    % before \proposition@corollary@lemma@name writes here
    \proposition@corollary@lemma@name\;
}{%
    \vspace{2pt}
    \end{adjustwidth}
    \endMakeFramed%
}
% 11.4 Specific each math environment
\definecolor{definition@color}{HTML}{d2dae2}
\definecolor{theorem@color}{HTML}{95a5a6}
\definecolor{proposition@color}{HTML}{1e90ff}
\definecolor{corollary@color}{HTML}{1abc9c}
\definecolor{lemma@color}{HTML}{ff7f50}
% 1> difinition environment
\newenvironment{definition}[2][]{%
    \stepcounter{definition}
    % def connect symbol
    \expandafter\ifx\expandafter\relax\detokenize{#1}\relax
        \def\c@nnect{}
    \else
        \def\c@nnect{:}
    \fi
    % Renew math env flag
    \renewcommand{\m@thenvfl@g}{definition}       
    \begin{definition@theorem}[\c@nnect{}#1]{definition@color!40}
}{\end{definition@theorem}}
% 2> theorem environment
\newenvironment{theorem}[2][]{%
    \stepcounter{theorem}
    % def connect symbol
    \expandafter\ifx\expandafter\relax\detokenize{#1}\relax
        \def\c@nnect{}
    \else
        \def\c@nnect{:}
    \fi 
    % Renew math env flag
    \renewcommand{\m@thenvfl@g}{theorem} 
    \begin{definition@theorem}[\c@nnect{}#1]{theorem@color!25}
}{\end{definition@theorem}}
% 3> proposition environment 
\newenvironment{proposition}[1][]{%
    \stepcounter{proposition}
    % def connect(illustrate) symbol
    \expandafter\ifx\expandafter\relax\detokenize{#1}\relax
        \def\c@nnect{}
    \else
        \def\c@nnect{(#1)}
    \fi
    % Renew math env flag
    \renewcommand{\m@thenvfl@g}{proposition} 
    \begin{proposition@corollary@lemma}[\c@nnect]{proposition@color}
}{\end{proposition@corollary@lemma}}
% 4> corollary environment 
\newenvironment{corollary}[1][]{%
    \stepcounter{corollary}
    % def connect(illustrate) symbol
    \expandafter\ifx\expandafter\relax\detokenize{#1}\relax
        \def\c@nnect{}
    \else
        \def\c@nnect{(#1)}
    \fi
    % Renew math env flag
    \renewcommand{\m@thenvfl@g}{corollary} 
    \begin{proposition@corollary@lemma}[\c@nnect]{corollary@color}
}{\end{proposition@corollary@lemma}}
% 5> lemma environment 
\newenvironment{lemma}[1][]{%
    \stepcounter{lemma}
    % def connect(illustrate) symbol
    \expandafter\ifx\expandafter\relax\detokenize{#1}\relax
        \def\c@nnect{}
    \else
        \def\c@nnect{(#1)}
    \fi
    % Renew math env flag
    \renewcommand{\m@thenvfl@g}{lemma} 
    \begin{proposition@corollary@lemma}[\c@nnect]{lemma@color}
}{\end{proposition@corollary@lemma}}





% ----------------------------------------------------------------------
%                               9.Code print Environment 
% ----------------------------------------------------------------------
\RequirePackage{listings}
\newcounter{code}
\stepcounter{code}
\definecolor{dkgreen}{rgb}{0,0.6,0}
\definecolor{gray}{rgb}{0.5,0.5,0.5}
\definecolor{mauve}{rgb}{0.58,0,0.82}
% Env setting
\lstset{
    frame=tb,
    aboveskip=3mm,
    belowskip=3mm,
    showstringspaces=false,
    columns=flexible,
    framerule=1pt,
    rulecolor=\color{gray!35},
    backgroundcolor=\color{gray!5},
    basicstyle={\small\ttfamily},
    numbers=left,
    numbersep=5pt,
    numberstyle=\small\color{gray}\ttfamily,
    keywordstyle=\color{blue},
    commentstyle=\color{dkgreen},
    stringstyle=\color{mauve},
    breaklines=true,
    postbreak=\raisebox{0ex}[0ex][0ex]{\ensuremath{\hookrightarrow\space}},
    breakatwhitespace=true,
    tabsize=4,
}
\lstnewenvironment{bytes}[1][\f@size]           % setting default code fontsize = \normalsize 
{
    \lstset{%
        basicstyle=\fontsize{#1pt}{#1pt}\selectfont\ttfamily, 
    }
}{}
% define 'code' env 
\lstnewenvironment{code}[2][]{%
    \lstset{language=#2}
    \stepcounter{code}
}{}




% ----------------------------------------------------------------------
%                               End of 'ZLaTeX' Document Class
% ----------------------------------------------------------------------
% Template logo
\newcommand{\zlatex}{\scalebox{-1.1}[-1]{\raise-.5em\hbox{\textcolor{blue}{$\pi$}}}\LaTeX}
\endinput 