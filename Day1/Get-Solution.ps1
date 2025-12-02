param (
    [string]$InputFilePath = "$($PSScriptRoot)\Input\Data.txt",
    [switch]$KeyPressOnLoop
)

$data = Get-Content $InputFilePath

$TargetPosition = 0
$TargetPositionCounter = 0
Write-Output "Target Position to reach: $TargetPosition"

Write-Output "Starting to process input data ($($data.Count) lines..."
$lineCount = 0

# Starting position is 50
$currentPosition = 50

foreach ($line in $data) {
    $lineCount++

    $direction = $line.Substring(0,1)
    $movement = [int]$line.Substring(1, $line.Length - 1)

    $multiplier = switch ($direction) {
        'L' { -1 }
        'R' { 1 }
        default { throw "Unknown direction: $direction" }
    }

    $movementSigned = $multiplier * $movement
    $newPosition = $currentPosition + $movementSigned
    Write-Output "Line $($lineCount): Line = $line, Direction = $direction, Movement = $movement, Signed Movement = $movementSigned, Current Position = $currentPosition, New Position = $newPosition"

    $currentPosition = $newPosition

    while ($currentPosition -lt 0) {
        Write-Output "Wrapping around from $currentPosition to $($currentPosition + 100)"
        $currentPosition += 100
    }

    while ($currentPosition -gt 99) {
        Write-Output "Wrapping around from $currentPosition to $($currentPosition - 100)"
        $currentPosition -= 100
    }

    if($currentPosition -eq $TargetPosition) {
        Write-Output "Reached position $TargetPosition after $lineCount lines."
        $TargetPositionCounter++
    }

    # Process each line of the input data
    if($lineCount % 100 -eq 0) {
        Write-Output "Processed $lineCount lines..."
    }

    if($KeyPressOnLoop.ToBool()) {
        [System.Console]::ReadKey($true) | out-null
    }
}

Write-Output "Completed processing $lineCount lines..."
Write-Output "Final Position: $currentPosition"
Write-Output "Reached Target Position: $TargetPosition ($TargetPositionCounter times)"

