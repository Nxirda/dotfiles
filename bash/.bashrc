#
# ~/.bashrc
#
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -f /etc/bash_completion ]; then
   . /etc/bash_completion
fi

fastfetch
# Settings exports, this is mainly for tmux/vim to correctly show colors
export TERM=xterm-256color

# Set vi mode for shell command editing
set -o vi

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Ask to confirm before overwriting something
alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'

# Convenience aliases
alias lock='hyprlock'
alias off='poweroff'
alias shutdown='poweroff'
alias yeet="rm -Rf"
alias vi='vim'
alias open='xdg-open'

### ARCHIVE EXTRACTION
# usage: ex file
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   unzstd $1    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

screen ()
{
    if [ $# -ne 1 ]; then
        echo "Usage : screen <filename>"
        return 1;
    fi
    name="$1"
    filepath="$HOME/images/${name}.png"
    grim -g "$(slurp)" "$filepath" && wl-copy < "$filepath"
    echo "Saved screenshot to $filepath and copied to clipboard"
}

# Docker shortcut for EVE :
dockhere()
{
  docker run -i -t -v${PWD}:${PWD} ghcr.io/jfalcou/compilers:v10
}

################################################################################
#                                                                              #
#       PS1 options and coloring for the sake of it                            #
#                                                                              #
################################################################################

# Nerd font patched glyphs for pretty purpose
right_circle=$'\ue0b4'
left_circle=$'\ue0b6'

right_trianle=$'\ue0b0'
left_triangle=$'\ue0b2'

low_right_slant=$'\ue0ba'
high_right_slant=$'\ue0be'
low_left_slant=$'\ue0b8'
high_left_slant=$'\ue0bc'

triangle=$'\ue0b0'

# Unicode box parts via escape codes
top_left=$'\u256D'      # ╭
top_right=$'\u256E'     # ╮
bottom_left=$'\u2570'   # ╰
bottom_right=$'\u256F'  # ╯
horizontal=$'\u2500'    # ─
vertical=$'\u2502'      # │

# Show current branch when working in git
git_branch() 
{
    if git rev-parse --is-inside-work-directory &> /dev/null; then 
        local branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/')
        echo "$branch"
    fi
}

color()
{   
    local foreground="$1"
    local background="$2"
    if [[ $background -eq -1 ]]; then
        echo "\[\033[1;38;5;${foreground}m\]"
    else
        echo "\[\033[1;38;5;${foreground};48;5;${background}m\]"
    fi
}

reset_color()
{
    echo '\[\033[00m\]'
}

segment() 
{ 
    local text="$1"
    local curr_fg="$2"
    local curr_bg="$3"
    local prev_bg="$4"
 
    prompt=""
    if [[ $prev_bg -gt 0 ]]; then
        prompt+="$(color $prev_bg $curr_bg)$triangle$(reset_color)"
    fi
    prompt+="$(color $curr_fg $curr_bg)$text$(reset_color)" 
    echo $prompt
}

exit_code()
{
    if [[ $LAST_EXIT -eq 0 ]]; then
        echo '$!'
    else
        echo '$?'
    fi
}

# Colors matching your screenshot (adjust as needed)
color_machine_bg=211        # blueish
color_git_bg=220            # yellowish
color_final_bg=33           # default / transparent
color_machine_fg=15         # white
color_fg=0

LAST_EXIT=0
build_prompt(){
    LAST_EXIT=$?
    local start="$top_left$horizontal"
    local end="$bottom_left$horizontal"

    local begin=$(segment $left_circle $color_machine_bg -1 0)
    local seg_machine=$(segment $'[\h \W] ' $color_fg $color_machine_bg)

    local seg_git=""
    local prev_bg=$color_machine_bg

    local git_text=$(git_branch)
    if [[ -n "$git_text" ]]; then
        local seg_git=$(segment " $git_text " $color_fg $color_git_bg $color_machine_bg)
        prev_bg=$color_git_bg
    fi

    local seg_exit=$(segment ' $(exit_code) ' $color_fg $color_final_bg $prev_bg)
    local seg_final=$(segment '' 15 $color_final_fg -1 $color_final_bg)

    local seg_time=$(segment 'date +%H:%M:%S)' $color_machine_bg -1 0)

    local PS1L="$start$begin$seg_machine$seg_git$seg_exit$seg_final" 
    local PS1R="$seg_time\n"

    PS1="$PS1L\n$end $ "
}

PROMPT_COMMAND=build_prompt

PS2='$(git_branch)\[\033[1m\][\h \W]\$\[\033[00m\] '

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
