defmodule LiveCode.Config.Secret do
  def make(length),
    do: :crypto.strong_rand_bytes(length) |> Base.encode64() |> binary_part(0, length)
end

alias LiveCode.Config.Secret

use Mix.Config

config :live_code, LiveCodeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: Secret.make(64),
  render_errors: [view: LiveCodeWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: LiveCode.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: Secret.make(32)
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
