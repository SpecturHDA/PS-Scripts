$AccepctedDomain = Get-AcceptedDomain | Select -ExpandProperty name
$linecounter = 1
foreach($Domain in $AccepctedDomain){
Write-Host($linecounter.ToString() + ". " + $Domain)
    $linecounter++
}
Write-host "`r`n"
$Domain = $AccepctedDomain[[int](Read-Host -Prompt "The Public folder user needs access to (i.e. 1,2,or3)")-1]
$Domain