# -*- coding: utf-8 -*-
require 'csv'
require 'amatch'
require 'test/unit'
require 'digest/md5'
require 'pp'

include Amatch

# USAGE: ruby script.rb inputfile

=begin
inputfile is a csv file with the format:
id, text
id, text
...

We process the records with following steps
1. parse csv, make it an array of arrays
2. make a hash with id as key and text as value(remove non words and downcase  all char of value)
3. get array of key_pairs to compare
4. find those keys whose string similarity comparation value is greater than the GATE

=end

# helper functions
def remove_non_words_and_downcase str
  # \W means charcaters not in range [a-zA-z0-9_]
  # dash '-' is removed, but underscore '_' is kept
  # whitespace is not part of \w so they are removed, too!
  str.downcase
    .gsub(/\W/, '')
end
def keys_to_compare array
  # input hash
  # output array of arrays of index pair
  array.permutation(2)
    .to_a
    .map {|i| i.sort}
    .uniq
end

# step 1
inputfile = File.read ARGV[0]
array = []
CSV.parse(inputfile) {|row| array << row}
#p array

# step 2
db = {}
array.each do |entry|
  key, value = entry[0].to_i, entry[1]
  db[key] = remove_non_words_and_downcase(value)
end
#pp db

# step 3
# 需要用每一条记录和其它所有记录对比，但避免重复对比，
# 比如 [1,10] [10,1] 是重复的，因此这里先去除重复再让后面程序计算
keys = db.keys
# p keys
key_pairs =  keys_to_compare keys
#p key_pairs

# step 4
# comapare similarity
# method signature
# "pattern language".jarowinkler_similar("language of patterns")
# => 0.672222222222222

$r = [] # final result 
GATE = 0.8
key_pairs.each do |pair|
  h, t = pair[0], pair[1]
  distance = db[h].jarowinkler_similar(db[t]).to_f
  $r << [pair, distance] if distance > GATE
end
p "result is:  #{$r}"
p "number of pairs:  #{$r.size}"

# tests

class TestFindDuplicateEntries < Test::Unit::TestCase

  def test_remove_non_words_and_downcase
    assert_equal 'camelcase', remove_non_words_and_downcase('CamelCase'), 'case 1: downcase'
    assert_equal 'iamhere', remove_non_words_and_downcase('I am here! '), 'case 2: remove punctuations!'
    assert_equal 'timmyyes', remove_non_words_and_downcase('Timmy? Yes!'), 'case 3: remove punctuations'
    assert_equal '', remove_non_words_and_downcase('`~!@#$%^&*()-+="\'/\\'), 'case 4: remove all non word characters'
  end

  def test_keys_to_compare
    assert_equal [[1, 2], [1, 3], [2, 3]], keys_to_compare([1,2,3]), 'keys_to_compare'
  end

end
