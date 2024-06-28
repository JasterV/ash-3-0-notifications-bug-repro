defmodule AshNotificationsBugRepro.Garage.CarTest do
  use AshNotificationsBugRepro.DataCase

  import AshNotificationsBugRepro.GarageFixtures

  alias AshNotificationsBugRepro.Garage.Car

  describe "notifications" do
    test "A notification is published when we open a car" do
      car = car_fixture()

      AshNotificationsBugReproWeb.Endpoint.subscribe("car_changes:open:" <> car.id)

      assert %Car{id: car_id, status: :open} = Car.open!(car)

      assert_receive %Phoenix.Socket.Broadcast{topic: "car_changes:open:" <> ^car_id}
    end

    test "A notification is published when locking a car" do
      car = car_fixture()

      AshNotificationsBugReproWeb.Endpoint.subscribe("car_changes:locked:" <> car.id)

      assert %Car{id: car_id, status: :locked} = car |> Car.open!() |> Car.lock!()

      assert_receive %Phoenix.Socket.Broadcast{topic: "car_changes:locked:" <> ^car_id}
    end

    test "A notification is published for each locked door when locking a car"
    test "A notification is published for each unlocked door when we open a car"
  end
end
