# Functions

function i
    hostname -I | cut -d " " -f 1
end

function ll
    ls -alah $argv
end

function fuck
    git update-index --assume-unchanged $argv
end

function unfuck
    git update-index --no-assume-unchanged $argv
end

function what-did-i-do
    git log --name-status HEAD^..HEAD
end

# Fish-related

function fish_greeting
    printf 'Wellcome %s%s@%s%s\n\n' (set_color normal) $USER (i) (set_color normal)
    fortune
    echo
end

function fish_prompt -d "Write out the prompt"
    set laststatus $status
    printf '\n%s%s%s' (set_color blue) (prompt_pwd) (set_color normal)
    if test -d .git
        printf '\n%s%s%s ' (set_color green) (git rev-parse --symbolic-full-name @{upstream} | cut -d "/" -f 3,4 2> /dev/null) (set_color normal)
    end
    printf '\n%s%s%s' (set_color magenta) (date +"%T") (set_color normal)
    if test $laststatus -eq 0
        printf '\n%s--%s' (set_color green) (set_color normal)
    else if test $laststatus -eq 127
        if test $taskfoundok -eq 1
            printf '\n%s--%s' (set_color blue) (set_color normal)
        else
            printf '\n%s?-%s' (set_color red) (set_color normal)
        end
    else
        printf '\n%sx-%s' (set_color red) (set_color normal)
    end
    printf '%s>%s ' (set_color normal) (set_color normal)
end

function fish_right_prompt
    set laststatus $status
    if test $laststatus -eq 0
        printf '%s+%s' (set_color green) (set_color normal)
    else if test $laststatus -eq 127
        if test $taskfoundok -eq 1
            printf '%stask+%s' (set_color blue) (set_color normal)
        else
            printf '%s?%s' (set_color red) (set_color normal)
        end
    else
        printf '%s%s%s' (set_color red) $laststatus (set_color normal)
    end
end

function bind_bang
    switch (commandline -t)
        case "!"
            commandline -t -- $history[1]
            commandline -f repaint
        case "*"
            commandline -i !
    end
end

function bind_dollar
    switch (commandline -t)
        case "*!"
            commandline -f backward-delete-char history-token-search-backward
        case "*"
            commandline -i '$'
    end
end

function fish_user_key_bindings
    bind ! bind_bang
    bind '$' bind_dollar
end

function __fish_default_command_not_found_handler
    if begin task $argv
        end
        set -U taskfoundok 1
    else
        set -U taskfoundok 0
        printf '%sCommand %s is not found; task %s either%s\n' (set_color red) $argv[1] $argv[1] (set_color normal)
    end
end


# Functions

function summon -d "Get file from master branch"
    git checkout origin/master -- $argv
    echo $argv >>.git/info/exclude
    git rm --cached $argv
end

function summontask -d "Get Taskfile from master branch"
    summon Taskfile.yml
    echo .task >>.git/info/exclude
end

set -Ux GOBIN /home/gitpod/go/data/bin
set -Ux GOPATH /home/gitpod/go/data
set -Ux GOROOT /home/gitpod/go/current

set -U fish_user_paths $GOBIN $fish_user_paths
