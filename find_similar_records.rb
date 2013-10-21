# ## 使用方法
#
#     USAGE: ruby script.rb inputfile
#

require 'csv'
require 'amatch'
# require 'test/unit'
require 'digest/md5'
require 'pp'

# ## 命名空间呗
module ItestFindSimilarRecords

  include Amatch

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
  # \W means charcaters not in range [a-zA-z0-9_]
  # dash '-' is removed, but underscore '_' is kept
  # whitespace is not part of \w so they are removed, too!
  def self.remove_non_words_and_downcase(str)
    str.downcase
      .gsub(/\W/, '')
  end

  def self.keys_to_compare(array)
    array.combination(2)
  end

  # comapare similarity
  # method signature
  # "pattern language".jarowinkler_similar("language of patterns")
  # => 0.672222222222222
  def find_similiar(inputfile)
    db = CSV.read(inputfile).each_with_object({}) do |(id, text), a|
      a[id.to_i] = remove_non_words_and_downcase(text)
    end
    key_pairs =  keys_to_compare(db.keys)
    gate = 0.8
    key_pairs.each_with_object([]) do |pair, o|
      h, t = pair[0], pair[1] # hare and turtle; let's see how far they are
      distance = db[h].jarowinkler_similar(db[t]).to_f
      o << [distance, pair] if distance > gate
    end
  end

  module_function :find_similiar

end

# run the script
# _tmp_r is:  [[1.0, [0, 10]], [0.9866666666666667, [3, 13]], [0.9661111111111111, [4, 14]], [1.0, [8, 18]]]
# distance in first column
# then comes array of similiar ids
def main
  tmp_r = ItestFindSimilarRecords.find_similiar ARGV[0] || 'records.csv'
  rst = tmp_r.map { |e| e.flatten }.each_with_object('') { |e, a| a << e.to_csv }
  p "result is:  #{rst}"
  p "number of pairs:  #{rst.size}"
  p '在similiar.txt中查看相似题目的id'
  File.write('similiar.csv', rst)
end

main if __FILE__ == $PROGRAM_NAME
