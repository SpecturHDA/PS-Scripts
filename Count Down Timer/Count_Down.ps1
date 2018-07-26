$x = 1 
$length = $x / 100
while($x -gt 0) {
  $min = [int](([string]($x/60)).split('.')[0])
  $text = " " + $min + " minutes " + ($x % 60) + " seconds left"
  Write-Progress "Waiting for Mailbox to be provisions" -status $text -perc ($x/$length)
  start-sleep -s 300
  $x--
}