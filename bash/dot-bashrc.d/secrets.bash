# Decrypt and source GPG-encrypted secrets into the shell environment
#
# Secrets file: ~/.secrets-env.gpg (stowed from dotfiles/secrets/)
# Edit with:    secrets-edit
#
# GPG agent caches the passphrase (see gpg-agent.conf for TTL settings),
# so this only prompts on first shell after reboot or cache expiry.

_secrets_file="$HOME/.secrets-env.gpg"

if [ -f "$_secrets_file" ]; then
    # Decrypt to stdout and source — never writes plaintext to disk
    _secrets_data="$(gpg -q --for-your-eyes-only --no-tty -d "$_secrets_file" 2>/dev/null)"
    if [ $? -eq 0 ] && [ -n "$_secrets_data" ]; then
        eval "$_secrets_data"
    fi
    unset _secrets_data
fi

unset _secrets_file
