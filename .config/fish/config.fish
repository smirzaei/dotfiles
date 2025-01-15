if status is-interactive
    # Commands to run in interactive sessions can go here

    # PATH Set up

    set PATH $PATH $HOME/.local/bin/

    # Go is installed or not
    if type -q go
        # Is $GOPATH set
        if set gopath (go env GOPATH)
            if test -n "$gopath"
                set PATH $PATH $gopath/bin
            end
        end
    end

    if test -d $HOME/.cargo/bin
        set PATH $PATH $HOME/.cargo/bin/
    end

    if test -d $HOME/.krew
        set KREW_ROOT $HOME/.krew/
        set PATH $PATH $HOME/.krew/bin/
    end
end

starship init fish | source
