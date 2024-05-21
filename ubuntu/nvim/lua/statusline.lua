vim.g.lightline = {
  active = {
    left = {{'mode', 'paste'}, {'cocstatus', 'currentfunction', 'readonly', 'absolutepath', 'modified'}}
  },
  component_function = {
    cocstatus = 'coc#status',
  }
}
