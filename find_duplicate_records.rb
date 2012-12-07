
require 'csv'
require 'test/unit'
require 'digest/md5'

# USAGE: ruby script.rb inputfile

=begin
inputfile is a csv file with the format:
id, text
id, text
...

We process the records with following steps
1. parse csv, make it an array of arrays
2. caclulate md5sum of each record's text
3. make a hash with md5sum as key, and id as values, each key can has multiple values
4. find those keys with multiple values.  Meaning they are identical.
5. return the result in an array
=end

# signature for md5
# Digest::MD5.hexdigest("Hello World\n")


inputfile = ARGV[0]

# helper functions



def remove_non_words_and_downcase str
  # \W means charcaters not in range [a-zA-z0-9_]
  # dash '-' is removed, but underscore '_' is kept
  # whitespace is not part of \w so they are removed, too!
  str.downcase
    .gsub(/\W/, '')
end

def text_md5sum str
  Digest::MD5.hexdigest(str)
end


# we don't need this since \W covers white spaces! 
# !!
# def remove_whitespace str
#  str.gsub(/\s+/, '')
# end

# step 1
array = []
csv_data = CSV.parse inputfile {|row| array << row}
p array


db = Hash.new {|h, key| h[key]= []}

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
