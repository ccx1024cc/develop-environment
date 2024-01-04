vim.g.lightline = {
  active = {
    left = {{'mode', 'paste'}, {'cocstatus', 'currentfunction', 'readonly', 'filename', 'modified'}}
  },
  component_function = {
    cocstatus = 'coc#status',
  }
}
