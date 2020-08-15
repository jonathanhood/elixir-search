defmodule ElixirSearchRouter do
  use Plug.Router

  plug(:match)
  plug(:dispatch, builder_opts())

  get "/search/:keyword" do
    opts[:index_agent]
      |> Agent.get(& &1)
      |> SearchIndex.search(keyword)
      |> search_response(conn)
  end

  defp search_response([], conn) do
    send_resp(conn, 200, "nothing")
  end

  defp search_response(results, conn) do
    send_resp(conn, 200, List.first(results).id)
  end
end