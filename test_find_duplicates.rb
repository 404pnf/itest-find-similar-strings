require 'test/unit'
require_relative 'find_duplicate_records.rb'

# testing
class TestFindDuplicateEntries < Test::Unit::TestCase

  def test_remove_non_words_and_downcase
    assert_equal 'camelcase', remove_non_words_and_downcase('CamelCase'), 'case 1: downcase'
    assert_equal 'iamhere', remove_non_words_and_downcase('I am here! '), 'case 2: remove punctuations!'
    assert_equal 'timmyyes', remove_non_words_and_downcase('Timmy? Yes!'), 'case 3: remove punctuations'
    assert_equal '', remove_non_words_and_downcase('`~!@#$%^&*()-+="\'/\\'), 'case 4: remove all non word characters'
  end
end
