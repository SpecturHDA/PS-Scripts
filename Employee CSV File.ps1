$firstname = (Read-Host -Prompt "First Name")
$lastname = (Read-Host -Prompt "Last Name")
$fullname = $firstname + " " + $lastname

Add-Content -Path C:\Employees.csv  -Value '"FirstName","LastName","FullName "'

  

  $employees = @(

  '"Adam","Bertram","abertram"'

  '"Joe","Jones","jjones"'

  '"Mary","Baker","mbaker"'

  )

  $employees | foreach { Add-Content -Path  C:\Employees.csv -Value $_ }