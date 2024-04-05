local s = vim.uv.new_tcp()

s:bind("127.0.0.1", 8080)

s:listen(128, function(err)
  assert(not err, err) -- Check for errors.

  local c = vim.uv.new_tcp()
  s:accept(c) -- Accept client connection.

  c:read_start(function(err, chunk)
    assert(not err, err) -- Check for errors.
    if chunk then
      c:write(chunk) -- Echo received messages to the channel.
    else -- EOF (stream closed).
      c:close() -- Always close handles to avoid leaks.
    end
  end)
end)

print("TCP echo-server listening on port: " .. s:getsockname().port)

vim.loop.run()
