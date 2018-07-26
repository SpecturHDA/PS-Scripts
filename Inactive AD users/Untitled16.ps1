$Groups = Get-ADGroup -Filter * -SearchBase 'OU=Groups,OU=IFFG,DC=iffg,DC=local' | Select name

$Results = foreach( $Group in $Groups ){

    Get-ADGroupMember -identity "$Group" | Select-Object -ExpandProperty name 
    
    #| get-aduser -fliter * | Where {$_.Enabled -eq $true} | format-table name, samaccountname -autosize 

        #[pscustomobject]@{

         #   GroupName = $Group.Name

          #  Name = $_.Name

            }
$Results 

#| Export-Csv -Path c:\temp\groups.csv -NoTypeInformation