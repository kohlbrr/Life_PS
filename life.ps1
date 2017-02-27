<#
    Name: life.ps1
    Author: Richard Kohlbrecher
    Created: 2/27/2017

    PowerShell implementation of Conway's Game of Life.

    The functions allow the game to be ran and displayed in the PowerShell
    console, and the code below the functions is a way to run the GoL for
    101 generations (from gen0 initialization to gen100).
#>

function getElementAt($state, $row, $col) {
<#
    Returns the value of data stored in '$state' at coordiates
    '[$row][$col]', unless the coordinates are out of bounds of the
    array. If they are out of bounds, return '0'.

    This is used to gather neighboring cell values for the 'nextState'
    function.
#>
    if(($row -lt 0) -or
     ($row -ge $state.Length) -or
     ($col -lt 0) -or
     ($col -ge $state[0].Length)) {
        return 0
    }
    else {
        $element += $state[$row][$col]
        return $element
    }
}

function randomState($rows, $cols) {
<#
    Returns a '$state' array.

    Generates a random '$state' array.
#>
    for($i = 0; $i -lt $rows; $i = $i + 1) {
        $row = $NULL
        for($j = 0; $j -lt $cols; $j = $j + 1) {
            $element = (Get-Random 2)
            $row += ,$element
        }
        $newState += ,$row
    }
    return $newState
}

function nextState($state) {
<#
    Returns a new '$state' array, based off of the input '$state' array.

    Rules for new state:
        If a cell has less than two '1' neighbors, that cell becomes '0'
        If a cell has exactly two '1' neighbors, that cell does not change
        If a cell has exactly three '1' neighbors, that cell becomes '1'
        If a cell has more than three neighbors, that cell becomes '0'
#>
    for($i = 0; $i -lt $state.Length; $i = $i + 1) {
        $row = $NULL
        for($j = 0; $j -lt $state[0].Length; $j = $j + 1) {
            $neighbors -= getElementAt $state $i $j
            for($di = $i - 1; $di -lt $i + 2; $di = $di + 1) {
                for($dj = $j - 1; $dj -lt $j + 2; $dj = $dj + 1) {
                    $neighbors += getElementAt $state $di $dj
                }
            }
            $element = $NULL
            if($neighbors -lt 2) { $element = 0 }
            elseif($neighbors -eq 2) { $element = $state[$i][$j] }
            elseif($neighbors -eq 3) { $element = 1 }
            else { $element = 0 }
            $row += ,$element
            $neighbors = $NULL
        }
        $newState += ,$row
    }
    return $newState
}

function drawState($state) {
<#
    Returns a string array that "draws" the state of the input
    '$state' array. That wasn't a confusing sentence in the least.
#>
    for($i = 0; $i -lt $state.Length; $i = $i + 1) {
        for($j = 0; $j -lt $state[1].Length; $j = $j + 1) {
            if($state[$i][$j] -eq 1) {
                $grid += '#'
            }
            else {
                $grid += ' '
            }
        }
        $grid += "`n"
    }
    Write-Host $grid
}

<#
    Using a randomly generated 40x40 state from 'randomState', the
    below will calculate and display the initial and next 100 states
    of the array using Conway's rules as implemented by 'nextState'.
#>
$gameState = randomState 40 40
$i = 0
Clear-Host
drawState($gameState)
Write-Host "Generation $i"
for($i = 1; $i -le 100; $i = $i + 1) {
    $gameState = nextState $gameState
    Clear-Host
    drawState $gameState
    Write-Host "Generation $i"
}