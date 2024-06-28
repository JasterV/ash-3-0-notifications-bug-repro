defmodule AshNotificationsBugRepro.Garage.CarTest do
  use AshNotificationsBugRepro.DataCase

  import AshNotificationsBugRepro.GarageFixtures

  alias AshNotificationsBugRepro.Garage.Car
  alias AshNotificationsBugRepro.Garage.Door

  describe "notifications" do
    test "A notification is published when we open a car" do
      car = car_fixture()

      AshNotificationsBugReproWeb.Endpoint.subscribe("car_changes:open:" <> car.id)

      assert %Car{id: car_id, status: :open} = Car.open!(car)

      assert_receive %Phoenix.Socket.Broadcast{topic: "car_changes:open:" <> ^car_id}
    end

    test "A notification is published when locking a car" do
      car = car_fixture(%{status: :open})

      AshNotificationsBugReproWeb.Endpoint.subscribe("car_changes:locked:" <> car.id)

      assert %Car{id: car_id, status: :locked} = Car.lock!(car)

      assert_receive %Phoenix.Socket.Broadcast{topic: "car_changes:locked:" <> ^car_id}
    end

    test "A notification is published for each unlocked door when opening a car" do
      car = car_fixture()
      %Door{id: front_door_id} = door_fixture(%{car_id: car.id})
      %Door{id: back_door_id} = door_fixture(%{car_id: car.id})

      AshNotificationsBugReproWeb.Endpoint.subscribe("door_changes:unlocked:" <> front_door_id)
      AshNotificationsBugReproWeb.Endpoint.subscribe("door_changes:unlocked:" <> back_door_id)

      assert %Car{status: :open} = Car.open!(car)

      assert_receive %Phoenix.Socket.Broadcast{topic: "door_changes:unlocked:" <> ^front_door_id}
      assert_receive %Phoenix.Socket.Broadcast{topic: "door_changes:unlocked:" <> ^back_door_id}
    end

    test "A notification is published for each locked door when we locking a car" do
      car = car_fixture(%{status: :open})
      %Door{id: front_door_id} = door_fixture(%{car_id: car.id})
      %Door{id: back_door_id} = door_fixture(%{car_id: car.id})

      AshNotificationsBugReproWeb.Endpoint.subscribe("door_changes:locked:" <> front_door_id)
      AshNotificationsBugReproWeb.Endpoint.subscribe("door_changes:locked:" <> back_door_id)

      assert %Car{status: :locked} = Car.lock!(car)

      assert_receive %Phoenix.Socket.Broadcast{topic: "door_changes:locked:" <> ^front_door_id}
      assert_receive %Phoenix.Socket.Broadcast{topic: "door_changes:locked:" <> ^back_door_id}
    end
  end
end
