function Get-PVENodeVersion {

    [CmdletBinding()]
    Param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [ProxmoxNode[]]
        $ProxmoxNode
    )
    begin { 

        try { Confirm-PveApiConnection }
        catch { throw $_ }

        if ($SkipProxmoxCertificateCheck) {            
            if ($PSVersionTable.PSEdition -ne 'Core') { Disable-CertificateValidation } # Custom function to bypass X.509 cert checks
            else { $NoCertCheckPSCore = $true }        
        }

    }
    process {

        $ProxmoxNode | ForEach-Object {
            
            $uri = $proxmoxApiBaseUri.AbsoluteUri + "nodes/$($_.node)/version"
            try {
                
                if ($NoCertCheckPSCore) { # PS Core client                    
                    Invoke-RestMethod `
                    -Method Get `
                    -Uri $uri `
                    -SkipCertificateCheck `
                    -WebSession $ProxmoxWebSession | Select-Object -ExpandProperty data    
                }
                else { # PS Desktop client
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
