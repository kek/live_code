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
      {:ok, ast} = generate_ast([function, item])
      Logger.info(inspect(ast))
      {result, _binding} = Code.eval_quoted(ast)
      result
    end)
  end

  def identity(x), do: x

  def test, do: "test"
end
