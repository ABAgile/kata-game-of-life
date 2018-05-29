require 'ncurses'

# class for Game-of-life simulation
#
# state: a 40x40 grid of state, 0: dead, 1: alive
class Game
  GRID_ROW = 40
  GRID_COL = 80

  attr_accessor :grid

  def initialize(seed = nil)
    @grid = seed.nil? ? random_seed : seed
  end

  def start
    Ncurses.run do |scr|
      loop do
        if IO.select [$stdin], nil, nil, 0.1
          break if scr.getch == 'q'.ord
        end
        scr.clear
        render_grid(scr)
        scr.refresh
        @grid = tick
        # sleep 0.1
      end
    end
  end

  private

  def neighbour_cells(row, col)
    [row - 1, row, row + 1].each_with_object([]) do |r_idx, memo|
      [col - 1, col, col + 1].each do |c_idx|
        next if r_idx == row && c_idx == col
        next if r_idx < 0 || r_idx >= GRID_ROW
        next if c_idx < 0 || c_idx >= GRID_COL

        memo << [r_idx, c_idx]
      end
    end
  end

  def alive_neighbours(row, col)
    neighbour_cells(row, col).count { |r_idx, c_idx| grid[r_idx][c_idx] == 1 }
  end

  def tick
    Array.new(GRID_ROW) do |row|
      Array.new(GRID_COL) do |col|
        if grid[row][col].zero?
          alive_neighbours(row, col) == 3 ? 1 : 0
        else
          [2, 3].include?(alive_neighbours(row, col)) ? 1 : 0
        end
      end
    end
  end

  def render_cell(scr, row, col, cell)
    scr.mvaddch(row, col * 2, 'O'.ord) unless cell.zero?
  end

  def render_grid(scr)
    grid.each.with_index do |row, r_idx|
      row.each.with_index do |cell, c_idx|
        render_cell(scr, r_idx, c_idx, cell)
      end
    end
  end

  def random_seed
    Array.new(GRID_ROW) { Array.new(GRID_COL) { [0, 1].sample } }
  end
end

class Game
  def self.empty
    Array.new(GRID_ROW) { Array.new(GRID_COL) { 0 } }
  end

  def self.block
    empty.tap do |grid|
      [
        [1, 1], [1, 2],
        [2, 1], [2, 2]
      ].each do |(row, col)|
        grid[row][col] = 1
      end
    end
  end

  def self.beehive
    empty.tap do |grid|
      [
        [1, 2], [1, 3],
        [2, 1], [2, 4],
        [3, 2], [3, 3]
      ].each do |(row, col)|
        grid[row][col] = 1
      end
    end
  end

  def self.loaf
    empty.tap do |grid|
      [
        [1, 2], [1, 3],
        [2, 1], [2, 4],
        [3, 2], [3, 4],
        [4, 3]
      ].each do |(row, col)|
        grid[row][col] = 1
      end
    end
  end

  def self.blinker
    empty.tap do |grid|
      [
        [2, 1], [2, 2], [2, 3]
      ].each do |(row, col)|
        grid[row][col] = 1
      end
    end
  end

  def self.train
    empty.tap do |grid|
      [
        [1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7], [1, 8],
        [1, 10], [1, 11], [1, 12], [1, 13], [1, 14],
        [1, 18], [1, 19], [1, 20],
        [1, 27], [1, 28], [1, 29], [1, 30], [1, 31], [1, 32], [1, 33],
        [1, 35], [1, 36], [1, 37], [1, 38], [1, 39]
      ].each do |(row, col)|
        grid[row][col] = 1
      end
    end
  end

  def self.glider
    empty.tap do |grid|
      [
        [1, 2],
        [2, 3],
        [3, 1], [3, 2], [3, 3]
      ].each do |(row, col)|
        grid[row][col] = 1
      end
    end
  end

  def self.glider_gun
    empty.tap do |grid|
      [
        [1, 25],
        [2, 23], [2, 25],
        [3, 13], [3, 14], [3, 21], [3, 22], [3, 35], [3, 36],
        [4, 12], [4, 16], [4, 21], [4, 22], [4, 35], [4, 36],
        [5, 1],  [5, 2],  [5, 11], [5, 17], [5, 21], [5, 22],
        [6, 1],  [6, 2],  [6, 11], [6, 15], [6, 17], [6, 18], [6, 23], [6, 25],
        [7, 11], [7, 17], [7, 25],
        [8, 12], [8, 16],
        [9, 13], [9, 14]
      ].each do |(row, col)|
        grid[row][col] = 1
      end
    end
  end

  def self.simkin_gun
    empty.tap do |grid|
      [
        [11,  5],  [11,  6],  [11,  12], [11,  13],
        [12,  5],  [12,  6],  [12,  12], [12,  13],
        [14,  9],  [14,  10],
        [15,  9],  [15,  10],
        [20, 27], [20, 28], [20, 30], [20, 31],
        [21, 26], [21, 32],
        [22, 26], [22, 33], [22, 36], [22, 37],
        [23, 26], [23, 27], [23, 28], [23, 32], [23, 36], [23, 37],
        [24, 31],
        [28, 25], [28, 26],
        [29, 25],
        [30, 26], [30, 27], [30, 28],
        [31, 28]
      ].each do |(row, col)|
        grid[row][col] = 1
      end
    end
  end
end

module Ncurses
  def self.run
    scr = initscr

    cbreak      # provide unbuffered input
    noecho      # turn off input echoing
    nonl        # turn off newline translation
    curs_set(0) # turn off cursor

    yield scr
  ensure
    echo
    nocbreak
    nl
    curs_set(1)
    # endwin
  end
end

# if it is run as command line script, start a game with random grid
# Game.new(Game.simkin_gun).start if $PROGRAM_NAME == __FILE__
Game.new().start if $PROGRAM_NAME == __FILE__
