function Get-PVEClusterUser {

    [CmdletBinding()]
    Param (
        [Parameter(Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $UserID
    )
    process {

        if ($UserID) {
            
            $UserID | ForEach-Object {

                try {
                    Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + 'access/users/' + $_) | Select-Object -ExpandProperty data
                }
                catch {
                    $_ | Write-Error
                }

            }

        }
        else {

            try {
                Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + 'access/users') | Select-Object -ExpandProperty data
            }
            catch {
                throw $_.Exception
            }

        }

    }

}
