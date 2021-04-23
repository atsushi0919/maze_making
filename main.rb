class MazeByMakingWall
  attr_accessor :maze

  PATH = 0
  WALL = 1

  def initialize(w, h)
    @w = w
    @h = h
    @maze = []
    @lst_candidate = []

    exit if @w < 5 || @h < 5
    @w += 1 if @w.even?
    @h += 1 if @h.even?

    (0...@w).each do |x|
      row = []
      (0...@h).each do |y|
        if x == 0 || y == 0 || x == @w - 1 || y == @h - 1
          cell = WALL
        else
          cell = PATH
          if x.even? && y.even?
            @lst_candidate << [x, y]
          end
        end
        row << cell
      end
      @maze << row
    end
    maze[1][1] = "Ｓ"
    maze[w - 2][h - 2] = "Ｇ"
  end

  def make_maze
    @lst_candidate.shuffle!
    while !@lst_candidate.empty?
      sx, sy = @lst_candidate.pop
      if @maze[sx][sy] == PATH
        @lst_current = []
        extend_wall(sx, sy)
      end
    end
    @maze
  end

  def extend_wall(x, y)
    lst_direction = []
    if @maze[x][y - 1] == PATH && !@lst_current.include?([x, y - 2])
      lst_direction << 0
    end
    if @maze[x + 1][y] == PATH && !@lst_current.include?([x + 2, y])
      lst_direction << 1
    end
    if @maze[x][y + 1] == PATH && !@lst_current.include?([x, y + 2])
      lst_direction << 2
    end
    if @maze[x - 1][y] == PATH && !@lst_current.include?([x - 2, y])
      lst_direction << 3
    end
    if !lst_direction.empty?
      @maze[x][y] = WALL
      @lst_current << [x, y]
      direction = lst_direction.sample
      continue_make_wall = false
      case direction
      when 0
        continue_make_wall = @maze[x][y - 2] == PATH
        @maze[x][y - 1] = WALL
        @maze[x][y - 2] = WALL
        @lst_current << [x, y - 2]
        if continue_make_wall
          extend_wall(x, y - 2)
        end
      when 1
        continue_make_wall = @maze[x + 2][y] == PATH
        @maze[x + 1][y] = WALL
        @maze[x + 2][y] = WALL
        @lst_current << [x + 2, y]
        if continue_make_wall
          extend_wall(x + 2, y)
        end
      when 2
        continue_make_wall = @maze[x][y + 2] == PATH
        @maze[x][y + 1] = WALL
        @maze[x][y + 2] = WALL
        @lst_current << [x, y + 2]
        if continue_make_wall
          extend_wall(x, y + 2)
        end
      when 3
        continue_make_wall = @maze[x - 2][y] == PATH
        @maze[x - 1][y] = WALL
        @maze[x - 2][y] = WALL
        @lst_current << [x - 2, y]
        if continue_make_wall
          extend_wall(x - 2, y)
        end
      end
    else
      px, py = @lst_current.pop
      extend_wall(px, py)
    end
  end

  def print_maze
    @maze.each do |row|
      line = row.map do |cell|
        case cell
        when 0
          "　"
        when 1
          "■"
        else
          cell
        end
      end
      puts line.join
    end
  end
end

maze = MazeByMakingWall.new(51, 51)
maze.make_maze
maze.print_maze
