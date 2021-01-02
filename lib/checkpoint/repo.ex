defmodule Checkpoint.Repo do
  use Ecto.Repo,
    otp_app: :checkpoint,
    adapter: Ecto.Adapters.MyXQL
end
