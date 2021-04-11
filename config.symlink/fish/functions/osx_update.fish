#!/usr/bin/env fish
function osx_update

    echo 'start updating ...'

    echo 'updating homebrew'
    brew update
    brew upgrade
    brew cleanup

    echo 'updating fish shell'
    fish_update_completions

    echo 'updating npm'
    npm update -g

    echo 'checking Apple Updates'
    /usr/sbin/softwareupdate -ia

    exit 0
end
