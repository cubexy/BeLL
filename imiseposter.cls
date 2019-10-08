%%
%% This is file `imiseposter.cls', a copy of 'baposter.cls' with very slight modifications to conform to the corporate design of IMISE and the medical faculty of the University of Leipzig.
%%
%% A relatively comfortable latex class to produce posters with a grid based
%% layout. It comes with a number of combinable styles and is (maybe only for
%% the writer) easy to extend, as all the graphics is based on pgf.
%%
%% It is meant to be used with pdftex, but might also work with pslatex if you
%% are not interested in things like transparency.
%% Original Template:
%% Copyright (C) 2007-2011 Brian Amberg
%% Copyright (C) 2011      Reinhold Kainhofer <reinhold@kainhofer.com>
%% Licence: GPL%%
%% 24. October 2011: 
%%     - The grid was broken when not explicitly specifying the column number, this has been fixed now.
%%     - The perennial text border faded was still broken, it just faded to the other text border color, not to transparent. Now also fixed
%%     - Implemented the noheaderbox, when no text is given, the box will have no header and the content will be moved up accordingly.
%% 29. September 2011: 
%%     - Finally fixed confusion with paper size handling and landscape. This required seperate handling of papersizes 
%%       known to the geometry package and other packages.
%% 26. September 2011:
%%     - Reverted drawing of faded borders to manual method, as the current result does not work with evince, 
%%       and produced spurious colored boxes with okular and acroread.
%%     - Added one more example due to popular request
%% 16. September 2011:


\ProvidesClass{imiseposter}[2011/11/26 v2.0 imiseposter class]
\NeedsTeXFormat{LaTeX2e}[1995/06/01]
\LoadClass[10pt]{extarticle}
\typeout{baposter: Brian Amberg, 2007, 2008, 2009, 2010, 2011 | http://www.brian-amberg.de/uni/poster/}
\typeout{baposter: Reinhold Kainhofer, 2011 | http://reinhold.kainhofer.com/}


%% Define lengths only once on inclusion, such that we can make multiple posters
\newlength{\imiseposter@basepaperwidth}
\newlength{\imiseposter@basepaperheight}
\newlength{\imiseposter@basemargin}
\newlength{\imiseposter@finalpaperwidth}
\newlength{\imiseposter@finalpaperheight}
\newlength{\imiseposter@finalmargin}
\newlength{\headerheight}%
\newlength{\colwidth}%
\newlength{\colheight}%
\newlength{\imiseposter@@colspacing}%
\newlength{\imiseposter@box@@cornerradius}%
\newlength{\imiseposter@box@@boxheaderheight}%
\newlength{\imiseposter@box@@boxpadding}%
\newlength{\boxstartx}%
\newlength{\boxstarty}%
\newlength{\boxwidth}%
\newlength{\boxheight}%
\newlength{\imiseposter@titleimage@left@width}%
\newlength{\imiseposter@titleimage@right@width}%
\newlength{\imiseposter@titleimage@textwidth}%
\newbox\imiseposter@box@content%
\newbox\imiseposter@titleimage@left%
\newbox\imiseposter@titleimage@title%
\newbox\imiseposter@titleimage@right%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Packages
%-------------------------------------------------------------------------------
% The only ``weird'' dependency of this package is pgf. All the rest should be
% installed on any decent system.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\typeout{Use Packages}
\RequirePackage{xkeyval}
\RequirePackage{calc}
%\RequirePackage[cmyk]{xcolor}
\RequirePackage{tikz}
\RequirePackage{pgf}
\RequirePackage{ifthen}
\RequirePackage[T1]{fontenc}
%\RequirePackage[l2tabu, orthodox]{nag}
\usetikzlibrary{decorations}
\usetikzlibrary{fadings}
\usetikzlibrary{snakes}
\usetikzlibrary{calc}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Choose a smaller value for larger fonts
\newcommand{\imiseposter@fontscale}{0.292}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Zoom
%-------------------------------------------------------------------------------
% We scale the page from fontscale * papersize up to papersize
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Paper sizes
\newif\if@landscape
\newif\if@geometryKnowsThisSize
\DeclareOptionX{landscape}{\@landscapetrue}
\DeclareOptionX{portrait}{}

\newcommand{\imiseposter@setfinalpapersize}[2]{%
\if@geometryKnowsThisSize
  \setlength{\imiseposter@finalpaperwidth}{#1}%
  \setlength{\imiseposter@finalpaperheight}{#2}%
\else
\if@landscape
% Transpose length, if geometry does not handle the papersize based on the key
  \setlength{\imiseposter@finalpaperwidth}{#2}%
  \setlength{\imiseposter@finalpaperheight}{#1}%
\else
  \setlength{\imiseposter@finalpaperwidth}{#1}%
  \setlength{\imiseposter@finalpaperheight}{#2}%
\fi
\fi
}

% Default paperwidth and paperheight = a0paper
\DeclareOptionX{paperwidth}[841mm]{\setlength{\imiseposter@finalpaperwidth}{#1}}
\DeclareOptionX{paperheight}[1189mm]{\setlength{\imiseposter@finalpaperheight}{#1}}
\DeclareOptionX{archA}         {                           \imiseposter@setfinalpapersize{9in}{12in}}%
\DeclareOptionX{archB}         {                           \imiseposter@setfinalpapersize{12in}{18in}}%
\DeclareOptionX{archC}         {                           \imiseposter@setfinalpapersize{18in}{24in}}%
\DeclareOptionX{archD}         {                           \imiseposter@setfinalpapersize{24in}{36in}}%
\DeclareOptionX{archE}         {                           \imiseposter@setfinalpapersize{36in}{48in}}%
\DeclareOptionX{archE1}        {                           \imiseposter@setfinalpapersize{30in}{42in}}%
\DeclareOptionX{archE2}        {                           \imiseposter@setfinalpapersize{26in}{38in}}%
\DeclareOptionX{archE3}        {                           \imiseposter@setfinalpapersize{27in}{39in}}%
\DeclareOptionX{a0paper}       {\@geometryKnowsThisSizetrue\imiseposter@setfinalpapersize{841mm}{1189mm}}%g
\DeclareOptionX{a1paper}       {\@geometryKnowsThisSizetrue\imiseposter@setfinalpapersize{594mm}{841mm}}%g
\DeclareOptionX{a2paper}       {\@geometryKnowsThisSizetrue\imiseposter@setfinalpapersize{420mm}{594mm}}%g
\DeclareOptionX{a3paper}       {\@geometryKnowsThisSizetrue\imiseposter@setfinalpapersize{297mm}{420mm}}%g
\DeclareOptionX{a4paper}       {\@geometryKnowsThisSizetrue\imiseposter@setfinalpapersize{210mm}{297mm}}%g
\DeclareOptionX{a5paper}       {\@geometryKnowsThisSizetrue\imiseposter@setfinalpapersize{148mm}{210mm}}%g
\DeclareOptionX{a6paper}       {\@geometryKnowsThisSizetrue\imiseposter@setfinalpapersize{105mm}{148mm}}%g
\DeclareOptionX{b0paper}       {\@geometryKnowsThisSizetrue\imiseposter@setfinalpapersize{1000mm}{1414mm}}%g
\DeclareOptionX{b1paper}       {\@geometryKnowsThisSizetrue\imiseposter@setfinalpapersize{707mm}{1000mm}}%g
\DeclareOptionX{b2paper}       {\@geometryKnowsThisSizetrue\imiseposter@setfinalpapersize{500mm}{707mm}}%g
\DeclareOptionX{b3paper}       {\@geometryKnowsThisSizetrue\imiseposter@setfinalpapersize{353mm}{500mm}}%g
\DeclareOptionX{b4paper}       {\@geometryKnowsThisSizetrue\imiseposter@setfinalpapersize{250mm}{353mm}}%g
\DeclareOptionX{b5paper}       {\@geometryKnowsThisSizetrue\imiseposter@setfinalpapersize{176mm}{250mm}}%g
\DeclareOptionX{b6paper}       {\@geometryKnowsThisSizetrue\imiseposter@setfinalpapersize{125mm}{176mm}}%g
\DeclareOptionX{ansiapaper}    {\@geometryKnowsThisSizetrue\imiseposter@setfinalpapersize{8.5in}{11in}}%
\DeclareOptionX{ansibpaper}    {\@geometryKnowsThisSizetrue\imiseposter@setfinalpapersize{11in}{17in}}%
\DeclareOptionX{ansicpaper}    {\@geometryKnowsThisSizetrue\imiseposter@setfinalpapersize{17in}{22in}}%
\DeclareOptionX{ansidpaper}    {\@geometryKnowsThisSizetrue\imiseposter@setfinalpapersize{22in}{34in}}%
\DeclareOptionX{ansiepaper}    {\@geometryKnowsThisSizetrue\imiseposter@setfinalpapersize{34in}{44in}}%
\DeclareOptionX{letterpaper}   {\@geometryKnowsThisSizetrue\imiseposter@setfinalpapersize{8.5in}{11in}}%
\DeclareOptionX{legalpaper}    {\@geometryKnowsThisSizetrue\imiseposter@setfinalpapersize{8.5in}{14in}}%
\DeclareOptionX{executivepaper}{\@geometryKnowsThisSizetrue\imiseposter@setfinalpapersize{7.25in}{10.5in}}%
\DeclareOptionX{screen}        {\@geometryKnowsThisSizetrue\imiseposter@setfinalpapersize{225mm}{180mm}}%g

% Margin
\setlength{\imiseposter@finalmargin}{1.5cm}
\DeclareOptionX{fontscale}[0.292]{\renewcommand{\imiseposter@fontscale}{#1}}
\DeclareOptionX{margin}   [1.5cm]{\setlength{\imiseposter@finalmargin}{#1}}

% move text/poster body to the right (or to the left if negative)
\newlength{\imiseposter@movebody}
\setlength{\imiseposter@movebody}{0cm}
\DeclareOptionX{movebody}[0cm]{\setlength{\imiseposter@movebody}{#1}}


\newif\if@debug
\DeclareOptionX{debug}{\@debugtrue}
%% Will be passed on to other packages (xcolor and geometry), still we don't want unused warnings
\DeclareOptionX{table}{}
\DeclareOptionX{showframe}{}

\ProcessOptionsX

\if@debug
\newcommand{\debug}[1]{\typeout{#1}}
\else
\newcommand{\debug}[1]{}
\fi



\setlength{\imiseposter@basepaperwidth} {\imiseposter@fontscale\imiseposter@finalpaperwidth }
\setlength{\imiseposter@basepaperheight}{\imiseposter@fontscale\imiseposter@finalpaperheight}
\setlength{\imiseposter@basemargin}     {\imiseposter@fontscale\imiseposter@finalmargin}
\newlength{\imiseposter@basemarginright}
\setlength{\imiseposter@basemarginright}{\imiseposter@basemargin}
\addtolength{\imiseposter@basemarginright}{-\imiseposter@fontscale\imiseposter@movebody}
\newlength{\imiseposter@basemarginleft}
\setlength{\imiseposter@basemarginleft}{\imiseposter@basemargin}
\addtolength{\imiseposter@basemarginleft}{\imiseposter@fontscale\imiseposter@movebody}

\typeout{Paperwidth=\the\imiseposter@finalpaperwidth}
\typeout{Paperheight=\the\imiseposter@finalpaperheight}
\typeout{BasePaperwidth=\the\imiseposter@basepaperwidth}
\typeout{BasePaperheight=\the\imiseposter@basepaperheight}
\usepackage[
   paperwidth=\imiseposter@basepaperwidth,
   paperheight=\imiseposter@basepaperheight,
   tmargin=\imiseposter@basemargin,
   bmargin=\imiseposter@basemargin,
   lmargin=\imiseposter@basemarginleft,
   rmargin=\imiseposter@basemarginright,
   ]{geometry} 

\usepackage{pgfpages}
\if@landscape
\if@geometryKnowsThisSize
\pgfpagesuselayout{resize to}[physical paper width=\imiseposter@finalpaperheight,physical paper height=\imiseposter@finalpaperwidth]
\else
\pgfpagesuselayout{resize to}[physical paper width=\imiseposter@finalpaperwidth,physical paper height=\imiseposter@finalpaperheight]
\fi
\else
\pgfpagesuselayout{resize to}[physical paper width=\imiseposter@finalpaperwidth,physical paper height=\imiseposter@finalpaperheight]
\fi



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Default functions for borders/backgrounds
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% These functions will all be redefined from the actual option values. In
%% particular, they will be set to \imiseposter@optionname@optionvalue, which
%% should do the actual work / setting for that particular optionvalue.

\newcommand{\imiseposterPosterDrawBackground}[2]{} % Draw poster background

\newcommand{\imiseposterBoxGetShape}{}             % Returns path of text box shape
\newcommand{\imiseposterBoxDrawBackground}[2]{}    % Draw bg of boxes
\newcommand{\imiseposterBoxDrawBorder}[1]{}        % Draw border of individual boxes

\newcommand{\imiseposterHeaderGetShape}{}          % Returns path of text box shape
\newcommand{\imiseposterHeaderSetShade}[3]{}       % Set bg style for box headers
\newcommand{\imiseposterHeaderDrawBackground}[3]{} % Draw background of box header
\newcommand{\imiseposterHeaderDrawBorder}[1]{}     % Draw border of box header
\newcommand{\imiseposterHeaderDrawText}[1]{}       % Draw text inside box header

\newcommand{\@@previousbox}{notset}             % stores the previously processed box for below=auto

% Function to set a user-defined background
\newcommand{\imiseposter@backgroundCmd}{\error{No background command defined. Use \background{...} to define background}}
\newcommand{\background}[1]{\renewcommand{\imiseposter@backgroundCmd}{#1}}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Handle poster and box options
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\debug{Handling keys}

%%
%% POSTER OPTIONS
%%
%% Store all poster options in variables of the form \imiseposter@option
%% choose-keys also store the index in \imiseposter@optionnr
%% choose-keys typically also assign a function
\definecolor{imiseposter@silver}{cmyk}{0,0,0,0.7}
\define@boolkey[ba]{poster}[imiseposter@]{grid}                 [false]       {}
\define@boolkey[ba]{poster}[imiseposter@]{eyecatcher}           [true]        {}
\define@cmdkey [ba]{poster}[imiseposter@]{headerheight}         [0.1\textheight]{}
\define@cmdkey [ba]{poster}[imiseposter@]{columns}              [{}]          {}
\define@cmdkey [ba]{poster}[imiseposter@]{colspacing}           [1em]         {}
\define@cmdkey [ba]{poster}[imiseposter@]{bgColorOne}           [imiseposter@silver]{}
\define@cmdkey [ba]{poster}[imiseposter@]{bgColorTwo}           [green]       {}

% background can be one of: shadeLR, shadeTB, plain, user, none
\define@choicekey*+[ba]{poster}{background}%
    [\imiseposter@background\imiseposter@backgroundnr]%
    {shadeLR, shadeTB, plain, user, none} [plain] {%
  \debug{Poster background: \imiseposter@background}
  \renewcommand{\imiseposterPosterDrawBackground}[2]{
      \csname imiseposter@background@\imiseposter@background\endcsname{##1}{##2}}
}{
  \PackageWarning{imiseposter}{Unknown background `\imiseposter@background' (use
      shadeLR, shadeTB, plain, none, or user). If user is used, you also
      have to define \background{...}.}
  \renewcommand{\imiseposterPosterDrawBackground}[2]{\imiseposter@background@none{##1}{##2}}
}


%%
%%  BOX OPTIONS
%%
\define@cmdkey[ba]{posterbox}[imiseposter@box@]{cornerradius}          [1em]         {}
\define@cmdkey[ba]{posterbox}[imiseposter@box@]{boxheaderheight}       [2em]         {}
\define@cmdkey[ba]{posterbox}[imiseposter@box@]{boxpadding}            [0.5em]       {}


% textborder can be one of: none, bars, coils, triangles, rectangle, rounded,
% roundedleft, roundedsmall, faded; UNIMPLEMENTED: roundedright
\edef\imiseposter@box@textborder@validvalues{none,bars,coils,triangles,rectangle,rounded,roundedleft,roundedsmall,faded}
\define@choicekey*+[ba]{posterbox}{textborder}%
    [\imiseposter@box@textborder\imiseposter@box@textbordernr]%
    {none,bars,coils,triangles,rectangle,rounded,roundedleft,roundedright,roundedsmall,faded} [rectangle] {%
  \debug{Text border: \imiseposter@box@textborder}
  \renewcommand{\imiseposterBoxGetShape}{
      \csname imiseposter@box@boxshape@\imiseposter@box@textborder\endcsname}
  \renewcommand{\imiseposterBoxDrawBorder}[1]{
      \csname imiseposter@box@drawborder@\imiseposter@box@textborder\endcsname{##1}}
}{
  \PackageWarning{imiseposter}{Unknown text-border style `\imiseposter@box@textborder'.
      Edit your file to choose a valid option (\imiseposter@box@textborder@validvalues).}
  \renewcommand{\imiseposterBoxGetShape}{\imiseposter@boxshape@rectangle}
  \renewcommand{\imiseposterBoxDrawBorder}[1]{\imiseposter@drawborder@rectangle{##1}}
}

% boxshade can be one of: shadeLR, shadeTB, plain, none
\define@choicekey*+[ba]{posterbox}{boxshade}%
    [\imiseposter@box@boxshade\imiseposter@box@boxshadenr]%
    {shadelr,shadetb,plain,none} [none] {%
  \debug{Box shade: \imiseposter@box@boxshade}
  \renewcommand{\imiseposterBoxDrawBackground}[2]{
      \csname imiseposter@box@drawbackground@\imiseposter@box@boxshade\endcsname{##1}{##2}}
}{
  \PackageWarning{imiseposter}{Unknown boxshade style `\imiseposter@boxshade'.
      Edit your file to choose a valid option.}
  \renewcommand{\imiseposterBoxDrawBackground}[2]{\imiseposter@box@drawbackground@none{##1}{##2}}
}

% headershade can be one of: shade-lr, shade-tb, shade-tb-inverse, plain
\define@choicekey*+[ba]{posterbox}{headershade}%
    [\imiseposter@box@headershade\imiseposter@box@headershadenr]%
    {shadelr,shadetb,shadetbinverse,plain} [shadelr] {%
  \debug{Header shade: \imiseposter@box@headershade}
  \renewcommand{\imiseposterHeaderSetShade}[3]{
      \csname imiseposter@box@headershade@\imiseposter@box@headershade\endcsname{##1}{##2}{##3}}
}{
  \PackageWarning{imiseposter}{Unknown headershade style `\imiseposter@box@headershade'.
      Edit your file to choose a valid option.}
  \renewcommand{\imiseposterHeaderSetShade}[3]{\imiseposter@box@headershade@none{##1}{##2}{##3}}
}

% headershape can be one of: rectangle, rounded, smallrounded, roundedleft, roundedright
\define@choicekey*+[ba]{posterbox}{headershape}%
    [\imiseposter@box@headershape\imiseposter@box@headershapenr]%
    {rectangle,rounded,smallrounded,roundedleft,roundedright} [roundedright] {%
  \debug{Header shape: \imiseposter@box@headershape}
  \renewcommand{\imiseposterHeaderGetShape}{
      \csname imiseposter@box@headershape@\imiseposter@box@headershape\endcsname}
  \renewcommand{\imiseposterHeaderDrawText}[1]{
      \csname imiseposter@box@headerdrawtext@\imiseposter@box@headershape\endcsname{##1}}
  \renewcommand{\imiseposterHeaderDrawBorder}[1]{
      \csname imiseposter@box@headerdrawborder@\imiseposter@box@headershape\endcsname{##1}}
}{
  \PackageWarning{imiseposter}{Unknown headershape style `\imiseposter@headershape'.
      Edit your file to choose a valid option.}
  \renewcommand{\imiseposterHeaderGetShape}{\imiseposter@box@headershape@rectangle}
  \renewcommand{\imiseposterHeaderDrawText}[1]{\imiseposter@box@headerdrawtext@rectangle{##1}}
  \renewcommand{\imiseposterHeaderDrawBorder}[1]{\imiseposter@box@headerdrawborder@rectangle{##1}}
}

% headerborder can be one of: open, closed, none
\define@choicekey*+[ba]{posterbox}{headerborder}%
    [\imiseposter@box@headerborder\imiseposter@box@headerbordernr]%
    {open,closed,none} [open] {%
  \debug{Header border: \imiseposter@box@headerborder}
%   \renewcommand{\imiseposterHeaderBorder}{
%       \csname imiseposter@headerborder@\imiseposter@box@headerborder\endcsname}
}{
  \PackageWarning{imiseposter}{Unknown headerborder style `\imiseposter@headerborder'.
      Edit your file to choose a valid option.}
%   \renewcommand{\imiseposterHeaderBorder}{\imiseposter@box@headerborder@rectangle}
}


\define@cmdkey[ba]{posterbox}[imiseposter@box@]{borderColor}           [yellow]      {}
\define@cmdkey[ba]{posterbox}[imiseposter@box@]{headerColorOne}        [red]         {}
\define@cmdkey[ba]{posterbox}[imiseposter@box@]{headerColorTwo}        [brown]       {}
\define@cmdkey[ba]{posterbox}[imiseposter@box@]{headerFontColor}       [black]       {}
\define@cmdkey[ba]{posterbox}[imiseposter@box@]{boxColorOne}           [magenta]     {}
\define@cmdkey[ba]{posterbox}[imiseposter@box@]{boxColorTwo}           [cyan]        {}
\define@cmdkey[ba]{posterbox}[imiseposter@box@]{headerfont}            [\scshape\Large]   {}
\define@cmdkey[ba]{posterbox}[imiseposter@box@]{textfont}              [{}]          {}
\define@cmdkey[ba]{posterbox}[imiseposter@box@]{boxopacity}            [1.0]   {}

\define@cmdkey[ba]{posterbox}[imiseposter@box@]{linewidth}             [2pt]         {}

\define@cmdkey[ba]{posterbox}[imiseposter@box@]{below}  [notset]{}
\define@cmdkey[ba]{posterbox}[imiseposter@box@]{above}  [notset]{}
\define@cmdkey[ba]{posterbox}[imiseposter@box@]{aligned}[notset]{}
\define@cmdkey[ba]{posterbox}[imiseposter@box@]{bottomaligned}[notset]{}
\define@cmdkey[ba]{posterbox}[imiseposter@box@]{column} [0]     {}
\define@cmdkey[ba]{posterbox}[imiseposter@box@]{row}    [0]     {}
\define@cmdkey[ba]{posterbox}[imiseposter@box@]{span}   [1]     {}
\define@cmdkey[ba]{posterbox}[imiseposter@box@]{height} [auto]  {}
\define@cmdkey[ba]{posterbox}[imiseposter@box@]{name}   [noname]{}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% IMISE Additions
\definecolor{mediblue}{RGB}{0,138,201}
\definecolor{medigray}{RGB}{157,157,157}
\definecolor{medidarkgray}{RGB}{71,80,84}
\definecolor{mixblue}{RGB}{0,167,214}
\definecolor{aquamarine}{RGB}{138,194,209}
%% IMISE Modifications 
% Set some default values, the poster and posterbox environments can override:
\setkeys[ba]{poster}{
  % Debug grid
  grid=false,
  % Is there an eyecatcher image
  eyecatcher=true,
  columns=2,
  colspacing=1em,
  % Colours
  bgColorOne=white,
  bgColorTwo=white,
  %
  headerheight=0.12\textheight,
  background=none,
}{}
\setkeys[ba]{posterbox}{
  % Position
  column=0,row=0,span=1,
  below=notset,above=notset,
  bottomaligned=notset,
  aligned=notset,
  height=auto,
  % Name
  name=noname,
  % Box design: border:
  borderColor=white,
  cornerradius=1em,
  % text box:
  textfont={},
  boxshade=none,
  boxColorOne=white,
  boxColorTwo=black,
  textborder=roundedleft,
  boxpadding=0.5em,
  % header
  %headerfont=\scshape\Large,% or headerfont=\color{white}\textsf\textbf
  headerFontColor=white,
  headerColorOne=mediblue,
  headerColorTwo=mediblue,
  headershape=rectangle,
  headerborder=none,
  boxheaderheight=2em,
  boxopacity=1.0,
  linewidth=0,
  headershade=shadelr,                                                                                   
  headerfont=\Large\bf\textsf, %Sans Serif
  textfont={\setlength{\parindent}{0em}},
  boxshade=plain,
}{}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Multicol Settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\setlength{\columnsep}{1.5em}
\setlength{\columnseprule}{0mm}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Save space in lists. Use this after the opening of the list
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\compresslist}{%
\setlength{\itemsep}{1pt}%
\setlength{\parskip}{0pt}%
\setlength{\parsep}{0pt}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Background options and functions (one function for each possible value)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\imiseposter@background@shadelr}[2]{
  \debug{imiseposter: Using shade left right background.}
  \begin{tikzpicture}[remember picture,overlay]%
    \shade [shading=axis,left color=#1,right color=#2] (current page.north west)
           rectangle(current page.south east);
  \end{tikzpicture}%
}
\newcommand{\imiseposter@background@shadetb}[2]{
  \debug{imiseposter: Using shade top to bottom background.}
  \begin{tikzpicture}[remember picture,overlay]%
    \shade [shading=axis,top color=#1,bottom color=#2] (current page.north west)
           rectangle(current page.south east);
  \end{tikzpicture}%
}
\newcommand{\imiseposter@background@plain}[2]{
  \debug{imiseposter: Using plain background.}
  \begin{tikzpicture}[remember picture,overlay]%
    \fill [fill=#1] (current page.north west) rectangle(current page.south east);
  \end{tikzpicture}%
}
\newcommand{\imiseposter@background@user}[2]{
  \debug{imiseposter: Using user background.}
  \imiseposter@backgroundCmd%
}
\newcommand{\imiseposter@background@none}[2]{
  \debug{imiseposter: Using no background.}
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Return shape path of text box (depending on the box shape)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\imiseposter@box@boxshape@none}{\imiseposter@box@boxshape@rectangle}
\newcommand{\imiseposter@box@boxshape@bars}{
  (\imiseposter@box@name tnw) -- (\imiseposter@box@name sw) %
  (\imiseposter@box@name se) -- (\imiseposter@box@name tne)
}
\newcommand{\imiseposter@box@boxshape@coils}{\imiseposter@box@boxshape@bars}
\newcommand{\imiseposter@box@boxshape@triangles}{\imiseposter@box@boxshape@bars}
\newcommand{\imiseposter@box@boxshape@rectangle}{
  (\imiseposter@box@name tnw) -- (\imiseposter@box@name sw) -- %
  (\imiseposter@box@name se) -- (\imiseposter@box@name tne)%
}
\newcommand{\imiseposter@box@boxshape@faded}{
  (\imiseposter@box@name tnw) -- (\imiseposter@box@name sw) %
  (\imiseposter@box@name tne) -- (\imiseposter@box@name se)
  }
\newcommand{\imiseposter@box@boxshape@rounded}{
  [rc] \imiseposter@box@boxshape@rectangle%
}
\newcommand{\imiseposter@box@boxshape@roundedsmall}{
  [src] \imiseposter@box@boxshape@rectangle
}
\newcommand{\imiseposter@box@boxshape@roundedleft}{
  (\imiseposter@box@name tnw) {[rc]-- (\imiseposter@box@name sw)} -- %
  (\imiseposter@box@name se) -- (\imiseposter@box@name tne)%
}
\newcommand{\imiseposter@box@boxshape@roundedright}{
  (\imiseposter@box@name tnw) -- (\imiseposter@box@name sw) {[rc]-- %
  (\imiseposter@box@name se)} -- (\imiseposter@box@name tne)%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Draw box background (one function for each possible value)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% These functions take no arguments
\newcommand{\imiseposter@box@drawbackground@none}[2]{
  \tikzstyle{box colors}=[]
}
\newcommand{\imiseposter@box@drawbackground@plain}[2]{
  \tikzstyle{box colors}=[fill=#1]
  \fill[box colors, opacity=\imiseposter@box@boxopacity] \imiseposterBoxGetShape;
}
\newcommand{\imiseposter@box@drawbackground@shadelr}[2]{
  \tikzstyle{box colors}=[shading=axis, left color=#1, right color=#2]%
  \fill[box colors] \imiseposterBoxGetShape;
}
\newcommand{\imiseposter@box@drawbackground@shadetb}[2]{
  \tikzstyle{box colors}=[shading=axis, top color=#1, bottom color=#2]%
  \fill[box colors] \imiseposterBoxGetShape;
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Draw box border
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% These functions take two arguments: borderColor
\newcommand{\imiseposter@box@drawborder@none}[1]{}
\newcommand{\imiseposter@box@drawborder@bars}[1]{
  \draw[color=#1] \imiseposterBoxGetShape;%
}
\newcommand{\imiseposter@box@drawborder@coils}[1]{
  \draw[color=#1,segment amplitude=0.35em,segment length=0.4em,snake=coil] \imiseposterBoxGetShape;%
}
\newcommand{\imiseposter@box@drawborder@triangles}[1]{
  \draw[color=#1,segment amplitude=0.2em,segment length=0.4em,snake=triangles] \imiseposterBoxGetShape;%
}
\newcommand{\imiseposter@box@drawborder@rectangle}[1]{
  \draw[color=#1] \imiseposterBoxGetShape;%
}
\newcommand{\imiseposter@box@drawborder@rounded}[1]{
  \draw[color=#1] \imiseposterBoxGetShape;%
}
\newcommand{\imiseposter@box@drawborder@roundedleft}[1]{
  \draw[color=#1] \imiseposterBoxGetShape;%
}
\newcommand{\imiseposter@box@drawborder@roundedright}[1]{
  \draw[color=#1] \imiseposterBoxGetShape;%
}
\newcommand{\imiseposter@box@drawborder@faded}[1]{
  % This is the right way to do it, but it does not work with evince, and has problems during printing, so instead we do
  %\draw[color=#1,path fading=south] \imiseposterBoxGetShape;%
  % this
 %\foreach \x in {0,1,...,90} { \draw[color=#1!\x] ($(\imiseposter@box@name tnw)!{(100-\x)/100}!(\imiseposter@box@name sw)$) -- ($(\imiseposter@box@name tnw)!{(100-(\x+10))/100}!(\imiseposter@box@name sw)$); }% 
 %\foreach \x in {0,1,...,90} { \draw[color=#1!\x] ($(\imiseposter@box@name tne)!{(100-\x)/100}!(\imiseposter@box@name se)$) -- ($(\imiseposter@box@name tne)!{(100-(\x+10))/100}!(\imiseposter@box@name se)$); }%
  \foreach \x in {0,1,...,99} { \draw[color=#1,opacity=\x/100] ($(\imiseposter@box@name tnw)!{(100-\x)/100}!(\imiseposter@box@name sw)$) -- ($(\imiseposter@box@name tnw)!{(100-(\x+1))/100}!(\imiseposter@box@name sw)$); }% 
  \foreach \x in {0,1,...,99} { \draw[color=#1,opacity=\x/100] ($(\imiseposter@box@name tne)!{(100-\x)/100}!(\imiseposter@box@name se)$) -- ($(\imiseposter@box@name tne)!{(100-(\x+1))/100}!(\imiseposter@box@name se)$); }%
}
\newcommand{\imiseposter@box@drawborder@roundedsmall}[1]{
  \draw[color=#1] \imiseposterBoxGetShape;%
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Return shape path of text box (depending on the box shape)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% These functions take no arguments
% TODO: For headerborder==none, use (\imiseposter@box@name outer tnw) instead!
\newcommand{\imiseposter@box@headershape@rectangle}{%
  (\imiseposter@box@name tnw) -- (\imiseposter@box@name nw) -- %
  (\imiseposter@box@name ne) -- (\imiseposter@box@name tne)%
}
\newcommand{\imiseposter@box@headershape@smallrounded}{%
  (\imiseposter@box@name tnw) {[src] -- (\imiseposter@box@name nw) -- %
  (\imiseposter@box@name ne)} -- (\imiseposter@box@name tne)%
}
\newcommand{\imiseposter@box@headershape@roundedright}{%
  (\imiseposter@box@name tnw) -- (\imiseposter@box@name nw) {[rc] -- %
  (\imiseposter@box@name ne)} -- (\imiseposter@box@name tne)%
}
\newcommand{\imiseposter@box@headershape@roundedleft}{%
  (\imiseposter@box@name tnw) {[rc]-- (\imiseposter@box@name nw)} -- %
  (\imiseposter@box@name ne) -- (\imiseposter@box@name tne)%
}
\newcommand{\imiseposter@box@headershape@rounded}{%
  (\imiseposter@box@name tnw) {[rc] -- (\imiseposter@box@name nw) -- %
  (\imiseposter@box@name ne) } -- (\imiseposter@box@name tne)%
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Header text drawing (one function for each possible value of headershape)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% These functions take one argument: the header text
\newcommand{\imiseposter@box@headerdrawtext@rectangle}[1]{
  \path (\imiseposter@box@name nw) +(0em,-0.5\imiseposter@box@@boxheaderheight) node[anchor=west,inner sep=0.4em] {#1};%
}
\newcommand{\imiseposter@box@headerdrawtext@smallrounded}[1]{
  \path (\imiseposter@box@name nw) +(0.5\boxwidth,-0.5\imiseposter@box@@boxheaderheight) node[anchor=center] {#1};%
}
\newcommand{\imiseposter@box@headerdrawtext@roundedright}[1]{
  \path (\imiseposter@box@name nw) +(0em,-0.5\imiseposter@box@@boxheaderheight)%
        node[anchor=west,inner sep=0.4em,text depth=0.0em] {#1};%
}
\newcommand{\imiseposter@box@headerdrawtext@roundedleft}[1]{
  \path (\imiseposter@box@name nw) +(0em,-0.5\imiseposter@box@@boxheaderheight)%
        node[anchor=west,inner sep=0.4em] {#1};%
}
\newcommand{\imiseposter@box@headerdrawtext@rounded}[1]{
    \path (\imiseposter@box@name nw) +(0.5\boxwidth,-0.5\imiseposter@box@@boxheaderheight) node[anchor=center] {#1};%
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Header shade options and functions (one function for each possible value)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% These functions take two arguments: headerColorOne, headerColorTwo and borderColor
\newcommand{\imiseposter@box@headershade@shadelr}[3]{
    \debug{Header-Shade: Shade Left - Right}
    \tikzstyle{header colors}=[%
      color=#3,%
      shading=axis,%
      left color=#1,%
      right color=#2%
    ]%
}
\newcommand{\imiseposter@box@headershade@shadetb}[3]{
    \debug{Header-Shade: Shade Top - Bottom}
    \tikzstyle{header colors}=[%
      color=#3,%
      shading=axis,%
      top color=#1,%
      bottom color=#2%
    ]%
}
\newcommand{\imiseposter@box@headershade@shadetbinverse}[3]{
    \tikzstyle{header colors}=[%
      top color=#1!75!#2,%
      bottom color=#2!100!#1,%
      shading angle=20%
    ]%
    \colorlet{imiseposterHeaderFontColor}{white}%
}
\newcommand{\imiseposter@box@headershade@plain}[3]{
    \debug{Header-Shade: Plain}
    \tikzstyle{header colors}=[%
      color=#3,%
      fill=#1%
    ]%
}
\newcommand{\imiseposter@box@headershade@none}[3]{
    \debug{Header-Shade: none}
    \tikzstyle{header colors}=[]
}




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% The main poster environment
%%% \begin{imiseposter}{settings}{Eye Catcher}{Title}{Author}{University Logo}
%%%-----------------------------------------------------------------------------
%%% The settings are
%%%   - grid=true,[false]:Show grid to help with alignment
%%%   - colspacing=0.7em: Column spacing
%%%   - columns=4:        number of columns (default 4 in landscape and 3 in portrait format) (maximum number is 6)
%%%   - color=[orange]:   xcolor color definition used as the main color of the poster
%%%   - colortwo=[white]: The other color for gradient based layouts
%%%   - textborder=none,bars,coils,triangles,rectangle,rounded,roundedsmall,roundedleft,roundedright,[faded]
%%%                       The style of the box around the text area
%%%   - headerborder=none,closed,open
%%%                       No extra border around box header, full border around box header or border that is open below.
%%%   - headershape=rectangle,rounded,roundedleft,roundedright
%%%                       Shape of the box-header region
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newenvironment{poster}[5]{%
  \thispagestyle{empty}% Suppress Page Number
  \debug{Poster Starts}%
  % This setkeys call parses all provided options and depending on the option
  % value, assigns different handler functions to the \imiseposter(Box|Header)*
  % functions. Once that is done, we don't have to care about particular
  % values for border, shading, etc. All we have to do is call the
  % handler functions and let them do their job.
  % This also allows the user to override the poster-wide defaults on a per-box
  % basis.
  \setkeys[ba]{posterbox,poster}{#1}%
%
  % TODO: Move all those assignments to the key macros!
  % Parse Keys%
  \colorlet{bgColorOne}{\imiseposter@bgColorOne}
  \colorlet{bgColorTwo}{\imiseposter@bgColorTwo}
%
  %% Boxes%
  \setlength{\headerheight}{\imiseposter@headerheight}%
  \setlength{\colheight}{\textheight-\imiseposter@headerheight}%
  \renewcommand{\@@previousbox}{notset}

  \debug{Format}%
  % Set default for columns if unset (4 for landscape, 3 for portrait)
  \ifthenelse{\equal{\imiseposter@columns}{}}{%
    \if@landscape
      \renewcommand{\imiseposter@columns}{4}
    \else
      \renewcommand{\imiseposter@columns}{3}
    \fi
    %
  }{}
%
  \debug{Columns: \imiseposter@columns}%
  \setlength{\imiseposter@@colspacing}{\imiseposter@colspacing}%
  \setlength{\colwidth}{\textwidth}%
  \addtolength{\colwidth}{\imiseposter@@colspacing*(1-\imiseposter@columns)}%
  \ifcase\imiseposter@columns\relax
    \error{You need to have at least one column!}
  \or % 1
    \setlength{\colwidth}{\colwidth}%
  \or % 2
    \setlength{\colwidth}{0.5\colwidth}%
  \or % 3
    \setlength{\colwidth}{0.3333333333333\colwidth}%
  \or % 4
    \setlength{\colwidth}{0.25\colwidth}%
  \or % 5
    \setlength{\colwidth}{0.2\colwidth}%
  \or % 6
    \setlength{\colwidth}{0.16666666666\colwidth}%
  \else % >6
    \error{You do not want so many columns}
  \fi
%
  \newcommand{\imiseposter@reference}{north west}%
%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % A box with a header and some content. The basic unit of the poster%
  %---------------------------------------------------------------------------%
  % Each box has a name and can be placed absolutely or relatively.%
  % The only inconvenience is that you can only specify a relative position %
  % towards an already declared box. So if you have a box attached to the %
  % bottom, one to the top and a third one which should be inbetween, you %
  % have to specify the top and bottom boxes before you specify the middle %
  % box.%
  %%
  % below=  name of other node%
  % above=  name of other node%
  % aligned=name of other node%
  % bottomaligned=name of other node%
  % column= [0]     %
  % row=    [0]     %
  % span=   [1]     %
  % height= <size in percent of column height>,[auto]%
  % name=   [noname]%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % Backward-compatibility definition (\headerbox command uses posterbox env):
  \newcommand{\headerbox}[3]{%
    \begin{posterbox}[##2]{##1}
      ##3
    \end{posterbox}
  }

  \newenvironment{posterbox}[2][]{%
    \debug{Poster box options: ##1}%
    % Override the poster-wide defaults on a per-box basis
    \setkeys[ba]{posterbox}{##1}%
%
    \def\imiseposter@box@title{##2}
%
    \colorlet{borderColor}{\imiseposter@box@borderColor}
    \colorlet{headerColorOne}{\imiseposter@box@headerColorOne}
    \colorlet{headerColorTwo}{\imiseposter@box@headerColorTwo}
    \colorlet{headerFontColor}{\imiseposter@box@headerFontColor}
    \colorlet{boxColorOne}{\imiseposter@box@boxColorOne}
    \colorlet{boxColorTwo}{\imiseposter@box@boxColorTwo}
%
    \setlength{\imiseposter@box@@cornerradius}{\imiseposter@box@cornerradius}%
    \ifthenelse{\equal{\imiseposter@box@title}{}}{% No header
    \setlength{\imiseposter@box@@boxheaderheight}{0pt}%
    }{ % With header
    \setlength{\imiseposter@box@@boxheaderheight}{\imiseposter@box@boxheaderheight}%
    }%
    \setlength{\imiseposter@box@@boxpadding}{\imiseposter@box@boxpadding}%


    %% The columns is always given absolute
    % boxstartx = column * colwidth + column * colspacing
    \setlength{\boxstartx}{(\colwidth+\imiseposter@@colspacing)*\imiseposter@box@column}%
%
    %% The width is gvien absolute
    % Box Width = span * colwidth + (span-1) * colspacing
    \setlength{\boxwidth}{\imiseposter@box@span\colwidth} %
    \addtolength{\boxwidth}{\imiseposter@@colspacing*(\imiseposter@box@span-1)}%
%
    %% Measure the content of the box%
    \setbox\imiseposter@box@content=\hbox\bgroup%
      \begin{pgfinterruptpicture}%
        \begin{minipage}[t]{\boxwidth-\imiseposter@box@@boxpadding*2}%
          \imiseposter@box@textfont\bgroup%
  }% End of posterbox preamble
  %%% HERE COME THE ACTUAL CONTENTS OF THE HEADERBOX ENVIRONMENT
  {% posterbox handling after contents (i.e. drawing everything)
          \egroup%
        \end{minipage}%
      \end{pgfinterruptpicture}%
    \egroup%
    \setlength{\boxheight}{\ht\imiseposter@box@content}%
    \addtolength{\boxheight}{\dp\imiseposter@box@content}%
    \addtolength{\boxheight}{\imiseposter@box@@boxheaderheight} % Header%
    \addtolength{\boxheight}{2\imiseposter@box@@boxpadding} % Inner Sep
%
    \ifthenelse{\equal{\imiseposter@box@height}{bottom}}{%
    }{\ifthenelse{\equal{\imiseposter@box@height}{auto}}{%
    }{ % Neither auto nor bottom%
      \setlength{\boxheight}{\imiseposter@box@height\colheight}%
    }}%
%
    %% Determine the box position%
    \debug{Setting Coordinates}%
    \debug{Upper Right}%
    \debug{\imiseposter@box@name}%
%
    %%% Upper Right Corner%
    % if below=auto, set it to the previous box
    % TODO: We should generalize this to the previous box of the used column,
    %       currently we use the previous box, which might be in a different column
    \ifthenelse{\equal{\imiseposter@box@below}{auto}}{%
        \edef\imiseposter@box@below{\@@previousbox}
        \debug{Box \imiseposter@box@name  has below=auto, placing it below box \imiseposter@box@below.}
    }{}
    \xdef\@@previousbox{\imiseposter@box@name}

    \ifthenelse{\not\equal{\imiseposter@box@below}{notset} }{%
      %% Below%
      \debug{Below}%
      \path[shape=coordinate] (\boxstartx,0pt |- \imiseposter@box@below se) ++(0pt,-\imiseposter@@colspacing) coordinate(\imiseposter@box@name nw);%
    }{%
      \ifthenelse{\not\equal{\imiseposter@box@aligned}{notset} }{%
        %% Aligned%
        \debug{Aligned: \imiseposter@box@aligned}%
        \path[shape=coordinate] (\boxstartx,0pt |- \imiseposter@box@aligned nw)                           coordinate(\imiseposter@box@name nw);%
      }{%
        %% Fixed%
        \debug{Fixed}%
        \setlength{\boxstarty}{\imiseposter@box@row\colheight}%
        \path[shape=coordinate] (\boxstartx,\colheight-\boxstarty)                                                  coordinate(\imiseposter@box@name nw);%
    }}%
%
    %% Lower Left Corner%
    \debug{Lower Left}%
    \ifthenelse{\equal{\imiseposter@box@above}{bottom}}{%
      %% Above = Bottom%
      \debug{Above bottom}%
      \ifthenelse{\equal{\imiseposter@box@below}{notset} \and \equal{\imiseposter@box@aligned}{notset}}{%
      \path[shape=coordinate] (\boxstartx,\boxheight)                                                              coordinate(\imiseposter@box@name nw);%
      }{}%
      \path[shape=coordinate] (\boxstartx+\boxwidth,0pt)                                                           coordinate(\imiseposter@box@name se);%
      }{\ifthenelse{\not \equal{\imiseposter@box@bottomaligned}{notset}}{%
        \path[shape=coordinate] (\boxstartx+\boxwidth,0pt |- \imiseposter@box@bottomaligned se)                       coordinate(\imiseposter@box@name se);%
      }{{\ifthenelse{\not \equal{\imiseposter@box@above}{notset}}{%
        %% Above = Node%
        \path[shape=coordinate] (\boxstartx+\boxwidth,0pt |- \imiseposter@box@above nw)  +(0pt,\imiseposter@@colspacing) coordinate(\imiseposter@box@name se);%
      }{%
        %% Above = notset%
        \debug{Above=not set}%
        \ifthenelse{\equal{\imiseposter@box@height}{bottom}}{%
          %% height=bottom%
          \debug{height=bottom}%
          \path[shape=coordinate] (\boxstartx+\boxwidth,0pt)                                                       coordinate(\imiseposter@box@name se);%
        }{ %% height=auto or fixed%
          \debug{height=auto or fixed}%
          \path[shape=coordinate] (\imiseposter@box@name nw) ++(\boxwidth,-\boxheight)                                coordinate(\imiseposter@box@name se);%
	  }}}}}%
%
        %
    % Set coordinates relative to nw,se%
    \debug{Fixing Coordinates}%
    \path[shape=coordinate]%
      (\imiseposter@box@name nw) +(0pt,-\imiseposter@box@@boxheaderheight)                coordinate(\imiseposter@box@name tnw)%
      (\imiseposter@box@name nw |- \imiseposter@box@name se)   coordinate(\imiseposter@box@name sw)%
      (\imiseposter@box@name se |- \imiseposter@box@name nw)   coordinate(\imiseposter@box@name ne)%
      (\imiseposter@box@name ne) +(0pt,-\imiseposter@box@@boxheaderheight)                coordinate(\imiseposter@box@name tne)%
%
      (\imiseposter@box@name nw)  +(-0.025em,0pt)           coordinate(\imiseposter@box@name outer nw)%
      (\imiseposter@box@name tnw) +(-0.025em,0pt)           coordinate(\imiseposter@box@name outer tnw)%
      (\imiseposter@box@name sw)  +(-0.025em,0pt)           coordinate(\imiseposter@box@name outer sw)%
%
      (\imiseposter@box@name ne)  +( 0.025em,0pt)           coordinate(\imiseposter@box@name outer ne)%
      (\imiseposter@box@name tne) +( 0.025em,0pt)           coordinate(\imiseposter@box@name outer tne)%
      (\imiseposter@box@name se)  +( 0.025em,0pt)           coordinate(\imiseposter@box@name outer se);%
%
      %% Setting the bg colors of the box header
      \imiseposterHeaderSetShade{headerColorOne}{headerColorTwo}{borderColor}
%
      \tikzstyle{rc}=[rounded corners=\imiseposter@box@@cornerradius];%
      \tikzstyle{src}=[rounded corners=0.5em];%
%

    %% Now that everything is set up, draw the actual box, with bg and header
    \begin{scope}[line width=\imiseposter@box@linewidth]
      %% Header%
      \debug{Header}%
      \debug{Header-Shape: \imiseposter@box@headershape, header-border: \imiseposter@box@headerborder (\imiseposter@box@headerbordernr)}%
      % TODO: Also turn this last ifcase construct into a handler function
      %       We only need to determine (fill|shade)(draw|)...
%       \imiseposterHeaderDrawBackground{bgColorOne}{bgColorTwo}{borderColor}
%       \imiseposterHeaderDrawBorder{borderColor}
    \ifthenelse{\equal{\imiseposter@box@title}{}}{% No header
    }{% With header
      \ifcase\imiseposter@box@headerbordernr\relax%
        % open
        \ifthenelse{\equal{\imiseposter@box@headershade}{plain}}{
          \filldraw  [style=header colors, opacity=\imiseposter@box@boxopacity] \imiseposterHeaderGetShape;%
        }{
          \shadedraw [style=header colors] \imiseposterHeaderGetShape;%
        }
      \or
        % closed
        \ifthenelse{\equal{\imiseposter@box@headershade}{plain}}{
          \filldraw  [style=header colors, opacity=\imiseposter@box@boxopacity] \imiseposterHeaderGetShape -- cycle;%
        }{
          \shadedraw [style=header colors] \imiseposterHeaderGetShape -- cycle;%
        }
      \or
        % none
        \ifthenelse{\equal{\imiseposter@box@headershade}{plain}}{
          \fill      [style=header colors, opacity=\imiseposter@box@boxopacity] \imiseposterHeaderGetShape;%
        }{
          \shade     [style=header colors] \imiseposterHeaderGetShape;%
        }
      \fi
      %
      %% Draw the text inside the box header:
      \imiseposterHeaderDrawText{\color{headerFontColor}\imiseposter@box@headerfont{\imiseposter@box@title}};%
    }
      %
      %% Text borders (border around boxes)
      \debug{Poster boxes}%
      % First set box shade
      \imiseposterBoxDrawBackground{boxColorOne}{boxColorTwo}
      \imiseposterBoxDrawBorder{borderColor}
      %%
      %% Text Box%
      \debug{Drawing Text}%
      \path (\imiseposter@box@name tnw) node(text) [anchor=north west,
            outer sep=-0.000em,text width=\boxwidth-2\imiseposter@box@@boxpadding,inner sep=\imiseposter@box@@boxpadding,
            text justified] {\usebox{\imiseposter@box@content}};%
    \end{scope}
    %
    % Finally store the box name as the previous box for the next call
%     \xdef\@@previousbox{\imiseposter@box@name}%
  }% END of posterbox definition
%
  %% Poster Background%
  \imiseposterPosterDrawBackground{bgColorOne}{bgColorTwo}%
  %% Poster header/title
  \hspace{-1.5em}%
  \begin{tikzpicture}[inner sep=0pt,outer sep=0pt,line width=0.05em]%
    \useasboundingbox (0em,0em) rectangle(\textwidth,\textheight);%
    \path[shape=coordinate]%
      (0pt,\colheight) coordinate(north west) (\textwidth,\colheight) coordinate(north east)%
      (0pt,0pt) coordinate(south west)        (\textwidth,0pt) coordinate(south east);%
%
    \ifimiseposter@eyecatcher% Has eye catcher
      \debug{Eyecatcher found!}
      \setbox\imiseposter@titleimage@left=\hbox{#2}%
    \else% Has no eye catcher%
      \setbox\imiseposter@titleimage@left=\hbox{}%
    \fi%
    \setlength{\imiseposter@titleimage@left@width}{\wd\imiseposter@titleimage@left}%
    \setbox\imiseposter@titleimage@right=\hbox{#5}%
    \setlength{\imiseposter@titleimage@right@width}{\wd\imiseposter@titleimage@right}%
    \setlength{\imiseposter@titleimage@textwidth}{\textwidth}%
    \addtolength{\imiseposter@titleimage@textwidth}{-\imiseposter@titleimage@left@width}%
    \addtolength{\imiseposter@titleimage@textwidth}{-\imiseposter@titleimage@right@width}%

    \debug{#3}
    %
    %
    %      % Draw Header%
    \draw (north west) +(0em,1em+0.5\headerheight) node(image)[anchor=west]   { {\usebox{\imiseposter@titleimage@left }} };%
    \draw (north east) +(0em,1em+0.5\headerheight) node(logo) [anchor=east]   { {\usebox{\imiseposter@titleimage@right}} };%
    %
    \ifimiseposter@eyecatcher% Has eye catcher%
      \draw (image.east) node(title)[anchor=west,text width=\imiseposter@titleimage@textwidth]{%
        \begin{minipage}{\imiseposter@titleimage@textwidth}%
          \begin{center}%
          \textbf{\textcolor{mediblue}{\Huge#3}}\\%
          {\Large \textcolor{medigray}{#4}}%
          \end{center}%
        \end{minipage}
      };%
    \else% Has no eye catcher
      \draw (image.east) node(title)[anchor=west]  { {\begin{minipage}{\imiseposter@titleimage@textwidth}{\bfseries\huge #3}\\{\large #4}\end{minipage}} };%
    \fi
  }% END poster begin
% The body
  {% BEGIN poster end
    % The end, draw gridlines if neccesary
    \ifimiseposter@grid
      \newdimen{\gridpos}
      \typeout{\imiseposter@columns-1}
      \pgfmathsetmacro{\z}{\imiseposter@columns-1}
     \foreach \y in {0,...,\z}
     {
       \setlength{\gridpos}{\y\colwidth+\y\imiseposter@@colspacing}
       \draw[draw=green,draw opacity=0.7] (\gridpos,0pt)  -- (\gridpos,\colheight)
           (\gridpos+\colwidth,0pt)  -- (\gridpos+\colwidth,\colheight);%
     }
     % Horizontal lines, every 0.1:
     %% Explicitly list all percentages, because with {0.0, 0.1, ..., 1.0} we
     %% get rounding errors in the displayed numbers!
     \foreach \y in {0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0}
       \draw[draw=green,draw opacity=0.7] (0pt,\colheight-\y\colheight)  --
           (\textwidth,\colheight-\y\colheight) node[anchor=west] {\y};%
    \fi%
  \end{tikzpicture}%
 % \xkvview{}
 \par
  }% END poster end
