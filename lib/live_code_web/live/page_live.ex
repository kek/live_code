defmodule LiveCodeWeb.PageLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    Result: <%= @result %>
    """
  end

  def mount(_, socket) do
    if connected?(socket), do: :timer.send_interval(100, self(), :update)
    {:ok, assign(socket, :result, DateTime.utc_now())}
  end

  def handle_info(:update, socket) do
    {:noreply, assign(socket, :result, DateTime.utc_now())}
  end
end
