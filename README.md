## Game of Life Kata

## Requirement

This Kata is about calculating the next generation of Conway's game of life,
given any starting position.
[See for background](http://en.wikipedia.org/wiki/Conway%27s_Game_of_Life).

You start with a two dimensional grid of cells, where each cell is either
alive or dead. In this version of the problem, the grid is finite, and no life
can exist off the edges. When calculating the next generation of the grid,
follow these rules:

   1. Any live cell with fewer than two live neighbors dies, as if caused by underpopulation.

   2. Any live cell with more than three live neighbors dies, as if by overcrowding.

   3. Any live cell with two or three live neighbors lives on to the next generation.

   4. Any dead cell with exactly three live neighbors becomes a live cell.

### Setup

- assume [asdf](https://github.com/asdf-vm/asdf) installed

- Install ruby 2.5.1

  ```bash
  asdf plugin-add ruby
  asdf install ruby 2.5.1
  ```

- Clone project & bundle gems

  ```bash
  git clone https://github.com/ABAgile/kata-game-of-life ./game-of-life
  cd game-of-life
  gem install bundler
  bundle install
  ```
