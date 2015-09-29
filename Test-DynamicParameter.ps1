#requires -version 5

using namespace system.management.automation

function Test-DynamicParameter 
{
    [cmdletBinding()]
    param(
       [switch]$Remote
    )

    DynamicParam {

    if($Remote.IsPresent)
    {
       $dict = [RuntimeDefinedParameterDictionary]::new()
       $attr = [Collections.ObjectModel.Collection[Attribute]]::new()

       $params = [parameter]::new()
       $params.Mandatory = $true
       $params.HelpMessage = 'Enter computer name or ip address'

       $attr.Add($params)

       $validValues = [ValidateSetAttribute]::new(
           ((get-content "$home\desktop\computers.txt") -match '^\S' -split '\s+')
       )
       $attr.Add($validValues)
       
       $def = [RuntimeDefinedParameter]::new('ComputerName',[string],$attr)
       $dict.Add('ComputerName', $def)  

       # gps
    
       return $dict
     }
    }

    End {
       if($PSBoundParameters.computername)
       {
          "Remote Process...'$($PSBoundParameters.computername)'"
       }
       else
       {
          "Local Process..."
       }
    }
}