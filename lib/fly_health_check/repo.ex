defmodule FlyHealthCheck.Repo do
  use Ecto.Repo,
    otp_app: :fly_health_check,
    adapter: Ecto.Adapters.Postgres
end
