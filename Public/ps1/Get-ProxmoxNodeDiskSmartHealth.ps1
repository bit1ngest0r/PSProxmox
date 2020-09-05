function Get-ProxmoxNodeDiskSmartHealth {

    [CmdletBinding()]
    Param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [PSObject[]]
        $ProxmoxNode,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $BlockDeviceName,

        [Parameter()]
        [Switch]
        $HealthOnly
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
        $body = @{}
        if ($PSBoundParameters['HealthOnly']) { $body.Add('healthonly', $true) }

    }
    process {

        $ProxmoxNode | ForEach-Object {
            
            $uri = $proxmoxApiBaseUri.AbsoluteUri + "nodes/$($_.node)/disks/smart"
            $BlockDeviceName | ForEach-Object {

                $body = @{}
                $body.Add('disk', $_)
                try {
                    
                    if ($NoCertCheckPSCore) { # PS Core client                    
                        Invoke-RestMethod `
                        -Method Get `
                        -Uri $uri `
                        -Body $body `
                        -SkipCertificateCheck `
                        -WebSession $ProxmoxWebSession | Select-Object -ExpandProperty data    
                    }
                    else { # PS Desktop client
                        Invoke-RestMethod `
                        -Method Get `
                        -Uri $uri `
                        -Body $body `
                        -WebSession $ProxmoxWebSession | Select-Object -ExpandProperty data
                    }
                    
                }
                catch {

                    throw $_.Exception

                }

            }

        }

    }
    end { if ($SkipProxmoxCertificateCheck -and -not $NoCertCheckPSCore) { Enable-CertificateValidation } }

}