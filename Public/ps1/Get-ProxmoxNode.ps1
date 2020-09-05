function Get-ProxmoxNode {

    [CmdletBinding()]
    Param ()
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

        try {

            if ($NoCertCheckPSCore) {
                Invoke-RestMethod `
                -Method Get `
                -Uri ($proxmoxApiBaseUri.AbsoluteUri + 'nodes') `
                -SkipCertificateCheck `
                -WebSession $ProxmoxWebSession | Select-Object -ExpandProperty data
            }
            else {
                Invoke-RestMethod `
                -Method Get `
                -Uri ($proxmoxApiBaseUri.AbsoluteUri + 'nodes') `
                -WebSession $ProxmoxWebSession | Select-Object -ExpandProperty data    
            }
            
        }
        catch {

            throw $_.Exception

        }

    }
    end { if ($SkipProxmoxCertificateCheck -and -not $NoCertCheckPSCore) { Enable-CertificateValidation } }

}