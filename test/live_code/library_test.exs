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
    assert run("(set get-x (proc get x))") == "ok"
    assert run("(apply (get get-x))") == 1
  end

  test "incrementing function stored in a variable" do
    assert run("(set inc-x (proc set x (add 1 (get x))))") == "ok"
    assert run("(set x 0)") == "ok"
    assert run("(apply (get inc-x))")
    assert run("(get x)") == 1
  end

  test "running a list of expressions" do
    assert run("(progn [1 2 3])") == 3

    code = """
    (progn [(set x 1) (get x)])
    """

    assert run(code) == 1

    # run("(set inc-x (proc set x (add 1 (apply (proc get x)))))")

    # code = """
    # (progn [(set x 0) (apply (get inc-x)) (get x)])
    # """

    # assert run(code) == 1
  end

  def run(code) do
    Symbelix.run(code, LiveCode.Library)
  end
end
