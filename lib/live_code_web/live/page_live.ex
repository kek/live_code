defmodule LiveCodeWeb.PageLive do
  use Phoenix.LiveView
  alias LiveCode.Library

  def render(assigns) do
    ~L"""
    <h1>Type code here! 🤖</h1>

    <p>
    <form name="program" phx-change="evaluate">
      <textarea name="code"></textarea>
    </form>
    </p>
    <h2>See it compute!</h2>
    <p>
    <pre><code><%= @result %></code></pre>
    </p>

    <h2>Try the functions!</h2>
    <p><%= inspect LiveCode.Library.__info__(:functions) |> Keyword.drop([:generate_ast]) %></p>

    <h2>Try the examples!</h2>
    <pre><code>(add 1 2)
    </code></pre>

    <pre><code>(if (eq (add 2 2) 5)
        "true is false"
        "false is false")
    </code></pre>

    <h2>Remember your parenthesises!</h2>
    """
  end

  def mount(_, socket) do
    # if connected?(socket), do: :timer.send_interval(100, self(), :update)
    {:ok, assign(socket, :result, "READY")}
  end

  def handle_info(:update, socket) do
    {:noreply, assign(socket, :result, "READY")}
  end

  def handle_event("evaluate", %{"code" => code}, socket) do
    {:noreply, assign(socket, :result, evaluate(code))}
  end

  defp evaluate("") do
    "READY"
  end

  defp evaluate(code) do
    code =
      code
      |> String.replace("”", "\"")
      |> String.replace("’", "'")

    try do
      inspect(Symbelix.run(code, Library))
    rescue
      e ->
        inspect(e)
    end
  end
end
