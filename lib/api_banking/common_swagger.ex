defmodule ApiBanking.CommonSwagger do
  @moduledoc "Common parameter declarations for phoenix swagger"
   alias PhoenixSwagger.Path.PathObject
  import PhoenixSwagger.Path
  
  def authorization(path = %PathObject{}) do
    path |> parameter("Authorization", :header, :string, "Bearer *token", required: true)
  end

end