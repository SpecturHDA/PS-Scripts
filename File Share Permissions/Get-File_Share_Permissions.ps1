Get-ChildItem .\ | where-object {($_.PsIsContainer)} | Get-ACL | Format-List
Get-Acl C:\Windows | Get-Member -MemberType *Property
#Get-ChildItem .\Windows -Recurse | where-object {($_.PsIsContainer)} | Get-ACL | Format-List
Get-ChildItem .\Windows -Recurse | where-object {($_.PsIsContainer)} | Get-ACL | Format-List | Out-File C:\Permissions.csv