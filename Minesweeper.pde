import de.bezier.guido.*;
public final static int NUM_ROWS= 20;
public final static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs; //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int i = 0; i < NUM_ROWS; i++)
  {
    for (int k =0; k <NUM_COLS; k++)
    {        
      buttons[i][k] = new MSButton(i, k);
    }
  }
  bombs = new ArrayList<MSButton>();
  setBombs();
}
public void setBombs()
{

  for (int i = 0; i<=50; i++)
  {
    int col = (int)(Math.random()*NUM_ROWS);
    int row = (int)(Math.random()*NUM_COLS);
    if (!bombs.contains(buttons[row][col]))
      bombs.add(buttons[row][col]);
  }
}

public void draw ()
{
  background( 0 );
  if (isWon())
    displayWinningMessage();
}
public boolean isWon()
{
  for (int i = 0; i < NUM_ROWS; i++)
  {
    for (int j = 0; j< NUM_COLS; j++)
      if (!bombs.contains(buttons[i][j]) && !buttons[i][j].isClicked())
        return false;
  }
  return true;
}
public void displayLosingMessage()
{
  buttons[10][5].setLabel("Y");
  buttons[10][6].setLabel("O");
  buttons[10][7].setLabel("U");
  
  buttons[10][9].setLabel("L");
  buttons[10][10].setLabel("O");
  buttons[10][11].setLabel("S");
  buttons[10][12].setLabel("E");
}
public void displayWinningMessage()
{
  buttons[10][4].setLabel("Y");
  buttons[10][5].setLabel("O");
  buttons[10][6].setLabel("U");

  buttons[10][8].setLabel("W");
  buttons[10][9].setLabel("I");
  buttons[10][10].setLabel("N");
}

public class MSButton
{
  private int r, c;
  private float x, y, width, height;
  private boolean clicked, marked;
  private String label;

  public MSButton ( int rr, int cc )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    r = rr;
    c = cc; 
    x = c*width;
    y = r*height;
    label = "";
    marked = clicked = false;
    Interactive.add( this ); // register it with the manager
  }
  public boolean isMarked()
  {
    return marked;
  }
  public boolean isClicked()
  {
    return clicked;
  }

  public void mousePressed () 
  {
    if (mouseButton == LEFT) {
      clicked = true;
    }
    if (mouseButton == RIGHT) {
      marked = !marked;
    } else if (bombs.contains(this))
      displayLosingMessage();      
    else if (countBombs(r, c)>0)
      setLabel("" +countBombs(r, c));
    else {
      for (int nextR = -1; nextR < 2; nextR++)
        for (int nextC = -1; nextC <2; nextC++)
          if (isValid(r + nextR, c+nextC) && buttons[r + nextR][c+nextC].isClicked() == false)
            buttons[r+nextR][c+nextC].mousePressed();
    }

  }

  public void draw () 
  {    
    if (marked)
      fill(0);
    else if ( clicked && bombs.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(label, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    label = newLabel;
  }
  public boolean isValid(int r, int c)
  {
    if ( r < NUM_ROWS && r > 0 && c> 0 && c < NUM_COLS)
      return true;
    return false;
  }
  public int countBombs(int row, int col)
  {
    int numBombs = 0;
    if (isValid(row+1, col)) {
      if (bombs.contains(buttons[row+1][col]))
        numBombs++;
    }
    if (isValid(row-1, col)) {
      if (bombs.contains(buttons[row-1][col]))
        numBombs++;
    }
    if (isValid(row, col+1)) {
      if (bombs.contains(buttons[row][col+1]))
        numBombs++;
    }
    if (isValid(row, col-1)) {
      if (bombs.contains(buttons[row][col-1]))
        numBombs++;
    }
    if (isValid(row+1, col+1)) {
      if (bombs.contains(buttons[row+1][col+1]))
        numBombs++;
    }
    if (isValid(row+1, col-1)) {
      if (bombs.contains(buttons[row+1][col-1]))
        numBombs++;
    }
    if (isValid(row-1, col-1)) {
      if (bombs.contains(buttons[row-1][col-1]))
        numBombs++;
    }
    if (isValid(row-1, col+1)) {
      if (bombs.contains(buttons[row-1][col+1]))
        numBombs++;
    }     
    return numBombs;
  }
}
