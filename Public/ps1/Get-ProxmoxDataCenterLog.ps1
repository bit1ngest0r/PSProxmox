function Get-ProxmoxDataCenterLog {

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
        $uri = $proxmoxApiBaseUri.AbsoluteUri + 'cluster/log'

    }
    process {

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
    end { if ($SkipProxmoxCertificateCheck -and -not $NoCertCheckPSCore) { Enable-CertificateValidation } }

}