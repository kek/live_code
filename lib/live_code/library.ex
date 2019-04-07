defmodule LiveCode.Library do
  use Symbelix.Library
  require Logger
  alias LiveCode.Memory

  def add(a, b), do: a + b

  def if(condition, if_true, if_false) do
    if condition, do: if_true, else: if_false
  end

  def eq(left, right), do: left == right

  def map(list, function) do
    list
    |> Enum.map(fn item ->
      __MODULE__.apply([function, item])
    end)
  end

  def identity(x), do: x

  def test, do: "test"

  @doc """
  iex> "(set foo 1)" |> Symbelix.run(LiveCode.Library)
  "ok"
  iex> "(get foo)" |> Symbelix.run(LiveCode.Library)
  1
  """
  def set(name, value) do
    :ok = Process.get(:memory) |> Memory.set(name, value)
    "ok"
  end

  def get(name) do
    Process.get(:memory) |> Memory.get(name)
  end
end
