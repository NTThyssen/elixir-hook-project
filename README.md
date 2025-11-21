# Elixir Hook Project

## Webhook Bucket

This project contains a Phoenix application for inspecting and debugging webhooks.

### Prerequisites

*   [Elixir](https://elixir-lang.org/install.html) (tested with 1.14)
*   [Erlang](https://www.erlang.org/downloads) (tested with OTP 25)
*   [PostgreSQL](https://www.postgresql.org/download/)

### Running Locally

1.  Navigate to the project directory:
    ```bash
    cd webhook_bucket
    ```

2.  Install dependencies and setup the database:
    ```bash
    mix setup
    ```

3.  Start the Phoenix server:
    ```bash
    mix phx.server
    ```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
