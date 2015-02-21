defmodule Concrypt.Crypto do

  @default_algo :aes_cbc256

  @doc """
  Encrypt the given plain text using the provided password and the 
  default algo (aes_cbc256)
  """
  def encrypt(password, plaintext) do
    encrypt(@default_algo, password, plaintext)
  end

  @doc """
  Encrypt the given plaintext using the provided algo and password
  """
  def encrypt(type, password, plaintext) do
    {key, iv} = salted_key_and_iv(password, password, key_size(type))
    encrypt(type, key, iv, plaintext)
  end

  @doc """
  Encrypt plain text using the given type, key and iv
  """
  def encrypt(type, key, iv, plaintext) do
    :crypto.block_encrypt(type, key, iv, :pkcs7.pad(plaintext))
    |> Base.encode64
  end

  @doc """
  Decrypt the given ciphertext using the provided password and the
  default algo (aes_cbc256)
  """
  def decrypt(password, plaintext) do
    decrypt(@default_algo, password, plaintext)
  end

  @doc """
  Decrypt the given ciphertext using the provided password and algo
  """
  def decrypt(type, password, ciphertext) do
    {key, iv} = salted_key_and_iv(password, password, key_size(type))
    decrypt(type, key, iv, ciphertext)
  end
  
  @doc """
  Decrypt ciphertext using the given type, key, and iv
  """
  def decrypt(type, key, iv, ciphertext) do
    :crypto.block_decrypt(type, key, iv, Base.decode64!(ciphertext))
    |> :pkcs7.unpad
  end

  @doc """
  Generate a key and iv of the requested key size from the given 
  password and salt
  """
  def salted_key_and_iv(password, salt, keysize) do
    hash = _hash_to_length(password, salt, 2 * keysize, "", "")
    {
      hash |> String.slice(0, keysize),
      hash |> String.slice(1, keysize)
    }
  end

  defp _hash_to_length(_password, _salt, keysize, _last, acc) when byte_size(acc) >= keysize do
    acc
  end 
  defp _hash_to_length(password, salt, keysize, last, acc) do
    next = :crypto.hash(:md5, last <> password <> salt) 
    _hash_to_length(password, salt, keysize, next, acc <> next)
  end

  defp key_size(:aes_cbc256), do: 16
  defp key_size(:aes_cbc128), do: 16
  defp key_size(_), do: {:error, "don't know key size for algorithm"}

end