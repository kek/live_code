defmodule LiveCodeWeb.PageControllerTest do
  use LiveCodeWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Type code here!"
  end
end
