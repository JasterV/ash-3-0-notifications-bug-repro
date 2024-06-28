defmodule AshNotificationsBugRepro.Garage do
  use Ash.Domain

  resources do
    resource AshNotificationsBugRepro.Garage.Car
    resource AshNotificationsBugRepro.Garage.Door
  end
end
