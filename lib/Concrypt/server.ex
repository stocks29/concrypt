defmodule Concrypt.Server do
  require Logger
  use GenServer
  alias Concrypt.SettingsFile, as: SF
  alias Concrypt.Encrypted, as: E

  ## Client API

  @doc """
  Starts the server.
  """
  def start_link(args, opts \\ []) do
    GenServer.start_link(__MODULE__, args, opts)
  end

  @doc """
  Load a file, decrypt it and update the Application's envs
  """
  def load(server, file) do
    GenServer.cast(server, {:load, file})
  end


  ## Server Callbacks

  def init([env_key, env_iv]) do
    {:ok, _decrypter(env_key, env_iv)}
  end

  def handle_cast({:load, file}, decrypter) do
    SF.stream!(file)
    |> Stream.map(&(_decrypt(&1, decrypter)))
    |> Enum.each(&_put_env/1)
    {:noreply, decrypter} 
  end

  defp _decrypter(env_key, env_iv) do
    key = System.get_env(env_key)
    iv = System.get_env(env_iv)
    fn b64ctext ->
      ciphertext = b64ctext |> Base.decode64!
      :crypto.block_decrypt(:aes_cbc256, key, iv, ciphertext) 
    end
  end

  defp _decrypt({app, key, val}, decrypter) do
    {app, key, E.decrypted(val, decrypter)}
  end

  defp _put_env({app, key, val}) do
      Logger.debug "Setting app=#{inspect app} key=#{inspect key} val=*****"
      Application.put_env(app, key, val)
  end

end