defmodule ApiBanking.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :Rent,
  module: ApiBanking.Guardian,
  error_handler: ApiBanking.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end