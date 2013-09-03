require 'csv'
require 'amatch'
# require 'test/unit'
require 'digest/md5'
require 'pp'

include Amatch

# USAGE: ruby script.rb inputfile

# inputfile is a csv file with the format:
# id, text
# id, text
# ...
#
# We process the records with following steps
# 1. parse csv, make it an array of arrays
# 2. make a hash with id as key and text as value(remove non words and downcase  all char of value)
# 3. get array of key_pairs to compare
# 4. find those keys whose string similarity comparation value is greater than the GATE

# helper functions
def remove_non_words_and_downcase(str)
  # \W means charcaters not in range [a-zA-z0-9_]
  # dash '-' is removed, but underscore '_' is kept
  # whitespace is not part of \w so they are removed, too!
  str.downcase
    .gsub(/\W/, '')
end

def keys_to_compare (array)
  array.combination(2)
end

def find_similiar(inputfile)
  db = CSV.read(inputfile).reduce({}) do |a, (id, text)|
    a[id.to_i] = remove_non_words_and_downcase(text)
    a
  end

  key_pairs =  keys_to_compare(db.keys)

  # step 4
  # comapare similarity
  # method signature
  # "pattern language".jarowinkler_similar("language of patterns")
  # => 0.672222222222222
  r = [] # final result
  gate = 0.8
  key_pairs.each do |pair|
    h, t = pair[0], pair[1]
    distance = db[h].jarowinkler_similar(db[t]).to_f
    r << [distance, pair] if distance > gate
  end

  p "result is:  #{r}"
  p "number of pairs:  #{r.size}"

  r
end

def main
  _tmp_r = find_similiar ARGV[0] || 'records.csv'
  # _tmp_r is:  [[1.0, [0, 10]], [0.9866666666666667, [3, 13]], [0.9661111111111111, [4, 14]], [1.0, [8, 18]]]
  # distance in first column
  # then comes array of similiar ids
  r = _tmp_r.map { |e| e.flatten }.reduce('') { |a, e| a << e.to_csv; a }
  p '在similiar.txt中查看相似题目的id'
  File.write('similiar.txt', r)
end

# run the script
main if __FILE__ == $PROGRAM_NAME