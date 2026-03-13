defmodule Cauldron.Repo do
  use Ecto.Repo,
    otp_app: :cauldron,
    adapter: Ecto.Adapters.Postgres
end
