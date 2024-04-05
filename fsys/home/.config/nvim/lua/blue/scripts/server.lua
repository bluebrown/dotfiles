local s = vim.uv.new_tcp()

s:bind("127.0.0.1", 8080)
vim.notify("server socket bound to 127.0.0.1:8080")

s:listen(128, function(err)
  vim.notify("new client connection ")

  assert(not err, err)

  local c = vim.uv.new_tcp()
  s:accept(c)

  c:read_start(function(err, chunk)
    assert(not err, err)
    if chunk then
      c:write(chunk)
    else
      c:close()
    end
  end)
end)

print("TCP echo-server listening on port: " .. s:getsockname().port)

vim.loop.run()

s:shutdown(function(err)
  vim.notify("server shutting down")
  assert(not err, err)
  s:close()
end)
