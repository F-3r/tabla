require "minitest/autorun"
require "pp"
require "byebug"

require_relative "../lib/tabla"

TABLA = <<-TABLA
date       | desc                                 | amount | notes
2019-01-01 | Something that worths a lot storing  | 20     | reference: 1237987
2019-01-01 | Something that worths a lot          | 10     | reference: 1237987
2019-01-01 | Something that worths                | 5      | reference: 1237987
2019-01-01 | Something that                       | 2.5    | reference: 1237987
2019-01-01 | Something                            | 1.25   | reference: 1237987
2019-01-01 |                                      |        | reference: 1237987
TABLA

class ValidString < Minitest::Test
  def setup
    @tabla = Tabla.new TABLA
    @tabla.parse
  end

  def test_that_each_items_has_correct_keys
    @tabla.data.each { |row| assert_equal ["date", "desc", "amount", "notes"], row.keys }
  end

  def test_that_each_item_has_correct_value
    result = @tabla.data

    result.each { |row| assert_equal row["date"], "2019-01-01" }
    result.each { |row| assert_equal row["notes"], "reference: 1237987" }
    assert_equal ["20", "10", "5", "2.5", "1.25", ""], result.map { |row| row["amount"] }
    assert_empty result.last["desc"]
  end
end

class InvalidFieldCountInRow < Minitest::Test
  def setup
    @tabla = Tabla.new <<-EOF
date       | name
2019-01-01 | Something | | | | |
    EOF
    @tabla.parse
  end

  def test_it_ignores_extra_elements
    assert_equal({ "date" => "2019-01-01", "name" => "Something"}, @tabla.parse.first)
  end
end

class DumpTest < Minitest::Test
  def setup
    @data = <<-EOF
date | name | number
2019-01-01 | Something | 1234
2019-01-02 | Other | 5678
    EOF
    @parsed_data = [
                    {
                     "date" => "2019-01-01",
                     "name" => "Something",
                     "number" => "1234",
                    },
                    {
                     "date" => "2019-01-02",
                     "name" => "Other",
                     "number" => "5678",
                    },
                    ]
  end

  def test_it_ignores_extra_elements
    assert_equal @data, Tabla.dump(@parsed_data)
  end

  def test_it_can_load_what_it_dumps
    assert_equal @parsed_data, Tabla.load(Tabla.dump(@parsed_data))
  end

  def test_it_can_dump_what_it_loads
    assert_equal @data, Tabla.dump(Tabla.load(@data))
  end
end

class EnumerableAPIImplementation < Minitest::Test
  def setup
    @tabla = Tabla.new TABLA
    @tabla.parse
  end

  def test_it_returns_an_enumerator_if_no_block_given
    assert_equal Enumerator, @tabla.each.class
  end

  def test_it_evaluates_the_block_for_each_element
    @tabla.each { |item| assert_equal "2019-01-01", item["date"] }
  end

  def test_it_selects
    expected = [{"date"=>"2019-01-01", "desc"=>"Something", "amount"=>"1.25", "notes"=>"reference: 1237987"}]
    assert_equal expected, @tabla.select { |i| i["desc"] == "Something"}
  end
end

class MapperBlockTest < Minitest::Test
  def setup
    @tabla = Tabla.new(TABLA) { |item| 1 }
    @tabla.parse
  end

  def test_it_maps_all_the_items_through_the_mapper_block
    @tabla.data.each { |item| assert_equal 1, item }
  end
end
