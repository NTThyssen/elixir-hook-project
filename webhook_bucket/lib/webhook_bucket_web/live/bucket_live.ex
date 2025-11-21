defmodule WebhookBucketWeb.BucketLive do
  use WebhookBucketWeb, :live_view
  alias WebhookBucket.Buckets
  alias WebhookBucket.Webhooks

  def mount(%{"slug" => slug}, _session, socket) do
    case Buckets.get_bucket_by_slug(slug) do
      nil ->
        {:ok,
         socket
         |> put_flash(:error, "Bucket not found")
         |> push_navigate(to: "/")}

      bucket ->
        if connected?(socket) do
          Phoenix.PubSub.subscribe(WebhookBucket.PubSub, "bucket:#{slug}")
        end

        requests = Webhooks.list_requests(bucket.id)

        {:ok,
         assign(socket,
           bucket: bucket,
           requests: requests,
           page_title: "Bucket #{slug}"
         )}
    end
  end

  def handle_info({:new_request, request}, socket) do
    {:noreply, update(socket, :requests, fn reqs -> [request | reqs] end)}
  end

  def handle_event("replay", %{"id" => request_id}, socket) do
    request = Enum.find(socket.assigns.requests, &(&1.id == String.to_integer(request_id)))
    target_url = socket.assigns.bucket.target_url

    # Simple Replay logic
    Task.start(fn ->
      Req.request(
        method: String.to_existing_atom(String.downcase(request.method)),
        url: target_url,
        headers: request.headers,
        json: request.body
      )
    end)

    {:noreply, put_flash(socket, :info, "Replaying request to #{target_url}...")}
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-4xl mx-auto p-6">
      <div class="mb-8 flex items-center justify-between">
        <h1 class="text-3xl font-bold text-gray-900">Bucket: <%= @bucket.unique_slug %></h1>
        <div class="text-sm text-gray-500">
          Webhook URL: <code class="bg-gray-100 px-2 py-1 rounded">POST /hook/<%= @bucket.unique_slug %></code>
        </div>
      </div>

      <div class="space-y-4">
        <%= if Enum.empty?(@requests) do %>
          <div class="text-center text-gray-500 py-12 bg-gray-50 rounded-lg border-2 border-dashed border-gray-200">
            Waiting for requests...
          </div>
        <% else %>
          <%= for request <- @requests do %>
            <div class="bg-white shadow rounded-lg overflow-hidden border border-gray-200">
              <div class="bg-gray-50 px-4 py-3 border-b border-gray-200 flex justify-between items-center">
                <div class="flex items-center gap-2">
                  <span class={"px-2 py-1 text-xs font-bold rounded " <> method_color(request.method)}>
                    <%= request.method %>
                  </span>
                  <span class="text-sm text-gray-500">
                    <%= Calendar.strftime(request.inserted_at, "%Y-%m-%d %H:%M:%S") %>
                  </span>
                </div>
                <button phx-click="replay" phx-value-id={request.id} class="text-sm text-indigo-600 hover:text-indigo-800 font-medium">
                  Replay
                </button>
              </div>
              <div class="p-4">
                <div class="mb-4">
                  <h3 class="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2">Headers</h3>
                  <pre class="bg-gray-800 text-green-400 p-3 rounded text-xs overflow-x-auto">
                    <%= Jason.encode!(request.headers, pretty: true) %>
                  </pre>
                </div>
                <div>
                  <h3 class="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2">Body</h3>
                  <pre class="bg-gray-800 text-green-400 p-3 rounded text-xs overflow-x-auto">
                    <%= Jason.encode!(request.body, pretty: true) %>
                  </pre>
                </div>
              </div>
            </div>
          <% end %>
        <% end %>
      </div>
    </div>
    """
  end

  defp method_color("POST"), do: "bg-green-100 text-green-800"
  defp method_color("GET"), do: "bg-blue-100 text-blue-800"
  defp method_color("PUT"), do: "bg-yellow-100 text-yellow-800"
  defp method_color("DELETE"), do: "bg-red-100 text-red-800"
  defp method_color(_), do: "bg-gray-100 text-gray-800"
end
