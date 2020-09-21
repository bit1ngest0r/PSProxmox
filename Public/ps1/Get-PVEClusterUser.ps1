function Get-PVEClusterUser {

    [CmdletBinding()]
    Param (
        [Parameter(Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $UserID
    )
    begin { 

        try { Confirm-PveApiConnection }
        catch { throw $_ }

        if ($SkipProxmoxCertificateCheck) {            
            if ($PSVersionTable.PSEdition -ne 'Core') { Disable-CertificateValidation } # Custom function to bypass X.509 cert checks
            else { $NoCertCheckPSCore = $true }        
        }
        $uri = $proxmoxApiBaseUri.AbsoluteUri + 'access/users'

    }
    process {

        if ($UserID) {
            
            $UserID | ForEach-Object {

                $uri = $uri + '/' + $_
                try {

                    if ($NoCertCheckPSCore) {
                        Invoke-RestMethod `
                        -Method Get `
                        -Uri $uri `
                        -SkipCertificateCheck `
                        -WebSession $ProxmoxWebSession | Select-Object -ExpandProperty data    
                    }
                    else {
                        Invoke-RestMethod `
                        -Method Get `
                        -Uri $uri `
                        -WebSession $ProxmoxWebSession | Select-Object -ExpandProperty data    
                    }
                    
                }
                catch {

                    throw $_.Exception

                }

            }

        }
        else {

            try {

                if ($NoCertCheckPSCore) {
                    Invoke-RestMethod `
                    -Method Get `
                    -Uri $uri `
                    -SkipCertificateCheck `
                    -WebSession $ProxmoxWebSession | Select-Object -ExpandProperty data    
                }
                else {
                    Invoke-RestMethod `
                    -Method Get `
                    -Uri $uri `
                    -WebSession $ProxmoxWebSession | Select-Object -ExpandProperty data    
                }
                
            }
            catch {

                throw $_.Exception

            }

        }

    }
    end { if ($SkipProxmoxCertificateCheck -and -not $NoCertCheckPSCore) { Enable-CertificateValidation } }

}
