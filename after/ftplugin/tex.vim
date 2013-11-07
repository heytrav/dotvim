" *** On met des zolies couleurs ***"

syntax on


" Si il s'agit d'un fichier tex on appelle la procédure FT_tex()

au FileType tex call FT_tex()

" note : ctags fonctionne avec CTRL-] et CTRL-T "
" note : le mode visual v sélectionne des caractères "
" note : le mode visual V sélectionne des lignes "
" note : le mode visual CTRL-v sélectionne des blocs "
" CTRL-N et CTRL-P servent à la complétion de noms

" Fenetres :

" CTRL-W s ou :split ==> sépare la fenetre en deux parties
" :split fichier ==> split et édite le fichier dans l'une des deux parties
" :sf fichier ==> idem mais en relatif (path)
" CTRL-W ] ==> crée une nouvelle fenetre qui contient le tag
" CTRL-W f ==> crée une nouvelle fenetre qui contient le fichier sous le curseur
" CTRL-W n ==> crée une nouvelle fenetre vide
" CTRL-W q ==> ferme la fenetre courante
" CTRL-W j ==> passe à la fenetre du dessous
" CTRL-W k ==> passe à la fenetre du dessus
" CTRL-W p ==> swap entre le fenetres
" CTRL-W x ==> echange la fenetre courante avec la suivante
" CTRL-W = ==> toutes les fenetres ont la meme taille
" CTRL-W - ==> diminue la taille de la fenetre courante
" CTRL-W + ==> augmente la taille de la fenetre courante
" CTRL-W _ ==> agrandit la fenetre

" autorise les menus en mode texte

source $VIMRUNTIME/menu.vim
set wildmenu
set cpo-=<
set wcm=<C-Z>
map <F9> :emenu <C-Z>
" autorise le menu popup avec la souris
set mousemodel=popup

" mets la completion en menu
set wildmenu

" fonctions rusées pour vim
" Luc Hermitte hermitte@laas.fr
" vnoremap _b s\textbf{}<ESC>P
" vnoremap _b s{\em }<ESC>P
" vnoremap _ls <ESC>I"\item \"<ESC>S\begin{itemize}<CR>\end{itemize}<ESC>P
" noremap <F3> :!xdvi %<.dvi <CR>
" :s/.*/\="\\\\item ".submatch(0)/

" *** Fonctions générales ******************************************************
***************************** "

function MakeList (text1, text2, text3) range
        exe (a:firstline) . "," . a:lastline . 's/^/' . a:text3
        if (strlen(a:text1) > 0)
                exe append (a:firstline -1 ,a:text1)
        endif
        if (strlen(a:text2) > 0)
                exe append (a:lastline +1, a:text2)
        endif
endfunction

function MakeTab () range

        let pos = 0
        let nb_colonnes = 0
        let ret = 0

        " pour vim >= 6, cette macro devrait marcher pour déterminer
        " automatiquement le nombre de colonnes du tableau :
        " let ret = match(getline(a:firstline),'\t',pos)
        " while (ret != -1)
        "       let pos = ret + 1
        "       let ret = match(getline(a:firstline),'\t',pos)
        "       let nb_colonnes = nb_colonnes + 1
        " endwhile
        " let nb_colonnes = nb_colonnes + 1

        " sinon, on demande le nombre à l'utilisateur :
        let nb_colonnes = input ("Entrez le nombre de colonnes du tableau : ")

        let pos = 0
        let options = "{|"
        while (pos < nb_colonnes)
                let options = options . "c"
                let pos = pos + 1
        endwhile
        let options = options . "|}"

        "let sep = confirm ("Séparation :","&Contour\n&Aucune\nA Chaque &Ligne")
        let sep = 1

        let text1 = "\\begin{tabular}" . options
        let text2 = "\\end{tabular}"
        if (sep == 3)
                exe (a:firstline) . "," . a:lastline . 's/$/\\\\\\hline'
        else
                exe (a:firstline) . "," . a:lastline . 's/$/\\\\'
        endif
        exe (a:firstline) . "," . a:lastline . 's/\t\+/ \& /g'
        if ((sep == 1) || (sep == 3))
                exe append (a:firstline -1 ,"\\hline")
                exe append (a:firstline +1 ,"\\hline")
                exe append (a:firstline -1 ,text1)
                if (sep == 1)
                        exe append (a:lastline +3 ,"\\hline")
                        exe append (a:lastline +4, text2)
                else
                        exe append (a:lastline +3, text2)
                endif
        else
                exe append (a:firstline -1 ,text1)
                exe append (a:lastline +1, text2)
        endif
endfunction

function RemoveComments () range
        exe (a:firstline) . "," . a:lastline . 's/^% /'
endfunction

function FT_tex()

        "syn region myFold start="\begin {document}" end="\end {document}" trans
parent fold
        "syn sync fromstart
        "setlocal foldmethod=marker

        " on redéfinit le mode quickfix de vim pour gérer du latex
        " les commandes utiles sont :
        " cc pour afficher l'erreur
        " cn pour afficher l'erreur suivante
        " cp pour afficher l'erreur precedente
        " cl pour afficher la liste des erreurs
        set makeprg=latex\ \\\\nonstopmode\ \\\\input\\{$*}
        set efm=%E!\ LaTeX\ %trror:\ %m,
                \%E!\ %m,
                \%+WLaTeX\ %.%#Warning:\ %.%#line\ %l%.%#,
                \%+W%.%#\ at\ lines\ %l--%*\\d,
                \%WLaTeX\ %.%#Warning:\ %m,
                \%Cl.%l\ %m,
                \%+C\ \ %m.,
                \%+C%.%#-%.%#,
                \%+C%.%#[]%.%#,
                \%+C[]%.%#,
                \%+C%.%#%[{}\\]%.%#,
                \%+C<%.%#>%.%#,
                \%C\ \ %m,
                \%-GSee\ the\ LaTeX%m,
                \%-GType\ \ H\ <return>%m,
                \%-G\ ...%.%#,
                \%-G%.%#\ (C)\ %.%#,
                \%-G(see\ the\ transcript%.%#),
                \%-G%*\\s,
                \%+O(%f)%r,
                \%+P(%f%r,
                \%+P\ %\\=(%f%r,
                \%+P%*[^()](%f%r,
                \%+P[%\\d%[^()]%#(%f%r,
                \%+Q)%r,
                \%+Q%*[^()])%r,
                \%+Q[%\\d%*[^()])%r

        " *** Si on est en mode graphique, on modifie les icones de la toolbar *
** "

        if has ("gui_running")

                " on enleve la toolbar par défaut, et on mets la notre

                unmenu ToolBar
                unmenu! ToolBar

                " toolbar

                amenu 1.10 ToolBar.Open :browse e<CR>
                tmenu ToolBar.Open              Open file
                amenu 1.20 ToolBar.Save :w<CR>
                tmenu ToolBar.Save              Save current file
                amenu 1.30 ToolBar.SaveAll      :wa<CR>
                tmenu ToolBar.SaveAll           Save all files
                amenu 1.40 ToolBar.Undo u
                tmenu ToolBar.Undo              Undo
                amenu 1.50 ToolBar.Redo <C-R>
                tmenu ToolBar.Redo              Redo
                amenu 1.60 ToolBar.Make :make % <CR>
                amenu 1.70 ToolBar.View :!xdvi %<.dvi <CR>
                amenu 1.80 ToolBar.Print :!dvips %<.dvi <CR>
                amenu 1.90 ToolBar.Xfig :!xfig <CR>

                vmenu 1.100 ToolBar.Bold s\textbf{}<Esc>P
                tmenu ToolBar.Bold      Bold Text
                vmenu 1.100 ToolBar.Italic s\textit{}<Esc>P
                tmenu ToolBar.Italic    Italic
                vmenu 1.100 ToolBar.SmallCaps s\textsc{}<Esc>P
                tmenu ToolBar.SmallCaps         SmallCaps
                vmenu 1.100 ToolBar.Part s\part{}<Esc>P
                tmenu ToolBar.Part      Parts
                vmenu 1.100 ToolBar.Chapter s\chapter{}<Esc>P
                tmenu ToolBar.Chapter   Chapters
                vmenu 1.100 ToolBar.Section s\section{}<Esc>P
                vmenu 1.100 ToolBar.SubSection s\subsection{}<Esc>P
                vmenu 1.100 ToolBar.SubSubSection s\subsubsection{}<Esc>P
                vmenu 1.180 ToolBar.Left S\begin{center}<CR>\end{center}<ESC>P
                vmenu 1.180 ToolBar.Center S\begin{flushleft}<CR>\end{flushleft}
<ESC>P
                vmenu 1.180 ToolBar.Right S\begin{right}<CR>\end{right}<ESC>P
                vmenu 1.180 ToolBar.Tabular :call MakeTab() <CR>

        endif

        " *** on rajoute quelques mapping de touches *** "

        map <F2> :make %<CR>
        map <F3> :!xdvi %<.dvi<CR>
        map <F4> :!dvips %<.dvi<CR>
        map <F5> :!xfig<CR>
        map <F6> :!aspell --mode=tex check % <CR> :e!<CR>
        map <F7> :!gaspell --mode=tex %<CR> :e!<CR>
        map <F10> :echo "Fonctions : <F2> make <F3> voir <F4> imprimer <F5> xfig
 <F6> aspell <F7> gaspell" <CR>
        "map <F10> :call Folding() <CR>
        "setlocal foldmethod=expr
        "setlocal foldexpr=LatexFoldLevel(v:lnum)
        "setlocal foldcolumn=4

        " *** raccourcis non visuels *** "

        "nmap _b !!encapsule "\textbf{" "}" <CR>
        "nmap _i !!encapsule "\textit{" "}" <CR>
        "nmap _sc !!encapsule "\textsc{" "}" <CR>
        "nmap _pa !!encapsule "\part{" "}" <CR>
        "nmap _ch !!encapsule "\chapter{" "}" <CR>
        "nmap _se !!encapsule "\section{" "}" <CR>
        "nmap _s2 !!encapsule "\subsection{" "}" <CR>
        "nmap _s3 !!encapsule "\subsubsection{" "}" <CR>
        "nmap _t !!encapsule "\item " "" <CR>
        "nmap _mc !!encapsule "\% " "" <CR>
        "nmap _ls !!encapsule "\begin{itemize} " "\end{itemize}" -n<CR>
        "nmap _le !!encapsule "\begin{enumerate} " "\end{enumerate}" -n<CR>
        "nmap _vr !!encapsule "\vref{" "}" <CR>

        " *** raccourcis visuels *** "


        " on n'utilise _que_ des raccourcis visuels, car on ne modifiera que ce
que l'on
        " aura clairement sélectionné. c'est comme ça et pi c'est tout, na.
        " (nan mais c'est vrai aussi, quoi.)

        " bref. Donc on a d'abord des modification de style de texte :
        " gras, italique, petites majuscules, souligné, à l'indice, à l'exposant
.

        vn _b s\textbf{}<ESC>P          " gras
        vn _i s\textit{}<ESC>P          " italique
        vn _sc s\textsc{}<ESC>P         " petites majuscules

        " on a ensuite des modifications 'visuelles' :

        vn _pc S\begin{center}<CR>\end{center}<ESC>P            " On centre le t
exte
        vn _pl S\begin{flushleft}<CR>\end{flushleft}<ESC>P      " On aligne le t
exte à gauche
        vn _pr S\begin{right}<CR>\end{right}<ESC>P              " On aligne le t
exte à droite
        vn _pv S\begin{verbatim}<CR>\end{verbatim}<ESC>P        " On mets le tex
te en mode verbatim
        vn _fg S\begin{figure}[h]<CR>\end{figure}<ESC>P         " hmpf. une figu
re.

        " voici ensuite les modifications 'structurelles'
        " partie, chapitre, section, subsection, subsubsection

        vn _pa s\part{}<ESC>P           " partie
        vn _ch s\chapter{}<ESC>P        " chapitre
        vn _se s\section{}<ESC>P        " section
        vn _s2 s\subsection{}<ESC>P     " sous-section
        vn _s3 s\subsubsection{}<ESC>P  " sous-sous-section

        " puis les modifications de 'navigation' :
        " notes de pied de page, références.

        vn _ft s\footnote{}<ESC>P       " note de bas de page
        vn _lb s\label{}<ESC>P          " on définit un label
        vn _rf s\ref{}<ESC>P            " on affiche une référence
        vn _vr s\vref{}<ESC>P           " on affiche une vréférence

        " Nous voici aux listes...

        vn _pt :call MakeList("","", "\\\\item ") <CR>  " rajoute des \item deva
nt chaque ligne
        vn _mc :call MakeList("","", "\% ") <CR>        " rajoute des % devant c
haque ligne
        vn _xc :call RemoveComments() <CR>              " enlève des % devant ch
aque ligne

        " là on définit une liste complète
        " avec des tirets ...
        vn _ls :call MakeList("\\begin{itemize}","\\end{itemize}", "\\\\item ")
<ESC> :'>+2 <CR>
        " ... et par énumération
        vn _le :call MakeList("\\begin{enumerate}","\\end{enumerate}", "\\\\item
 ") <ESC> :'>+2 <CR>

        " Enfin, on finit par le plat de résistance, un tableau :

        vn _mt :call MakeTab() <CR>

endfunction
