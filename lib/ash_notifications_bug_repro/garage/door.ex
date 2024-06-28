defmodule AshNotificationsBugRepro.Garage.Door do
  use Ash.Resource,
    domain: AshNotificationsBugRepro.Garage,
    data_layer: AshPostgres.DataLayer,
    notifiers: [
      Ash.Notifier.PubSub
    ]

  code_interface do
    define :lock
    define :unlock
  end

  actions do
    defaults [:read, create: :*, update: :*]

    update :lock do
      accept []
      change set_attribute(:status, :locked)
    end

    update :unlock do
      accept []
      change set_attribute(:status, :unlocked)
    end
  end

  pub_sub do
    module AshNotificationsBugReproWeb.Endpoint

    prefix "door_changes"
    publish :unlock, ["unlocked", :id]
    publish :lock, ["locked", :id]
  end

  attributes do
    uuid_primary_key :id

    attribute :status, :atom do
      allow_nil? false
      public? true

      constraints one_of: [
                    :locked,
                    :unlocked
                  ]

      default :locked
    end

    timestamps()
  end

  relationships do
    belongs_to :car, AshNotificationsBugRepro.Garage.Car, public?: true
  end

  postgres do
    table "doors"
    repo AshNotificationsBugRepro.Repo
  end
end
