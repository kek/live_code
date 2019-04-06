defmodule LiveCode.Library do
  use Symbelix.Library
  require Logger

  def add(a, b), do: a + b

  def if(condition, if_true, if_false) do
    if condition, do: if_true, else: if_false
  end

  def eq(left, right), do: left == right

  def map(list, function) do
    list
    |> Enum.map(fn item ->
      __MODULE__.apply(function, item)
    end)
  end

  def identity(x), do: x

  def test, do: "test"

  def apply([function]) when is_function(function) do
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

  def lambda(code) do
    fn ->
      apply(code)
    end
  end
end
