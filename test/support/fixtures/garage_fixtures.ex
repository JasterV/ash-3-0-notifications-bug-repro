defmodule AshNotificationsBugRepro.GarageFixtures do
  alias AshNotificationsBugRepro.Garage.Car

  def car_fixture(attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        status: :locked
      })

    Car
    |> Ash.Changeset.for_create(:create, attrs)
    |> Ash.create!()
  end
end
