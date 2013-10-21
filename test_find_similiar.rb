require 'test/unit'
require_relative 'find_similar_records.rb'

# testing
class TestFindSimiliarEntries < Test::Unit::TestCase

  def test_remove_non_words_and_downcase
    assert_equal 'camelcase', remove_non_words_and_downcase('CamelCase'), 'case 1: downcase'
    assert_equal 'iamhere', remove_non_words_and_downcase('I am here! '), 'case 2: remove punctuations!'
    assert_equal 'timmyyes', remove_non_words_and_downcase('Timmy? Yes!'), 'case 3: remove punctuations'
    assert_equal '', remove_non_words_and_downcase('`~!@#$%^&*()-+="\'/\\'), 'case 4: remove all non word characters'
  end

  def test_keys_to_compare
    assert_equal [[1, 2], [1, 3], [2, 3]], keys_to_compare([1, 2, 3]), 'keys_to_compare'
  end

end
