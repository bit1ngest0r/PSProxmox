function Confirm-ProxmoxApiConnection {

    [CmdletBinding()]
    Param ()
    process {

        if (-not $ProxmoxWebSession) {
            throw "User not authenticated to Proxmox API."
        }

        $uri = $proxmoxApiBaseUri.AbsoluteUri + 'version'
        try {

            if ($NoCertCheckPSCore) {
                Invoke-RestMethod `
                -Method Get `
                -Uri $uri `
                -SkipCertificateCheck `
                -WebSession $ProxmoxWebSession | Out-Null
            }
            else {
                Invoke-RestMethod `
                -Method Get `
                -Uri $uri `
                -WebSession $ProxmoxWebSession | Out-Null    
            }
            
        }
        catch {

            throw $_.Exception

        }

    }

}