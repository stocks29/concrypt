defmodule Concrypt.CryptoTest do
  use ExUnit.Case, async: true
  alias Concrypt.Crypto

  @cbc_type :aes_cbc256

  @key "abcdefghabcdefgh"
  @iv "12345678abcdefgh"

  @password "some pw"
  @salt "foobar"
  @keysize 16
  
  test "can encrypt and decrypt block size plain text" do
    plaintext = "12345678123456781234567812345678"
    ciphertext = Crypto.encrypt(@cbc_type, @key, @iv, plaintext)
    assert ciphertext != plaintext
    decrypted = Crypto.decrypt(@cbc_type, @key, @iv, ciphertext)
    assert decrypted == plaintext
  end

  test "can encrypt and decrypt less-than-block size plain text" do
    plaintext = "1234567"
    ciphertext = Crypto.encrypt(@cbc_type, @key, @iv, plaintext)
    assert ciphertext != plaintext
    decrypted = Crypto.decrypt(@cbc_type, @key, @iv, ciphertext)
    assert decrypted == plaintext
  end

  test "can encrypt and decrypt less-than-block size plain text using password" do
    plaintext = "1234567"
    ciphertext = Crypto.encrypt(@cbc_type, @password, plaintext)
    assert ciphertext != plaintext
    decrypted = Crypto.decrypt(@cbc_type, @password, ciphertext)
    assert decrypted == plaintext
  end

  test "can encrypt and decrypt using password with aes_cbc128" do
    algo = :aes_cbc128
    plaintext = "1234567"
    ciphertext = Crypto.encrypt(algo, @password, plaintext)
    assert ciphertext != plaintext
    decrypted = Crypto.decrypt(algo, @password, ciphertext)
    assert decrypted == plaintext
  end

  test "can generate salted key and iv" do
    {key, iv} = Crypto.salted_key_and_iv(@password, @salt, @keysize)
    assert key != nil
    assert String.length(key) == @keysize
    assert iv != nil
    assert String.length(iv) == @keysize
  end
end