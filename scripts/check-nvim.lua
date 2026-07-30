local expected_keymaps = {
  ["<leader>gB"] = "Git Branches",
  ["<leader>go"] = "Git Browse",
}

for lhs, expected_description in pairs(expected_keymaps) do
  local keymap = vim.fn.maparg(lhs, "n", false, true)
  assert(keymap.desc == expected_description, ("%s should map to %s"):format(lhs, expected_description))
end
