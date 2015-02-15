defmodule Concrypt.Encrypted  do

  def decrypted(val, decrypter) do
    if encrypted?(val) do
      decrypter.(contents(val))
    else
      val
    end
  end

  def contents("ENC(" <> rest), do: String.rstrip(rest, ?))
  def contents(contents), do: contents

  def encrypted?("ENC(" <> _), do: true
  def encrypted?(_), do: false
end