defmodule LiveCode.Memory do
  def start_link do
    Agent.start_link(fn -> %{} end)
  end

  def set(pid, key, value) do
    # IO.puts("setting #{inspect(key)} to #{inspect(value)}")
    Agent.update(pid, fn state -> Map.put(state, key, value) end)
  end

  def get(pid, key) do
    # IO.puts("getting #{inspect(key)}")
    Agent.get(pid, fn state -> Map.get(state, key) end)
  end
end
