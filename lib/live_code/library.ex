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
  iex> "(apply [identity 1])" |> Symbelix.run(LiveCode.Library)
  1
  iex> "(apply [apply [identity 1]])" |> Symbelix.run(LiveCode.Library)
  1
  """
  def apply([function]) when is_function(function) do
    function.()
  end

  def apply(function) when is_function(function) do
    function.()
  end

  def apply([function | args]) when is_function(function) do
    function.(args)
  end

  def apply([function | args]) when is_list(function) do
    {:ok, ast} = generate_ast([function | args])
    {result, _binding} = Code.eval_quoted(ast)
    result
  end

  def proc(code) do
    fn ->
      __MODULE__.apply(code)
    end
  end

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
