defmodule ElixirSearchRouter do
  use Plug.Router

  plug(:match)
  plug(:dispatch, builder_opts())

  get "/status" do
    send_resp(conn, 200, "up")
  end

  get "/search/:keyword" do
    opts[:index_agent]
      |> SearchIndexAgent.get()
      |> SearchIndex.search(keyword)
      |> search_response(conn)
  end

  put "/documents/:id" do
    {:ok, body, conn} = read_body(conn, opts)
    {:ok, parsed_body} = Jason.decode(body)
    opts[:index_agent] |> SearchIndexAgent.insert(id, parsed_body)
    send_resp(conn, 201, "")
  end

  defp search_response([], conn) do
    send_resp(conn, 200, "nothing")
  end

  defp search_response(results, conn) do
    {:ok, json} = Jason.encode(results)
    send_resp(conn, 200, json)
  end
end