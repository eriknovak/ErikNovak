#!/bin/bash

#============================
# COLOR DEFINITIONS
#============================

CODE_RED='204'
CODE_DARK_RED='196'
CODE_GREEN='40'
CODE_DARK_GREEN='59'
CODE_DARKEST_GREEN='23'
CODE_YELLOW='118'
CODE_DARK_YELLOW='3'
CODE_BLUE='33'
CODE_BLUE_ALT='62'
CODE_PURPLE='170'
CODE_PURPLE_ALT='176'
CODE_CYAN='36'
CODE_CYAN_ALT='73'
CODE_WHITE='252'
CODE_BLACK='235'
CODE_COMMENT_GRAY='59'
CODE_GUTTER_FG_GRAY='249'
CODE_CURSOR_GRAY='236'
CODE_VISUAL_GRAY='237'
CODE_SPECIAL_GRAY='238'
CODE_VERT_SPLIT='59'

# set colors
COLOR_RED='38;5;'$CODE_RED
COLOR_DARK_RED='38;5;'$CODE_DARK_RED
COLOR_GREEN='38;5;'$CODE_GREEN
COLOR_DARK_GREEN='38;5;'$CODE_DARK_GREEN
COLOR_DARKEST_GREEN='38;5;'$CODE_DARKEST_GREEN
COLOR_YELLOW='38;5;'$CODE_YELLOW
COLOR_DARK_YELLOW='38;5;'$CODE_DARK_YELLOW
COLOR_BLUE='38;5;'$CODE_BLUE
COLOR_BLUE_ALT='38;5;'$CODE_BLUE_ALT
COLOR_PURPLE='38;5;'$CODE_PURPLE
COLOR_PURPLE_ALT='38;5;'$CODE_PURPLE_ALT
COLOR_CYAN='38;5;'$CODE_CYAN
COLOR_CYAN_ALT='38;5;'$CODE_CYAN_ALT
COLOR_WHITE='38;5;'$CODE_WHITE
COLOR_BLACK='38;5;'$CODE_BLACK
COLOR_COMMENT_GRAY='38;5;'$CODE_COMMENT_GRAY
COLOR_GUTTER_FG_GRAY='38;5;'$CODE_GUTTER_FG_GRAY
COLOR_CURSOR_GRAY='38;5;'$CODE_CURSOR_GRAY
COLOR_VISUAL_GRAY='38;5;'$CODE_VISUAL_GRAY
COLOR_SPECIAL_GRAY='38;5;'$CODE_SPECIAL_GRAY
COLOR_VERT_SPLIT='38;5;'$CODE_VERT_SPLIT

EFFECT_BOLD=1

# no    NORMAL, NORM    Global default, although everything should be something
# fi    FILE    Normal file
# di    DIR Directory
# ln    SYMLINK, LINK, LNK  Symbolic link. If you set this to ‘target’ instead of a numerical value, the color is as for the file pointed to.
# pi    FIFO, PIPE  Named pipe
# do    DOOR    Door
# bd    BLOCK, BLK  Block device
# cd    CHAR, CHR   Character device
# or    ORPHAN  Symbolic link pointing to a non-existent file
# so    SOCK    Socket
# su    SETUID  File that is setuid (u+s)
# sg    SETGID  File that is setgid (g+s)
# tw    STICKY_OTHER_WRITABLE   Directory that is sticky and other-writable (+t,o+w)
# ow    OTHER_WRITABLE  Directory that is other-writable (o+w) and not sticky
# st    STICKY  Directory with the sticky bit set (+t) and not other-writable
# ex    EXEC    Executable file (i.e. has ‘x’ set in permissions)
# mi    MISSING Non-existent file pointed to by a symbolic link (visible when you type ls -l)
# lc    LEFTCODE, LEFT  Opening terminal code
# rc    RIGHTCODE, RIGHT    Closing terminal code
# ec    ENDCODE, END    Non-filename text
# *.extension       Every file using this # extension e.g. *.jpg


#============================
# LS COLORS
#============================

# directories
COLOR_DIR=$COLOR_BLUE';'$EFFECT_BOLD
COLOR_OTHER_WRITABLE=$COLOR_GREEN';'$EFFECT_BOLD
# links
COLOR_LINK=$COLOR_CYAN
COLOR_ORPHAN=$COLOR_RED
COLOR_MISSING=$COLOR_DARK_RED
# permissions
COLOR_EXECUTABLE=$COLOR_GREEN
#file types
COLOR_CHAR_DEVIDE=$COLOR_PURPLE
COLOR_SOCKET=$COLOR_PURPLE
COLOR_BLOCK_DEVICE=$COLOR_YELLOW

export LS_COLORS='di='$COLOR_DIR':ln='$COLOR_LINK':or='$COLOR_ORPHAN':mi='$COLOR_MISSING':ex='$COLOR_EXECUTABLE':ow='$COLOR_OTHER_WRITABLE':cd='$COLOR_CHAR_DEVICE':bd='$COLOR_BLOCK_DEVICE':so='$COLOR_SOCKET


#============================
# PS CONFIG
#============================

COLOR_USER_PS1=$COLOR_DARK_YELLOW';'$EFFECT_BOLD
COLOR_DIR_PS1=$COLOR_GREEN';'$EFFECT_BOLD
COLOR_ACTION_PS1=$COLOR_DARK_GREEN';'$EFFECT_BOLD

COLOR_GIT_OK=$COLOR_BLUE_ALT';'$EFFECT_BOLD
COLOR_GIT_ERROR=$COLOR_DARK_RED';'$EFFECT_BOLD

COLOR_GIT_CHANGED=$COLOR_YELLOW
COLOR_GIT_STAGED=$COLOR_GREEN
COLOR_GIT_UNTRACKED=$COLOR_BLUE
#==============
# PS1 CONFIG

# git branch and status creator
git_branch_and_status() {
    
    # get current branch
    GIT_BRANCH=$(git branch 2> /dev/null | sed -n "s/* \(.*\)/\1/p")

    if [[ $GIT_BRANCH ]]; then
        
        # check if there are any conflicts in the branch
        NUM_FILES_CONFLICT=$(git ls-files --unmerged | wc -l)

        if [[ $NUM_FILES_CONFLICT != 0 ]]; then
            
            # notify user about the conflicts
            echo -e '\e['$COLOR_GIT_ERROR'm('$GIT_BRANCH' \xe2\x9c\x98'$NUM_FILES_CONFLICT')'

        else
               
            # get the number of staged files - used to show number files prepared to commit
            NUM_FILES_STAGED=$(git diff --cached --numstat | wc -l)
            # get the number of changed files since last commit
            NUM_FILES_CHANGED=$(git diff-index HEAD | wc -l)
            # remove the number of staged files
            NUM_FILES_CHANGED="$(($NUM_FILES_CHANGED-$NUM_FILES_STAGED))"
            # get the number of untracked files - what should be tracked
            NUM_FILES_UNTRACKED=$(git ls-files "$(git rev-parse --show-toplevel)" --others --exclude-standard | wc -l)
        
            # status container    
            STATUS=''        
       
            if [[ $NUM_FILES_CHANGED != 0 ]]; then
                # add number of changed files
                STATUS+='\e['$COLOR_GIT_CHANGED'm\xE2\x97\x8F'$NUM_FILES_CHANGED
            fi

            if [[ $NUM_FILES_STAGED != 0 ]]; then
                # add number of staged files 
                if [[ $STATUS != '' ]]; then 
                    STATUS+=' ' 
                fi
                STATUS+='\e['$COLOR_GIT_STAGED'm\xE2\x86\x91'$NUM_FILES_STAGED
            fi
            
            if [[ $NUM_FILES_UNTRACKED != 0 ]]; then
                # add number of untracked files
                if [[ $STATUS != '' ]]; then 
                    STATUS+=' ' 
                fi
                STATUS+='\e['$COLOR_GIT_UNTRACKED'm\xE2\x86\x93'$NUM_FILES_UNTRACKED
            fi
        
            # construct the git branch status message 
            GIT_STATUS='\e['$COLOR_GIT_OK'mgit['$GIT_BRANCH']'

            if [[ $STATUS != '' ]]; then
                GIT_STATUS+=' '$STATUS
            fi

            # notify user about the status of the branch
            echo -e $GIT_STATUS
        
        fi
    fi
}

# user@host working-directory
PS1='\[\e['$COLOR_USER_PS1'm\]\u@\h \[\e['$COLOR_DIR_PS1'm\]\w '

# git branch and status info
PS1+='$(git_branch_and_status)'

# end-of-line
PS1+='\n\[\e['$COLOR_ACTION_PS1'm\]'$'\xE2\x80\xBA'' \[\e[00m\]'

# export PS1 
export PS1


#==============
# PS2 CONFIG
#==============

# multi-line prompt
export PS2='... '


#============================
# ALIAS DEFINITIONS
#============================

if [ -f $HOME/.bash_aliases ]; then
    source $HOME/.bash_aliases
fi
