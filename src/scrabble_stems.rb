require 'benchmark'

DICT    = ARGV[0]
CUTOFF  = ARGV[1].to_i
BM_ONLY = ARGV[2] == "--bm-only"

def find_stems(filename, cutoff)
  stems = Hash.new { |h, k| h[k] = { } }

  File.open(filename) do |file|
    file.each do |line|
      line.chomp!
      # we are interested only in bingo moves
      next if line.size != 7
      line.downcase!
      letters = line.split(//).sort
      word    = letters.join
      uniques = letters.uniq
      uniques.each do |letter|
        # compute number of distinct letters that can be combined
        # with this bingo stem to lead to a bingo move
        stem = word.sub(letter, '')
        stems[stem][letter] = 1
      end
    end
  end

  stems.delete_if { |k, v| v.size < cutoff }
  results = stems.sort_by { |k, v| v.size }
  results.reverse!.map! { |k, v| [k, v.size] }
  results
end

results = nil
Benchmark.bm(15) do |b|
  b.report("find_stems:") { results=find_stems(DICT, CUTOFF) }
end

unless BM_ONLY
  results.each do |k, v|
    puts "stem #{k} combining #{v} letters"
  end
end

