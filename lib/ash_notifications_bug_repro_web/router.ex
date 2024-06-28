defmodule AshNotificationsBugReproWeb.Router do
  use AshNotificationsBugReproWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", AshNotificationsBugReproWeb do
    pipe_through :api
  end
end
