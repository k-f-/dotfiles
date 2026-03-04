# Decrypt and source GPG-encrypted secrets into the shell environment
#
# Secrets file: ~/.secrets-env.gpg (stowed from dotfiles/secrets/)
# Edit with:    secrets-edit
#
# GPG agent caches the passphrase (see gpg-agent.conf for TTL settings),
# so this only prompts on first shell after reboot or cache expiry.

_secrets_file="$HOME/.secrets-env.gpg"
_op_env_tpl="$HOME/.config/1password/env.tpl"

_op_bin=""
if [ -f "$_op_env_tpl" ]; then
    _op_bin="$(type -P op 2>/dev/null || true)"
fi

if [ -n "$_op_bin" ]; then
    if _op_env_data="$($_op_bin inject -i "$_op_env_tpl" 2>/dev/null)"; then
        if [ -n "$_op_env_data" ]; then
            eval "$_op_env_data"
            _secrets_loaded=true
        fi
    fi
    unset _op_env_data
fi

if [ -z "${_secrets_loaded:-}" ] && [ -f "$_secrets_file" ]; then
    if _secrets_data="$(gpg -q --for-your-eyes-only --no-tty -d "$_secrets_file" 2>/dev/null)"; then
        if [ -n "$_secrets_data" ]; then
            eval "$_secrets_data"
        fi
    fi
    unset _secrets_data
fi

unset _secrets_file _op_env_tpl _op_bin _secrets_loaded
