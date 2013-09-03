require 'test/unit'

INPUT = '''
1 some text
2 some more test
3 a string
'''

OUTPUT = '''
1, some text
2, some more test
3, a string
'''

def add_record_separator(str)
  str.gsub!(/(^\d+)/) { MatchData + ',' }
end

# testing
class TestAddSeparators < Test::Unit::TestCase
  def test_add_record_separator
    assert_equal OUTPUT, add_record_separator(INPUT)
  end
end
