Write-Host "************************************************************************************"
Write-Host "Starting Capture" -ForegroundColor Yellow
Write-Host "************************************************************************************"
nltest /dbflag:0x2080ffff
Write-Host "************************************************************************************"
Write-Host "Gathing login attempts" -ForegroundColor Yellow
Start-Sleep -Milliseconds 180000
Write-Host "************************************************************************************"
Write-Host "Ending Catpure" -ForegroundColor Yellow
Write-Host "************************************************************************************"
nltest /dbflag:0x0
Write-Host "************************************************************************************"
Write-Host "Done!" -ForegroundColor Yellow
Write-Host "************************************************************************************"
Write-Host "Review login Attempts" -ForegroundColor Yellow
Write-Host "************************************************************************************"
Get-Content c:\windows\debug\netlogon.log