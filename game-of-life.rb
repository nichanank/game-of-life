#An implementation for the simulation of Conway's Game of Life (https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life).

class Cell
  attr_accessor :x, :y, :alive

  def initialize(x=0, y=0)
    @x = x
    @y = y
    @alive = false
  end

  def born!
    @alive = true
  end

  def die!
    @alive = false
  end

  def alive?
    return @alive
  end

  def to_s
    @alive ? "*" : " "
  end

end

class World
  attr_accessor :cells, :rows, :cols, :game_grid

  def initialize(rows=10, cols=10)
    @rows = rows
    @cols = cols
    @cells = []

    @game_grid = Array.new(rows) do |row|
      Array.new(cols) do |col|
        cell = Cell.new(row, col)
        cells.push(cell)
      end
    end
  end

  #Returns the number of living neighbours for a given cell.
  def get_living_neighbours(cell)
    living_neighbours = []

    #Checking the status of neighbouring cells, with checks for cases where the cell resides on the edge of the grid.
    if cell.y < rows - 1
      neighbour = game_grid[cell.x][cell.y + 1]
      living_neighbours.push(neighbour) if neighbour.alive?
    end

    if cell.x < cols - 1 && cell.y < rows - 1
      neighbour = game_grid[cell.x + 1][cell.y + 1]
      living_neighbours.push(neighbour) if neighbour.alive?
    end

    if cell.x < cols - 1
      neighbour = game_grid[cell.x + 1][cell.y]
      living_neighbours.push(neighbour) if neighbour.alive?
    end

    if cell.x < rows - 1 && cell.y > 0
      neighbour = game_grid[cell.x + 1][cell.y - 1]
      living_neighbours.push(neighbour) if neighbour.alive?
    end

    if cell.y > 0
      neighbour = game_grid[cell.x][cell.y - 1]
      living_neighbours.push(neighbour) if neighbour.alive?
    end

    if cell.x > 0 && cell.y > 0
      neighbour = game_grid[cell.x - 1][cell.y - 1]
      living_neighbours.push(neighbour) if neighbour.alive?
    end

    if cell.x > 0
      neighbour = game_grid[cell.x - 1][cell.y]
      living_neighbours.push(neighbour) if neighbour.alive?
    end

    if cell.x > 0 && cell.y < rows - 1
      neighbour = game_grid[cell.x - 1][cell.y + 1]
      living_neighbours.push(neighbour) if neighbour.alive?
    end

    return living_neighbours

  end

  def living_cells
    return cells.select { |cell| cell.alive? }
  end

  def populate
    cells.each do |cell|
      cell.alive = [true, false].sample
    end
  end
end

class Game
  attr_accessor :world

  def initialize
    @world = get_grid_size
    world.populate
  end

  def get_grid_size
    printf "Enter board width: "
    width = gets.chomp.to_i
    printf "Enter board height: "
    height = gets.chomp.to_i
    return World.new(width, height)
  end

  def next_state
    alive_next_round = []
    dead_next_round = []

    @world.cells.each do |cell|
      living_neighbours_count = @world.get_living_neighbours(cell).count

      #Rule 1: A location that has zero or one neighbors will be empty in the next generation. If a cell was in that location, it dies of loneliness.

      #Rule 4: A location with four or more neighbors will be empty in the next generation. If there was a cell in that location, it dies of overcrowding.
      if (cell.alive && living_neighbours_count < 2) || living_neighbours_count >= 4
        dead_next_round.push(cell)
      end

      #Rule 2: A location with two neighbors is stable—that is, if it contained a cell, it still contains a cell. If it was empty, it's still empty.

      #Rule 3: A location with three neighbors will contain a cell in the next generation. If it was unoccupied before, a new cell is born. If it currently contains a cell, the cell remains.
      if (cell.alive && living_neighbours_count == 2) || living_neighbours_count == 3
        alive_next_round.push(cell)
      end

    end

    alive_next_round.each do |cell|
      cell.born!
    end

    dead_next_round.each do |cell|
      cell.die!
    end

  end

  def to_s
    puts @world.game_grid
  end

  def play
    printf "How many generations would you like to simulate? "
    generations = gets.chomp.to_i
    i = 0
    while i <= generations do
      puts @world.game_grid
      next_state
      i += 1
    end
  end

end

game = Game.new
game.play
