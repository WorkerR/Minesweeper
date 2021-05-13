%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Programmer(s): Jackson He & Junxi Li
% Program Name : SUPERME's Mindsweeper
% Description  : This is a game which can bring
%                you lots of fun.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% GLOBAL VARIABLES %%%%%
var dmx, dmy, m : int %The dimension of the map and the number of mine
var posx, posy, button, useless : int %The coordinate of the mouse and the left/right button
var col, row : int %The columns and rows in the map
var custom : array 0 .. 1000 of array 0 .. 1000 of int %A blank map with only the mines
var mapnum : array 0 .. 1000 of array 0 .. 1000 of int %The map with all the numbers and mines
var revealornot : array 0 .. 1000 of array 0 .. 1000 of boolean
var reveal : array char of boolean %A variable whick checks whether to reveal the block or not
var colors : array 1 .. 8 of int := init (33, 2, 12, 1, 183, 124, 107, 4) %Eight colors of the eight number
var fontID : int := Font.New ("Consolas:15:bold") %The font of numbers
var gameover : boolean := false %A boolean value checks whether the game is over.
var win : boolean := false %A boolean value checks whether the user wins.
var countreveal : int %A variable counts how many block were revealed.
var bombcount : int %A variable counts how many bombs were revealed.
var clickcount : int %A variable counts how many clicks in total.
var output : int %A text stream file.
var looptime : int := 0 %Number of times the user play the game.
var picbomb : int := Pic.FileNew ("bomb.jpg") %The bomb image
picbomb := Pic.Scale (picbomb, 20, 20) %Set the scale to 20 * 20

%%%%% SUBPROGRAMS %%%%%

%The procedure Help display the help window which shows the instruction of the game.
procedure Help ()
    delay (200)
    var xmouse, ymouse, button, useless : int
    var MenuWindow : int := Window.GetSelect
    var HelpWindow : int := Window.Open ("graphics:510;300")
    View.Set ("position:center;center")
    View.Set ("title:Help")
    locate (2, 1)
    put "**************************Description**************************"
    put "   Minesweeper is a single-player puzzle video game. The "
    put "objective of the game is to clear a rectangular board "
    put "containing hidden \"mines\" or bombs without detonating any of "
    put "them, with help from clues about the number of neighboring "
    put "mines in each field. "
    put " "
    put "**************************Instruction**************************"
    put "   Left click is put the flag down, use right click to cancel  the flag. Hold \"space\" and left click can open the field. If   you hold \"space\" key and right click the opened field, you can"
    put "see which field around the opened field may possibly has mines.If you find out all the mines around the opened field and "
    put "already put flags on them, then hold \"space\" and right click"
    put "the opened field can help you automatically open the fields "
    put "left. "
    put "**********************Click mouse to exit**********************"
    Mouse.ButtonWait ("downup", xmouse, ymouse, button, useless)
    Window.Close (HelpWindow)
    Window.SetActive (MenuWindow)
end Help

%The procedure gameMode allows user to choose different diffiticulty of the game.
procedure gameMode ()
    var font, fontID, xmouse, ymouse, button : int
    font := Font.New ("Courier New:35:bold")
    var OptionWindow : int := Window.GetSelect
    var x : int := -330
    var x1 : int := -50
    var turn1 : int := 5
    var x2 : int := -10
    var turn2 : int := 7
    var x3 : int := -90
    var turn3 : int := 6
    var x4 : int := -100
    var turn4 : int := 9
    Mouse.Where (xmouse, ymouse, button)

    loop
	Draw.FillBox (0, 0, 640, 480, 78)
	drawfilloval (400, 170, 130, 80, white)
	drawfilloval (380, 80, 80, 40, white)
	drawfilloval (410, 220, 80, 40, white)
	drawfilloval (520, 110, 70, 50, white)
	drawfilloval (520, 190, 80, 50, white)
	drawfilloval (300, 180, 60, 50, white)
	drawfilloval (300, 120, 40, 30, white)

	if x1 >= 240 and turn1 = 5
		then
	    turn1 := -turn1
	    x1 += turn1
	elsif x1 <= 40 and turn1 = -5
		then
	    turn1 := -turn1
	    x1 += turn1
	end if
	if x2 >= 240 and turn2 = 7
		then
	    turn2 := -turn2
	    x2 += turn2
	elsif x2 <= 40 and turn2 = -7
		then
	    turn2 := -turn2
	    x2 += turn2
	end if
	if x3 >= 240 and turn3 = 6
		then
	    turn3 := -turn3
	    x3 += turn3
	elsif x3 <= 40 and turn3 = -6
		then
	    turn3 := -turn3
	    x3 += turn3
	end if
	if x4 >= 240 and turn4 = 9
		then
	    turn4 := -turn4
	    x4 += turn4
	elsif x4 <= 40 and turn4 = -9
		then
	    turn4 := -turn4
	    x4 += turn4
	end if

	x1 += turn1
	x2 += turn2
	x3 += turn3
	x4 += turn4

	Draw.FillBox (x1 + 85, 360, x1 + 220, 420, 52)
	Draw.Box (x1 + 85, 360, x1 + 220, 420, black)
	Draw.Text ("Easy", x1 + 95, 380, font, black)

	Draw.FillBox (x2 + 85, 260, x2 + 270, 320, 52)
	Draw.Box (x2 + 255 - 170, 260, x2 + 270, 320, black)
	Draw.Text ("Normal", x2 + 95, 280, font, black)

	Draw.FillBox (x3 + 85, 160, x3 + 220, 220, 52)
	Draw.Box (x3 + 85, 160, x3 + 220, 220, black)
	Draw.Text ("Hard", x3 + 95, 180, font, black)

	Draw.FillBox (x4 + 85, 60, x4 + 270, 120, 52)
	Draw.Box (x4 + 85, 60, x4 + 270, 120, black)
	Draw.Text ("Custom", x4 + 95, 80, font, black)

	Mouse.Where (xmouse, ymouse, button)
	exit when button = 1 and ((xmouse >= x1 + 85 and xmouse <= x1 + 220 and ymouse >= 360 and ymouse <= 420) or
	    (xmouse >= x2 + 85 and xmouse <= x2 + 220 and ymouse >= 260 and ymouse <= 320) or
	    (xmouse >= x3 + 85 and xmouse <= x3 + 220 and ymouse >= 160 and ymouse <= 220) or
	    (xmouse >= x4 + 85 and xmouse <= x4 + 220 and ymouse >= 60 and ymouse <= 120))
	delay (50)
	cls

    end loop
    if xmouse >= x1 + 85 and xmouse <= x1 + 220 and ymouse >= 360 and ymouse <= 420
	    then
	dmx := 9
	dmy := 9
	m := 10
    elsif xmouse >= x2 + 85 and xmouse <= x2 + 220 and ymouse >= 260 and ymouse <= 320
	    then
	dmx := 16
	dmy := 16
	m := 40
    elsif xmouse >= x3 + 85 and xmouse <= x3 + 220 and ymouse >= 160 and ymouse <= 220
	    then
	dmx := 30
	dmy := 16
	m := 99
    elsif xmouse >= x4 + 85 and xmouse <= x4 + 220 and ymouse >= 60 and ymouse <= 120
	    then
	var chooseWindow : int := Window.Open ("graphics:400;200")
	View.Set ("position:center;center")
	View.Set ("title:Custon")
	locate (1, 23)
	put "Limit:"
	locate (2, 8)
	put "Map Width <= 200 , Map Height <= 200"
	locate (3, 8)
	put "Mine number < Map Width * Map Height"
	locate (5, 8)
	put "Please enter the map width: " ..
	get dmx
	locate (6, 8)
	put "Please enter the map height: " ..
	get dmy
	locate (7, 8)
	put "Please enter the number of mine: " ..
	get m
	Window.Close (chooseWindow)
	Window.SetActive (OptionWindow)
    end if

end gameMode

%The procedure menu display the covering page of the game.
procedure menu ()
    var font, fontID, xmouse, ymouse, button : int
    fontID := Font.New ("Courier New:40:bold")
    font := Font.New ("Courier New:35:bold")
    var x : int := -330
    var y1 : int := -70
    var turn1 : int := 5
    var y2 : int := -30
    var turn2 : int := 7
    var y3 : int := -110
    var turn3 : int := 6

    setscreen ("graphics:640;480")
    View.Set ("position:center;center")
    View.Set ("title:Superme Minesweeper")
    View.Set ("position:center;center")
    loop
	Draw.FillBox (0, 0, 640, 480, 78)
	drawfilloval (400, 170, 130, 80, white)
	drawfilloval (380, 80, 80, 40, white)
	drawfilloval (410, 220, 80, 40, white)
	drawfilloval (520, 110, 70, 50, white)
	drawfilloval (520, 190, 80, 50, white)
	drawfilloval (300, 180, 60, 50, white)
	drawfilloval (300, 120, 40, 30, white)
	if x <= 660
		then
	    x += 5
	    Draw.Text ("SUPERME's", x, 380, fontID, black)
	    Draw.Text ("MINESWEEPER", 320 - x, 330, fontID, black)
	else
	    x := -340
	end if

	if y1 >= 240 and turn1 = 5
		then
	    turn1 := -turn1
	    y1 += turn1
	elsif y1 <= 40 and turn1 = -5
		then
	    turn1 := -turn1
	    y1 += turn1
	end if
	if y2 >= 240 and turn2 = 7
		then
	    turn2 := -turn2
	    y2 += turn2
	elsif y2 <= 40 and turn2 = -7
		then
	    turn2 := -turn2
	    y2 += turn2
	end if
	if y3 >= 240 and turn3 = 6
		then
	    turn3 := -turn3
	    y3 += turn3
	elsif y3 <= 40 and turn3 = -6
		then
	    turn3 := -turn3
	    y3 += turn3
	end if

	y1 += turn1
	y2 += turn2
	y3 += turn3

	Draw.FillBox (255 - 170, y1 - 20, 390 - 170, y1 + 40, 52)
	Draw.Box (255 - 170, y1 - 20, 390 - 170, y1 + 40, black)
	Draw.Text ("Help", 265 - 170, y1, font, black)

	Draw.FillBox (255, y2 - 20, 390, y2 + 40, 52)
	Draw.Box (255, y2 - 20, 390, y2 + 40, black)
	Draw.Text ("Play", 265, y2, font, black)

	Draw.FillBox (255 + 170, y3 - 20, 390 + 170, y3 + 40, 52)
	Draw.Box (255 + 170, y3 - 20, 390 + 170, y3 + 40, black)
	Draw.Text ("Quit", 265 + 170, y3, font, black)

	Mouse.Where (xmouse, ymouse, button)
	exit when button = 1 and ((xmouse >= 85 and xmouse <= 220 and ymouse >= y1 - 20 and ymouse <= y1 + 40) or
	    (xmouse >= 255 and xmouse <= 390 and ymouse >= y2 - 20 and ymouse <= y2 + 40) or
	    (xmouse >= 425 and xmouse <= 560 and ymouse >= y3 - 20 and ymouse <= y3 + 40))
	delay (50)
	cls
    end loop

    if xmouse >= 85 and xmouse <= 220 and ymouse >= y1 - 20 and ymouse <= y1 + 40
	    then
	Help ()
	menu ()
    elsif xmouse >= 255 and xmouse <= 390 and ymouse >= y2 - 20 and ymouse <= y2 + 40
	    then
	gameMode ()
    elsif xmouse >= 425 and xmouse <= 560 and ymouse >= y3 - 20 and ymouse <= y3 + 40
	    then
	quit
    end if
end menu

%The procedure press gets the position the mouse has pressed and turns into columns and rows.
procedure pressandrelease ()
    Mouse.Where (posx, posy, button)
    col := (posx - 25) div 20 + 1
    row := dmy - (posy - 25) div 20
end pressandrelease

%The procedure press get the position the mouse has pressed and turns into columns and rows.
procedure press ()
    Mouse.ButtonWait ("down", posx, posy, button, useless)
    col := (posx - 25) div 20 + 1
    row := dmy - (posy - 25) div 20
end press

%The procedure randomMine gets the size and number of mine and randomly plot it into the map.
procedure randomMine (x, y, m : int)
    var mine : int
    var mine2 : int

    bombcount := 0
    clickcount := 0
    countreveal := 0
    gameover := false
    win := false

    for i : 0 .. x + 1
	for j : 0 .. y + 1
	    custom (i) (j) := 0
	    mapnum (i) (j) := 0
	    revealornot (i) (j) := false
	end for
    end for

    for i : 1 .. m
	mine := Rand.Int (1, x)
	mine2 := Rand.Int (1, y)
	if custom (mine) (mine2) = 0
		then
	    custom (mine) (mine2) := -1
	else
	    loop
		mine := Rand.Int (1, x)
		mine2 := Rand.Int (1, y)
		exit when custom (mine) (mine2) = 0
	    end loop
	    custom (mine) (mine2) := -1
	end if
    end for
end randomMine

%The procedure setupgame use to set the basic map (including the data of each block) up.
procedure setupgame (x, y, m : int)
    View.Set ("graphics:" + intstr (x * 20 + 50) + "," + intstr (y * 20 + 50))
    View.Set ("position:center;center")
    View.Set ("title:Superme Minesweeper")
    View.Set ("position:center;center")
    Draw.FillBox (0, 0, x * 20 + 50, y * 20 + 50, 30)
    Draw.FillBox (25, 25, x * 20 + 25, y * 20 + 25, 54)

    for i : 0 .. y
	Draw.Line (25, 20 * i + 25, x * 20 + 25, 20 * i + 25, black)
    end for

    for i : 0 .. x
	Draw.Line (20 * i + 25, 25, 20 * i + 25, y * 20 + 25, black)
    end for

    randomMine (x, y, m)
    for i : 1 .. x
	for j : 1 .. y
	    mapnum (i) (j) -= custom (i - 1) (j - 1)
	    mapnum (i) (j) -= custom (i - 1) (j)
	    mapnum (i) (j) -= custom (i - 1) (j + 1)
	    mapnum (i) (j) -= custom (i) (j - 1)
	    mapnum (i) (j) -= custom (i) (j + 1)
	    mapnum (i) (j) -= custom (i + 1) (j - 1)
	    mapnum (i) (j) -= custom (i + 1) (j)
	    mapnum (i) (j) -= custom (i + 1) (j + 1)
	    if custom (i) (j) = -1
		    then
		mapnum (i) (j) := -1
	    end if
	end for
    end for
end setupgame

%The procedure gameOver gives results when the user lose or win the game.
procedure gameOver ()
    var x, y, button : int
    var font : int := Font.New ("Courier New:30:bold")
    var PlayWindow : int := Window.GetSelect
    var ResultWindow : int := Window.Open ("graphics:400;240")
    View.Set ("position:center;center")
    View.Set ("title:Result")

    if gameover = true
	    then
	Draw.Text ("Try again!", 90, 175, font, black)
	Draw.Text ("You lose!", 105, 140, font, black)
	locate (8, 13)
	put "Your total clicks are ", clickcount, "."
	locate (9, 8)
	put "You have revealed ", bombcount - 1, " bombs out of ", m, "."
    else
	Draw.Text ("Congratulations!", 15, 175, font, black)
	Draw.Text ("You Win!", 120, 135, font, black)
	locate (8, 13)
	put "Your total clicks are ", clickcount, "."
	locate (9, 8)
	put "You have revealed ", bombcount, " bombs out of ", m, "."
    end if

    Draw.FillBox (25, 25 + 5, 125, 75 + 5, black)
    Draw.Text ("Again", 48, 45 + 5, fontID, white)

    Draw.FillBox (150, 25 + 5, 250, 75 + 5, black)
    Draw.Text ("Menu", 177, 45 + 5, fontID, white)

    Draw.FillBox (275, 25 + 5, 375, 75 + 5, black)
    Draw.Text ("Quit", 302, 45 + 5, fontID, white)

    locate (2, 2)
    put "Scores recorded to the MinesweeperScore.txt file."

    Mouse.ButtonWait ("up", x, y, button, useless)
    Window.Close (ResultWindow)
    Window.SetActive (PlayWindow)

    if x >= 25 and x <= 125 and y >= 25 and y <= 755
	    then
	setupgame (dmx, dmy, m)
    elsif x >= 150 and x <= 250 and y >= 25 and y <= 75
	    then
	menu ()
    elsif x >= 275 and x <= 375 and y >= 25 and y <= 75
	    then
	quit
    end if
end gameOver

%The procedure drawFlag draws a flag and plot in into the map.
procedure drawFlag (x, y : int)
    var flagx : array 1 .. 3 of int := init (3, 12, 12)
    var flagy : array 1 .. 3 of int := init (13, 17, 9)

    Draw.ThickLine (12 + 25 + 20 * (x - 1), maxy + 3 - 45 - 20 * (y - 1), 12 + 25 + 20 * (x - 1), maxy + 17 - 45 - 20 * (y - 1), 2, white)
    Draw.ThickLine (8 + 25 + 20 * (x - 1), maxy + 3 - 45 - 20 * (y - 1), 14 + 25 + 20 * (x - 1), maxy + 3 - 45 - 20 * (y - 1), 2, white)

    for i : 1 .. 3
	flagx (i) := flagx (i) + 25 + 20 * (x - 1)
	flagy (i) := maxy + flagy (i) - 45 - 20 * (y - 1)
    end for
    Draw.FillPolygon (flagx, flagy, 3, 40)
end drawFlag

%The procedure notRevealBlock is use to unreveal the flag.
procedure notRevealBlock (x, y : int)
    Draw.FillBox (25 + 20 * (x - 1), maxy - 45 - 20 * (y - 1) + 1, 25 + 20 * (x - 1) + 20, maxy + 20 - 45 - 20 * (y - 1) + 1, 54)
    Draw.Box (25 + 20 * (x - 1), maxy - 45 - 20 * (y - 1) + 1, 25 + 20 * (x - 1) + 20, maxy + 20 - 45 - 20 * (y - 1) + 1, black)
end notRevealBlock

%The procedure drawBomb inserts a merge picture of bomb into the map.
procedure drawBomb (x, y : int)
    Pic.Draw (picbomb, 25 + 20 * (x - 1), maxy - 45 - 20 * (y - 1) + 1, picMerge)
end drawBomb

%The procedure revealBlock reveals the block.
procedure revealBlock (x, y : int)
    Draw.FillBox (25 + 20 * (x - 1) + 1, maxy - 45 - 20 * (y - 1) + 1, 25 + 20 * (x - 1) + 20, maxy - 45 - 20 * (y - 1) + 20, 30)
    Draw.Box (25 + 20 * (x - 1) + 1, maxy - 45 - 20 * (y - 1) + 1, 25 + 20 * (x - 1) + 20, maxy - 45 - 20 * (y - 1) + 20, black)
end revealBlock

%The procedure spread helps to reveals the block.
procedure spread (x, y : int)

    if revealornot (x) (y) = false
	    then
	revealornot (x) (y) := true
	revealBlock (x, y)

	if mapnum (x) (y) > 0 and mapnum (x) (y) < 9
		then
	    Font.Draw (intstr (mapnum (x) (y)), 25 + 20 * (x - 1) + 5, maxy - 45 - 20 * (y - 1) + 5, fontID, colors (mapnum (x) (y)))
	    revealornot (x) (y) := true
	    mapnum (x) (y) += 10

	elsif mapnum (x) (y) = 0
		then

	    mapnum (x) (y) += 10
	    if revealornot (x - 1) (y) = false and x > 1
		    then
		spread (x - 1, y)
		mapnum (x - 1) (y) += 10
	    end if
	    if revealornot (x + 1) (y) = false and x < dmx
		    then
		spread (x + 1, y)
		mapnum (x + 1) (y) += 10
	    end if
	    if revealornot (x) (y - 1) = false and y > 1
		    then
		spread (x, y - 1)
		mapnum (x) (y - 1) += 10
	    end if
	    if revealornot (x) (y + 1) = false and y < dmy
		    then
		spread (x, y + 1)
		mapnum (x) (y + 1) += 10
	    end if
	    if revealornot (x + 1) (y + 1) = false and x < dmx and y < dmy
		    then
		spread (x + 1, y + 1)
		mapnum (x + 1) (y + 1) += 10
	    end if
	    if revealornot (x - 1) (y - 1) = false and x > 1 and y > 1
		    then
		spread (x - 1, y - 1)
		mapnum (x - 1) (y - 1) += 10
	    end if
	    if revealornot (x - 1) (y + 1) = false and x > 1 and y < dmy
		    then
		spread (x - 1, y + 1)
		mapnum (x - 1) (y + 1) += 10
	    end if
	    if revealornot (x + 1) (y - 1) = false and x < dmx and y > 1
		    then
		spread (x + 1, y - 1)
		mapnum (x + 1) (y - 1) += 10
	    end if

	elsif mapnum (x) (y) = -1
		then
	    for i : 1 .. dmx
		for j : 1 .. dmy
		    if mapnum (i) (j) = -1
			    then
			revealBlock (i, j)
			drawBomb (i, j)

		    end if
		end for
	    end for

	    Draw.FillStar (25 + 20 * (x - 1) + 3, maxy - 45 - 20 * (y - 1) + 3, 25 + 20 * (x - 1) + 17, maxy - 45 - 20 * (y - 1) + 17, red)
	    Draw.FillStar (25 + 20 * (x - 1) + 17, maxy - 45 - 20 * (y - 1) + 17, 25 + 20 * (x - 1) + 3, maxy - 45 - 20 * (y - 1) + 3, red)
	    delay (500)

	    for i : 1 .. dmx
		for j : 1 .. dmy
		    if mapnum (i) (j) = -1
			    then
			Draw.FillStar (25 + 20 * (i - 1) + 3, maxy - 45 - 20 * (j - 1) + 3, 25 + 20 * (i - 1) + 17, maxy - 45 - 20 * (j - 1) + 17, red)
			Draw.FillStar (25 + 20 * (i - 1) + 17, maxy - 45 - 20 * (j - 1) + 17, 25 + 20 * (i - 1) + 3, maxy - 45 - 20 * (j - 1) + 3, red)
			if revealornot (i) (j) = true
				then
			    bombcount += 1
			    drawFlag (i, j)
			end if

			Mouse.Where (posx, posy, button)
			delay (10)
		    end if
		    exit when button = 100
		end for
		exit when button = 100
	    end for
	    gameover := true

	end if
    end if
end spread

%The procedure checkBomb checks if the block has bomb.
function checkBomb (x, y : int) : boolean
    var num : int := 0
    if revealornot (x - 1) (y) = true and x > 1 and mapnum (x - 1) (y) < 10
	    then
	num += 1
    end if
    if revealornot (x + 1) (y) = true and x < dmx and mapnum (x + 1) (y) < 10
	    then
	num += 1
    end if
    if revealornot (x) (y - 1) = true and y > 1 and mapnum (x) (y - 1) < 10
	    then
	num += 1
    end if
    if revealornot (x) (y + 1) = true and y < dmy and mapnum (x) (y + 1) < 10
	    then
	num += 1
    end if
    if revealornot (x - 1) (y - 1) = true and x > 1 and y > 1 and mapnum (x - 1) (y - 1) < 10
	    then
	num += 1
    end if
    if revealornot (x + 1) (y + 1) = true and x < dmx and y < dmy and mapnum (x + 1) (y + 1) < 10
	    then
	num += 1
    end if
    if revealornot (x + 1) (y - 1) = true and x < dmx and y > 1 and mapnum (x + 1) (y - 1) < 10
	    then
	num += 1
    end if
    if revealornot (x - 1) (y + 1) = true and x > 1 and y < dmy and mapnum (x - 1) (y + 1) < 10
	    then
	num += 1
    end if

    if mapnum (x) (y) mod 10 = num
	    then
	result true
    else
	result false
    end if
end checkBomb

%The procedure spaceAndRight checks the block arround and reveal them.
procedure spaceAndRight (x, y : int)
    if revealornot (x - 1) (y) = false and x > 1
	    then
	revealBlock (x - 1, y)
    end if
    if revealornot (x + 1) (y) = false and x < dmx
	    then
	revealBlock (x + 1, y)
    end if
    if revealornot (x) (y - 1) = false and y > 1
	    then
	revealBlock (x, y - 1)
    end if
    if revealornot (x) (y + 1) = false and y < dmy
	    then
	revealBlock (x, y + 1)
    end if
    if revealornot (x - 1) (y - 1) = false and x > 1 and y > 1
	    then
	revealBlock (x - 1, y - 1)
    end if
    if revealornot (x + 1) (y + 1) = false and x < dmx and y < dmy
	    then
	revealBlock (x + 1, y + 1)
    end if
    if revealornot (x + 1) (y - 1) = false and x < dmx and y > 1
	    then
	revealBlock (x + 1, y - 1)
    end if
    if revealornot (x - 1) (y + 1) = false and x > 1 and y < dmy
	    then
	revealBlock (x - 1, y + 1)
    end if

    loop
	pressandrelease ()
	exit when button = 0
    end loop

    if checkBomb (x, y) = true
	    then
	if revealornot (x - 1) (y) = false and x > 1 and mapnum (x - 1) (y) < 10
		then
	    spread (x - 1, y)
	end if
	if revealornot (x + 1) (y) = false and x < dmx and mapnum (x + 1) (y) < 10
		then
	    spread (x + 1, y)
	end if
	if revealornot (x) (y - 1) = false and y > 1 and mapnum (x) (y - 1) < 10
		then
	    spread (x, y - 1)
	end if
	if revealornot (x) (y + 1) = false and y < dmy and mapnum (x) (y + 1) < 10
		then
	    spread (x, y + 1)
	end if
	if revealornot (x - 1) (y - 1) = false and x > 1 and y > 1 and mapnum (x - 1) (y - 1) < 10
		then
	    spread (x - 1, y - 1)
	end if
	if revealornot (x + 1) (y + 1) = false and x < dmx and y < dmy and mapnum (x + 1) (y + 1) < 10
		then
	    spread (x + 1, y + 1)
	end if
	if revealornot (x + 1) (y - 1) = false and x < dmx and y > 1 and mapnum (x + 1) (y - 1) < 10
		then
	    spread (x + 1, y - 1)
	end if
	if revealornot (x - 1) (y + 1) = false and x > 1 and y < dmy and mapnum (x - 1) (y + 1) < 10
		then
	    spread (x - 1, y + 1)
	end if

    else
	if revealornot (x - 1) (y) = false and x > 1
		then
	    notRevealBlock (x - 1, y)
	end if
	if revealornot (x + 1) (y) = false and x < dmx
		then
	    notRevealBlock (x + 1, y)
	end if
	if revealornot (x) (y - 1) = false and y > 1
		then
	    notRevealBlock (x, y - 1)
	end if
	if revealornot (x) (y + 1) = false and y < dmy
		then
	    notRevealBlock (x, y + 1)
	end if
	if revealornot (x - 1) (y - 1) = false and x > 1 and y > 1
		then
	    notRevealBlock (x - 1, y - 1)
	end if
	if revealornot (x + 1) (y + 1) = false and x < dmx and y < dmy
		then
	    notRevealBlock (x + 1, y + 1)
	end if
	if revealornot (x + 1) (y - 1) = false and x < dmx and y > 1
		then
	    notRevealBlock (x + 1, y - 1)
	end if
	if revealornot (x - 1) (y + 1) = false and x > 1 and y < dmy
		then
	    notRevealBlock (x - 1, y + 1)
	end if
    end if
end spaceAndRight



%%%%% MAIN CODE %%%%%

open : output, "MinesweeperScore.txt", put
Mouse.ButtonChoose ("multibutton")
put : output, "Times of Play" : 20, "Map Dimension" : 20, "Click Count" : 20, "Count Reveal" : 20, "Mine Revealed" : 20
put : output, repeat ("*", 93)
menu ()

loop
    looptime += 1
    setupgame (dmx, dmy, m)

    loop
	exit when gameover = true
	exit when win = true

	loop
	    press ()
	    exit when posx > 25 and posy > 25 and posx < dmx * 20 + 25 and posy < dmy * 20 + 25
	end loop

	clickcount += 1
	Input.KeyDown (reveal)

	if reveal (' ')
		then
	    if revealornot (col) (row) = true and button = 3 and mapnum (col) (row) > 9
		    then
		spaceAndRight (col, row)
	    elsif revealornot (col) (row) = false and button = 1
		    then
		spread (col, row)
	    end if

	elsif not (reveal (' ')) and mapnum (col) (row) < 10
		then
	    if revealornot (col) (row) = false and button = 1
		    then
		revealornot (col) (row) := true
		drawFlag (col, row)
	    elsif revealornot (col) (row) = true and button = 3
		    then
		revealornot (col) (row) := false
		notRevealBlock (col, row)
	    end if

	end if
	countreveal := 0
	for i : 1 .. dmx
	    for j : 1 .. dmy
		if revealornot (i) (j) = true
			then
		    countreveal += 1
		end if
	    end for
	end for
	if countreveal = dmx * dmy
		then
	    win := true
	    for i : 1 .. dmx
		for j : 1 .. dmy
		    if mapnum (i) (j) = -1
			    then
			bombcount += 1
		    end if
		end for
	    end for

	end if

    end loop
    delay (300)
    put : output, intstr (looptime) : 20, (intstr (dmx) + "*" + intstr (dmy)) : 20, intstr (clickcount) : 20, intstr (countreveal) : 20, intstr (bombcount), " out of ", intstr (m) : 20
    gameOver ()
end loop




