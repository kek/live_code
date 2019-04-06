defmodule LiveCode.LibraryTest do
  use ExUnit.Case
  doctest LiveCode.Library

  setup do
    {:ok, memory} = LiveCode.Memory.start_link()
    Process.put(:memory, memory)
    :ok
  end

  test "setting variable to function" do
    assert run("(set x 1)") == "ok"
    assert run("(get x)") == 1
    assert run("(set get-x (proc [get x]))") == "ok"
    assert run("(apply (get get-x))") == 1
  end

  def run(code) do
    Symbelix.run(code, LiveCode.Library)
  end
end
