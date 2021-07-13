# 
# Functions
# 

function i
    hostname -I | cut -d " " -f 1
end

function ll
    ls -alah
end

function fuck
    git update-index --assume-unchanged
end

function unfuck
    git update-index --no-assume-unchanged
end

#
# Fish-related
#

function fish_greeting
end

function fish_prompt -d "Write out the prompt"
    set laststatus $status
    printf '%s%s@%s%s ' (set_color green) $USER (i) (set_color normal)
    printf '%s%s%s ' (set_color blue) (prompt_pwd) (set_color normal)
    if test -d .git
        printf '%s %s%s ' (set_color magenta) (git rev-parse --symbolic-full-name @{upstream} | cut -d "/" -f 3,4 2> /dev/null) (set_color normal)
    end
    printf '%s%s%s\n' (set_color normal) (date +"%T") (set_color normal)
    if test $laststatus -eq 0
        printf '%s%s%s ' (set_color blue)  (set_color normal)
    else
        printf '%s%s%s ' (set_color red)  (set_color normal)
    end
    printf '%s%s%s ' (set_color normal)  (set_color normal)
end
