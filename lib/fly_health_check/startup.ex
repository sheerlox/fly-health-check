defmodule FlyHealthCheck.Startup do
  use GenServer
  require Logger

  @persistent_term_key {__MODULE__, :is_ready}

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def status do
    case :persistent_term.get(@persistent_term_key, false) do
      true -> :ok
      _ -> {:error, :not_ready}
    end
  end

  @impl true
  def init(_) do
    Logger.info("Startup process started")
    {:ok, nil, 5000}
  end

  @impl true
  def handle_info(:timeout, state) do
    Logger.info("Startup process completed")
    :persistent_term.put(@persistent_term_key, true)
    {:noreply, state}
  end
end
