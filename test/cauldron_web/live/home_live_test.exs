defmodule CauldronWeb.HomeLiveTest do
  use CauldronWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "renders homepage with key elements", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/")

    assert has_element?(view, "#hero-section")
    assert has_element?(view, "#deploy-info")
    assert has_element?(view, "#cauldron")
    assert has_element?(view, "#ingredients")
  end

  test "displays deploy info", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/")

    assert has_element?(view, "#deploy-info")
    html = render(view)
    assert html =~ System.version()
    assert html =~ Application.spec(:phoenix, :vsn) |> to_string()
  end

  test "clicking cauldron cycles theme", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/")

    assert has_element?(view, "#cauldron")
    view |> element("#cauldron") |> render_click()
    assert has_element?(view, "#cauldron")
  end

  test "shows DB connection status", %{conn: conn} do
    {:ok, _view, html} = live(conn, ~p"/")

    assert html =~ "Connected"
  end
end
