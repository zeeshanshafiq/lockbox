require_relative "test_helper"

class DalliTest < Minitest::Test
  def setup
    dalli.flush_all
  end

  def test_set_get
    encrypted_dalli.set("hello", "world")
    assert_equal "world", encrypted_dalli.get("hello")
    refute_equal "world", dalli.get("hello")
  end

  def test_get_multi
    encrypted_dalli.set("k1", "v1")
    encrypted_dalli.set("k2", "v2")
    encrypted_dalli.set("k3", nil)
    expected = {"k1" => "v1", "k2" => "v2", "k3" => nil}
    assert_equal expected, encrypted_dalli.get_multi("k1", "k2", "k3", "missing")
    refute_equal "v1", dalli.get("k1")
    refute_equal "v2", dalli.get("k2")
    assert_nil dalli.get("k3")
  end

  def dalli
    @dalli ||= Dalli::Client.new
  end

  def encrypted_dalli
    @encrypted_dalli ||= Lockbox::Dalli.new(key: Lockbox.generate_key)
  end
end
