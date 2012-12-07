
require 'csv'
require 'test/unit'
require 'digest/md5'
require 'pp'

# USAGE: ruby script.rb inputfile

=begin
inputfile is a csv file with the format:
id, text
id, text
...

We process the records with following steps
1. parse csv, make it an array of arrays
2. make a hash with md5sum as key, and id as values, each key can has multiple values
3. caclulate md5sum of each record's text
4. find those keys with multiple values.  Meaning they are identical. Return the result in an array

=end

# helper functions
def remove_non_words_and_downcase str
  # \W means charcaters not in range [a-zA-z0-9_]
  # dash '-' is removed, but underscore '_' is kept
  # whitespace is not part of \w so they are removed, too!
  str.downcase
    .gsub(/\W/, '')
end
def text_md5sum str
  # signature for md5
  # Digest::MD5.hexdigest("Hello World\n")
  Digest::MD5.hexdigest(str)
end
# we don't need this since \W covers white spaces! 
# !!
# def remove_whitespace str
#  str.gsub(/\s+/, '')
# end


# step 1
inputfile = File.read ARGV[0]
array = []
CSV.parse(inputfile) {|row| array << row}
#p array

# step 2
db = Hash.new {|h, key| h[key]= []}

# step 3
# a sample array
# [["0", "5av0afm7zf oocvikh1uo"], ["1", "qxuw4lzdql hh82g7jkic"]]
array.map! {|entry|  [entry[0], text_md5sum(entry[1])]}
# now array becomes [["0", "0721a89fcd7797946a477faea06fee65"], ["1", "7420c044640c553e27cbbf96b891ec23"]]
array.each do |entry|
  key, value = entry[1], entry[0].to_i
  db[key] << value 
end
#pp db

# step 4
result = []
db.each {|key, value|  result << value if db[key].size > 1}
pp result

# tests

class TestFindDuplicateEntries < Test::Unit::TestCase

  def test_text_md5sum
    assert_equal 'fc3ff98e8c6a0d3087d515c0473f8677', text_md5sum('hello world!'), 'md5sum test'
  end

  def test_remove_non_words_and_downcase
    assert_equal 'camelcase', remove_non_words_and_downcase('CamelCase'), 'case 1: downcase'
    assert_equal 'iamhere', remove_non_words_and_downcase('I am here! '), 'case 2: remove punctuations!'
    assert_equal 'timmyyes', remove_non_words_and_downcase('Timmy? Yes!'), 'case 3: remove punctuations'
    assert_equal '', remove_non_words_and_downcase('`~!@#$%^&*()-+="\'/\\'), 'case 4: remove all non word characters'
  end
end
