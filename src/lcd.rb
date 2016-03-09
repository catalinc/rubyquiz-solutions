DIGIT_CODES = { 
  0 => [0, 1, 2, 3, 4, 5], 
  1 => [1, 2],
  2 => [0, 1, 6, 4, 3],
  3 => [0, 1, 6, 2, 3],
  4 => [5, 6, 1, 2],
  5 => [0, 5, 6, 2, 3],
  6 => [0, 5, 6, 2, 4, 3],
  7 => [0, 1, 2],
  8 => [0, 1, 2, 3, 4, 5, 6],
  9 => [0, 1, 6, 5, 2, 3]
}

def print_display_matrix(matrix)
  matrix.map do |row|
    puts row.join('')
  end
end

def build_display_matrix(bar_size, digits)
  digit_width  = bar_size + 3
  digit_height = bar_size * 2 + 7 

  matrix = Array.new(digit_height) do |row|
    row = Array.new(digit_width * digits.size) do |cell|
      cell = ' '
    end
  end

  digits.each_with_index do |digit, index|
    draw_digit(bar_size, digit, index, matrix)
  end
  
  matrix
end

def draw_digit(bar_size, digit, index, matrix)
  column = (bar_size + 3) * index
  DIGIT_CODES[digit].each do |code|
    draw_code(bar_size, code, column, matrix)
  end
end

def draw_code(bar_size, code, column, matrix)
  case code
  when 0
    draw_horizontal_bar(bar_size, 0,                 column + 1,                     matrix)
  when 1
    draw_vertical_bar(bar_size,   2,                 column + bar_size + 1,          matrix)
  when 2
    draw_vertical_bar(bar_size,   bar_size + 5,      column + bar_size + 1,          matrix)
  when 3
    draw_horizontal_bar(bar_size, bar_size * 2 + 6,  column + 1,                     matrix)
  when 4
    draw_vertical_bar(bar_size,   bar_size + 5,      column,                         matrix)
  when 5
    draw_vertical_bar(bar_size,   2,                 column,                         matrix)
  when 6
    draw_horizontal_bar(bar_size, bar_size + 3,      column + 1,                     matrix)
  end
end

def draw_horizontal_bar(size, row, col, matrix)
  0.upto(size - 1) do |i|
    matrix[row][col + i] = '-'
  end
end

def draw_vertical_bar(size, row, col, matrix)
  0.upto(size - 1) do |i|
    matrix[row + i][col] = '|'
  end
end

size   = 2
digits = nil

if ARGV[0] == "-s"
  size = ARGV[1].to_i
  ARGV.shift
  ARGV.shift
end

digits = ARGV[0].split(//).map { |digit| digit.to_i }

print_display_matrix(build_display_matrix(size, digits))
