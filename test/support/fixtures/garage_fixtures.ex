defmodule AshNotificationsBugRepro.GarageFixtures do
  alias AshNotificationsBugRepro.Garage.Car
  alias AshNotificationsBugRepro.Garage.Door

  def car_fixture(attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        status: :locked
      })

    Car
    |> Ash.Changeset.for_create(:create, attrs)
    |> Ash.create!()
  end

  def door_fixture(attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        status: :locked,
        car_id: car_fixture().id
      })

    Door
    |> Ash.Changeset.for_create(:create, attrs)
    |> Ash.create!()
  end
end
