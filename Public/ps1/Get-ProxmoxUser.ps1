function Get-ProxmoxUser {

    [CmdletBinding()]
    Param (
        [Parameter(Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $UserID
    )
    begin { 

        if ($SkipProxmoxCertificateCheck) {
            
            if ($PSVersionTable.PSEdition -ne 'Core') {
                Disable-CertificateValidation # Custom function to bypass X.509 cert checks
            }
            else {
                $NoCertCheckPSCore = $true
            }
        
        }

    }
    process {

        if ($UserID) {
            
            $UserID | ForEach-Object {

                try {

                    if ($NoCertCheckPSCore) {
                        Invoke-RestMethod `
                        -Method Get `
                        -Uri ($proxmoxApiBaseUri.AbsoluteUri + "access/users/$_") `
                        -SkipCertificateCheck `
                        -WebSession $ProxmoxWebSession | Select-Object -ExpandProperty data    
                    }
                    else {
                        Invoke-RestMethod `
                        -Method Get `
                        -Uri ($proxmoxApiBaseUri.AbsoluteUri + "access/users/$_") `
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
                    -Uri ($proxmoxApiBaseUri.AbsoluteUri + 'access/users') `
                    -SkipCertificateCheck `
                    -WebSession $ProxmoxWebSession | Select-Object -ExpandProperty data    
                }
                else {
                    Invoke-RestMethod `
                    -Method Get `
                    -Uri ($proxmoxApiBaseUri.AbsoluteUri + 'access/users') `
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