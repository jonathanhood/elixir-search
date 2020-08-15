defmodule ElixirSearchRouter do
  use Plug.Router

  plug(:match)
  plug(:dispatch, builder_opts())
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)

  get "/search/:keyword" do
    opts[:index_agent]
      |> Agent.get(& &1)
      |> SearchIndex.search(keyword)
      |> search_response(conn)
  end

  put "/documents/:id" do
    {:ok, body, conn} = read_body(conn, opts)
    opts[:index_agent] |> Agent.update(&SearchIndex.insert(&1, id, body))
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