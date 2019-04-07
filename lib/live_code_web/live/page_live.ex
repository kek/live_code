defmodule LiveCodeWeb.PageLive do
  use Phoenix.LiveView
  alias LiveCode.{Library, Memory}

  def render(assigns) do
    LiveCodeWeb.PageView.render("page.html", assigns)
  end

  def mount(_, socket) do
    # if connected?(socket), do: :timer.send_interval(100, self(), :update)
    {:ok, memory} = Memory.start_link()
    Process.put(:memory, memory)
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
