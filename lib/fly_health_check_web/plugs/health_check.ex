defmodule FlyHealthCheckWeb.Plugs.HealthCheck do
  @behaviour Plug

  require Logger
  import Plug.Conn

  alias FlyHealthCheck.Startup

  @impl true
  def init(opts), do: opts

  @impl true
  def call(%Plug.Conn{request_path: "/api/health_check"} = conn, _opts) do
    status =
      with :ok <- check_database(),
           :ok <- Startup.status() do
        Logger.info("Healthcheck passed")
        :ok
      else
        {:error, reason} ->
          Logger.error("Healthcheck failed: #{inspect(reason)}", %{error: inspect(reason)})
          :error
      end

    case status do
      :ok -> send_resp(conn, 200, "ok")
      :error -> send_resp(conn, 503, "error")
    end
    |> halt()
  end

  def call(conn, _opts), do: conn

  defp check_database do
    case FlyHealthCheck.Repo.query("SELECT 1") do
      {:ok, _} -> :ok
      error -> error
    end
  end
end
