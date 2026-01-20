#!/bin/bash

#====================================================================#
# ALIAS DEFINITIONS                                                  #
#====================================================================#

if [ -f $HOME/.bash_aliases ]; then
    source $HOME/.bash_aliases
fi

export PATH="$PATH:/$HOME/.local/bin"

#====================================================================#
# STARSHIP                                                           #
#====================================================================#

export STARSHIP_LOG=error
eval "$(starship init bash)"

#====================================================================#
# NVM                                                                #
#====================================================================#

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#====================================================================#
# OTHER CONFIG                                                       #
#====================================================================#

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# EOF
