#--------------------------------------------------------------------------------- 

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $TimeZone
    )

    #Get the current TimeZone
    $CurrentTimeZone = Invoke-Expression "tzutil.exe /g"

    $returnValue = @{
        TimeZone = $CurrentTimeZone
    }

    #Output the target resource
    $returnValue
}


function Set-TargetResource
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $TimeZone
    )
    
    #Output the result of Get-TargetResource function.
    $GetCurrentTimeZone = Get-TargetResource -TimeZone $TimeZone

    If($PSCmdlet.ShouldProcess("'$TimeZone'","Replace the System Time Zone"))
    {
        Try
        {
            Write-Verbose "Setting the TimeZone"
            Invoke-Expression "tzutil.exe /s ""$TimeZone"""
        }
        Catch
        {
            $ErrorMsg = $_.Exception.Message
            Write-Verbose $ErrorMsg
        }
    }
}


function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([Boolean])]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $TimeZone
    )

    #Output from Get-TargetResource
    $Get = Get-TargetResource -TimeZone $TimeZone

    If($TimeZone -eq $Get.TimeZone)
    {
        return $true
    }
    Else
    {
        return $false
    }
}

Export-ModuleMember -Function *-TargetResource


