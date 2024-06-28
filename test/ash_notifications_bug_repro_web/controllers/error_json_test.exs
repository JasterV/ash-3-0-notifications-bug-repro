defmodule AshNotificationsBugReproWeb.ErrorJSONTest do
  use AshNotificationsBugReproWeb.ConnCase, async: true

  test "renders 404" do
    assert AshNotificationsBugReproWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert AshNotificationsBugReproWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
