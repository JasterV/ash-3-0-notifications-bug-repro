defmodule AshNotificationsBugRepro.Repo do
  use AshPostgres.Repo,
    otp_app: :ash_notifications_bug_repro

  def installed_extensions do
    ["uuid-ossp", "citext", "ash-functions"]
  end
end
