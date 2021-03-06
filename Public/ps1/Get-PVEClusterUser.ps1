function Get-PVEClusterUser {

    [CmdletBinding()]
    [Alias('gpvecuser')]
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
                    Write-Error -Exception $_.Exception
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
