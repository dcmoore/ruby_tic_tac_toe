Board
  makeMove(row, col, team) - updates the game board to reflect a move by the specified team
  reset - clears all previous moves from the game board
  spaceContents(row, col) - returns the contents of the specified space
  isEmpty?(row, col) - returns true if no team had made a move on that spaces
  dimRows - returns the number of rows in the board
  dimCols - returns the number of columns in the board
Player
  type - returns the type of player (Human or Computer)
Calculate
  self.isGameOver?(Board) - returns true if draw?(), xWin?(), or oWin?() returns true
  self.xWin?(Board) - returns true if team X has 3 consecutive spaces in a row
  self.oWin?(Board) - returns true if team O has 3 consecutive spaces in a row
  self.draw?(Board) - returns true if X and O didn't win and the board is full
  self.numMovesMade(Board) - returns the number of moves that have been made on the board
  self.currentTeam(Board) - returns the team who is next in line to make a move
  self.aiBestMove(Board) - returns an array containing the row and column of the best possible next move
