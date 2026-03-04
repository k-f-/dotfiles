_op_plugins="$HOME/.config/op/plugins.sh"

if [ -f "$_op_plugins" ]; then
  source "$_op_plugins"
fi

unset _op_plugins
