# -*- coding: utf-8 -*-
require 'csv'
require 'minitest/autorun'
require 'test/unit'
# records are csv file
#
# in irb
#
# >> a = ['a', 'b', 'c']
# => ["a", "b", "c"]
# >> a.each_with_index {|r,i| p [i,r].to_csv}
# "0,a\n"
# "1,b\n"
# "2,c\n"
# => ["a", "b", "c"]

def gen_random_string(len)
  (0...len).map { rand(36).to_s(36) }.join
end

def make_records(numbers, filename)
  numbers, filename = ARGV[0], ARGV[1]

  records = []
  numbers.to_i.times { records << gen_random_string(10) + ' ' +  gen_random_string(10) }

  csv = ''
  records.each_with_index do |text, index|
    csv << [index, text].to_csv
  end

  File.write("#{filename}.csv", csv)
end

make_records(ARGV[0], ARGV[1])  if __FILE__ == $PROGRAM_NAME

# testing
class TestAddRecordSeparator < Test::Unit::TestCase
  def test_gen_random_string
    # 正确的测试方法是从概率上考察，随机100次，不相同的应该占大多数
    # 虽然从概率上说100次完全相同也是允许的 ：（
    # http://stackoverflow.com/questions/2082970/whats-the-best-way-to-test-this
    assert_equal 10, gen_random_string(10).length, '是否生成指定长度的字符串'
    assert_not_equal gen_random_string(10), gen_random_string(10)
    assert_not_equal gen_random_string(10), gen_random_string(10)
    assert_not_equal gen_random_string(10), gen_random_string(10)
    assert_not_equal gen_random_string(10), gen_random_string(10)
    assert_not_equal gen_random_string(10), gen_random_string(10)
  end
end
