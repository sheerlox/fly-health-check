defmodule FlyHealthCheckWeb.Plugs.SlowRequest do
  @behaviour Plug

  require Logger
  import Plug.Conn

  alias FlyHealthCheck.Startup

  @impl true
  def init(opts), do: opts

  @impl true
  def call(%Plug.Conn{request_path: "/api/request"} = conn, _opts) do
    :timer.sleep(50)

    case Startup.status() do
      :ok ->
        send_resp(conn, 200, "ok")

      _ ->
        Logger.error("Request before health checks are passing")
        send_resp(conn, 500, "error")
    end
    |> halt()
  end

  def call(conn, _opts), do: conn
end
