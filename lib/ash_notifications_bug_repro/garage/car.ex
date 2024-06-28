defmodule AshNotificationsBugRepro.Garage.Car do
  use Ash.Resource,
    domain: AshNotificationsBugRepro.Garage,
    data_layer: AshPostgres.DataLayer,
    notifiers: [
      Ash.Notifier.PubSub
    ]

  require Ash.Query
  require Ash.Resource.Change.Builtins

  alias AshNotificationsBugRepro.Garage.Door

  code_interface do
    define :lock
    define :open
  end

  actions do
    defaults [:read, create: :*, update: :*]

    update :lock do
      accept []

      require_atomic? false

      change after_action(&lock_car_doors/3)
      change set_attribute(:status, :locked)
    end

    update :open do
      accept []

      require_atomic? false

      change after_action(&unlock_car_doors/3)
      change set_attribute(:status, :open)
    end
  end

  pub_sub do
    module AshNotificationsBugReproWeb.Endpoint

    prefix "car_changes"
    publish :lock, ["locked", :id]
    publish :open, ["open", :id]
  end

  attributes do
    uuid_primary_key :id

    attribute :status, :atom do
      allow_nil? false
      public? true

      constraints one_of: [
                    :locked,
                    :open
                  ]

      default :locked
    end

    timestamps()
  end

  relationships do
    has_many :doors, AshNotificationsBugRepro.Garage.Door, public?: true
  end

  postgres do
    table "cars"
    repo AshNotificationsBugRepro.Repo
  end

  defp lock_car_doors(_changeset, record, _context) do
    Door
    |> Ash.Query.filter(car_id == ^record.id)
    |> Ash.bulk_update!(:lock, %{})

    {:ok, record}
  end

  defp unlock_car_doors(_changeset, record, _context) do
    Door
    |> Ash.Query.filter(car_id == ^record.id)
    |> Ash.bulk_update!(:unlock, %{})

    {:ok, record}
  end
end
