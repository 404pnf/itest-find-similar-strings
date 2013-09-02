require 'csv'
#require 'test/unit'
require 'digest/md5'
require 'pp'

# USAGE: ruby script.rb inputfile

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
def remove_non_words_and_downcase str
  # \W means charcaters not in range [a-zA-z0-9_]
  # dash '-' is removed, but underscore '_' is kept
  # whitespace is not part of \w so they are removed, too!
  str.downcase
    .gsub(/\W/, '')
end

def find_duplicate_records inputfile
  
  # INPUT [id, text]
  # OUTPUT [md5sum(text), [id1, id10 ... ]]
  db = CSV.read(inputfile).reduce(Hash.new { |h, key| h[key]= [] }) do |acc, (id, text)|
    key = Digest::MD5.hexdigest(text)
    acc[key] << id
    acc
  end

  db.reduce([]) { |acc, (_, ids)|  acc << ids if ids.size > 1 ; acc}
end

# RUN THE MAIN FUNCTION
inputfile = ARGV[0] || 'records.csv'
_tmp_r = find_duplicate_records(inputfile)
_r = _tmp_r.reduce('') { |acc, r| acc << r.to_csv ; acc }
File.write('duplicates.txt', _r)

