defmodule WebhookBucketWeb.Router do
  use WebhookBucketWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {WebhookBucketWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/hook", WebhookBucketWeb do
    pipe_through :api

    post "/:slug", WebhookController, :create
  end

  scope "/", WebhookBucketWeb do
    pipe_through :browser

    get "/", PageController, :home
    post "/create", PageController, :create_bucket
    live "/bucket/:slug", BucketLive
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:webhook_bucket, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: WebhookBucketWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
