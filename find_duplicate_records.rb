# ## 使用方法
#
#      USAGE: ruby script.rb inputfile
#
# ----
require 'csv'
# require 'test/unit'
require 'digest/md5'
require 'pp'

# ## 命名空间呗
module ItestFindDuplicateRecords

  # inputfile is a csv file with the format:
  # id, text
  # id, text
  # ...
  #
  # We process the records with following steps
  # 1. parse csv, make it an array of arrays
  # 2. make a hash of which each value is an array
  # 3. caclulate md5sum of each record's text, use the md5sum as key, and add the id to the value
  # 4. find those keys with multiple ids. Return the result in an array

  # HELPER FUNCTIONS
  # \W means charcaters not in range [a-zA-z0-9_]
  # dash '-' is removed, but underscore '_' is kept
  # whitespace is not part of \w so they are removed, too!
  def self.remove_non_words_and_downcase(str)
    str.downcase
      .gsub(/\W/, '')
  end

  # INPUT [id, text]
  # OUTPUT [md5sum(text), [id1, id10 ... ]]
  def self.find_duplicate_records(inputfile)
    db = CSV.read(inputfile).each_with_object(Hash.new { |h, key| h[key] = [] }) do |(id, text), a|
      key = Digest::MD5.hexdigest(text)
      a[key] << id
    end
    db.each_with_object([]) { |(_, ids), a|  a << ids if ids.size > 1 }
  end

end

def main
  inputfile = ARGV[0] || 'records.csv'
  tmp_r = ItestFindDuplicateRecords.find_duplicate_records(inputfile)
  r = tmp_r.each_with_object('') { |e, a| a << e.to_csv }
  pp r
  File.write('duplicates.txt', r)
end

# RUN THE MAIN FUNCTION
main if __FILE__ == $PROGRAM_NAME
