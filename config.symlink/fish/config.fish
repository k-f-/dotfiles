set -g -x PATH /usr/local/bin $PATH
set -g -x fish_greeting ''

fish_default_key_bindings
 
# If we're in interactive mode
if status --is-interactive
	if test -e ~/.secrets
		source ~/.secrets	# Secrets
	end
end

set -x EDITOR 'nvim'			# NeoVim
