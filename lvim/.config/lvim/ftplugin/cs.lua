local util = require 'lspconfig.util'
local csharpls_extended = require('csharpls_extended')
local utils = require("csharpls_extended.utils")

function printTable(t)
  if t == nil then
    print("nil")
    return
  end
  for key, value in pairs(t) do
    if (type(value) == 'table') then
      print(key)
      printTable(value)
    else
      print(key, value)
    end
  end
end

function mergePaths(path1, path2)
  local separator = "/"

  -- Extract the file path from the second path (assuming it's an absolute file path)
  local filePath = string.match(path2, "file:///(.*)")

  if filePath then
    -- Extract the common part between the end of path2 and the beginning of path1
    local commonPart = string.match(path1, "^csharp:/([^/]+)")

    -- Combine the file path and the common part
    local resultPath = "/" .. commonPart .. separator .. filePath
    return resultPath
  else
    return nil     -- Return nil if the second path format is not as expected
  end
end

local buf_from_metadata = function(result, client_id, file_name)
  local normalized = string.gsub(result.source, "\r\n", "\n")
  -- print("normalized", normalized)

  local source_lines = utils.split(normalized, "\n")

  -- normalize backwards slash to forwards slash
  local normalized_source_name = string.gsub(result.assemblyName, "\\", "/")
  print("normalized_source_name", normalized_source_name)
  -- local file_name = "/" .. normalized_source_name

  -- this will be /$metadata$/...
  local bufnr = utils.get_or_create_buf(file_name)
  -- TODO: check if bufnr == 0 -> error
  vim.api.nvim_buf_set_option(bufnr, "modifiable", true)
  vim.api.nvim_buf_set_option(bufnr, "readonly", false)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, source_lines)
  vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
  vim.api.nvim_buf_set_option(bufnr, "readonly", true)
  vim.api.nvim_buf_set_option(bufnr, "filetype", "cs")
  vim.api.nvim_buf_set_option(bufnr, "modified", false)

  -- attach lsp client ??
  vim.lsp.buf_attach_client(bufnr, client_id)

  -- vim.api.nvim_win_set_buf(0, bufnr)

  -- set_cursor is (1, 0) indexed, where LSP range is 0 indexed, so add 1 to line number
  -- vim.api.nvim_win_set_cursor(0, { range.start.line+1, range.start.character })
  --
  return bufnr, file_name
end

local get_metadata = function(locations, sourceUri)
  local client = csharpls_extended.get_csharpls_client()
  if not client then
    -- TODO: Error?
    return false
  end

  local fetched = {}
  for _, loc in pairs(locations) do
    -- url, get the message from csharp_ls
    local uri = utils.urldecode(loc.uri)
    --print(uri)
    --if has get messages
    local is_meta, _, _, _ = csharpls_extended.parse_meta_uri(uri)
    --print(is_meta,project,assembly,symbol)
    if is_meta then
      --print(uri)
      local params = {
        timeout = 5000,
        textDocument = {
          uri = uri,
        },
      }
      --print("ssss")
      -- request_sync?
      -- if async, need to trigger when all are finished
      local result, err = client.request_sync("csharp/metadata", params, 10000)
      --print(result.result.source)
      if not err then
        -- print("result.result")
        -- printTable(result.result)
        -- local filename = vim.fn.fnamemodify(loc.uri, ":t")
        print("loc.uri", loc.uri)
        print("sourceUri", sourceUri)
        local mergedPath = mergePaths(loc.uri, sourceUri)
        print("mergedPath", mergedPath)
        local bufnr, name = buf_from_metadata(result.result, client.id, mergedPath)
        print("name", name)
        -- change location name to the one returned from metadata
        -- alternative is to open buffer under location uri
        -- not sure which one is better
        -- print("filename", filename)
        loc.uri = "file://" .. mergedPath
        fetched[loc.uri] = {
          bufnr = bufnr,
          range = loc.range,
        }
      end
    end
  end

  return fetched
end

local handle_locations = function(locations, sourceUri, offset_encoding)
  local fetched = get_metadata(locations, sourceUri)
  print("fetched")
  printTable(fetched)

  if not vim.tbl_isempty(fetched) then
    if #locations > 1 then
      utils.set_qflist_locations(locations, offset_encoding)
      vim.api.nvim_command("copen")
      return true
    else
      -- utils.jump_to_location(locations[1], fetched[locations[1].uri].bufnr)
      vim.lsp.util.jump_to_location(locations[1], offset_encoding)
      return true
    end
  else
    return false
  end
end


local config = {
  handlers = {
    ["textDocument/definition"] = function(err, result, ctx, config)
      print("====================")

      print(err, config)
      print("result")
      printTable(result)
      print("++++++++++++++++++++")
      print("ctx")
      printTable(ctx)

      local offset_encoding = vim.lsp.get_client_by_id(ctx.client_id).offset_encoding
      local locations = csharpls_extended.textdocument_definition_to_locations(result)
      print("--------------------")
      printTable(locations)
      print("--------------------")
      print(ctx.params.textDocument.uri)
      local handled = handle_locations(locations, ctx.params.textDocument.uri, offset_encoding)
      print("handled", handled)

      -- printTable(locations[1])
      print("====================")
      if not handled then
        return vim.lsp.handlers["textDocument/definition"](err, result, ctx, config)
      end
      -- return locations[1]
      -- print(err, result, ctx, config)
      -- return require('csharpls_extended').handler(err, result, ctx, config)
    end,
  },
  cmd = { 'csharp-ls' },
  root_dir = function(startpath)
    local patterns = vim.tbl_flatten { '*.sln', '*.csproj', '*.fsproj', '.git' }
    startpath = util.strip_archive_subpath(startpath)
    for _, pattern in ipairs(patterns) do
      local match = util.search_ancestors(startpath, function(path)
        for _, p in ipairs(vim.fn.glob(util.path.join(util.path.escape_wildcards(path), pattern), true, true)) do
          if util.path.exists(p) then
            return path
          end
        end
      end)

      if match ~= nil then
        return match
      end
    end
  end,
  filetypes = { 'cs' },
  init_options = {
    AutomaticWorkspaceInit = true,
  },
}

require('lvim.lsp.manager').setup("csharp_ls", config)
