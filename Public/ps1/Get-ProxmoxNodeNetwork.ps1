
function Get-ProxmoxNodeNetwork {

    [CmdletBinding(DefaultParameterSetName = 'Default')]
    Param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ParameterSetName = 'Type'
        )]
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ParameterSetName = 'Interface'
        )]
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ParameterSetName = 'Default'
        )]
        [PSObject[]]
        $ProxmoxNode,

        [Parameter(ParameterSetName = 'Type')]
        [ValidateSet('alias', 'any_bridge', 'bond', 'bridge', 'eth', 'OVSBond', 'OVSBridge', 'OVSIntPort', 'OVSPort', 'vlan')]
        [String]
        $Type,

        [Parameter(ParameterSetName = 'Interface')]
        [ValidateNotNullOrEmpty()]
        [String]
        $InterfaceName
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
        if ($PSBoundParameters['Type']) { $body.Add('type', $PSBoundParameters['Type']) }

    }
    process {

        $ProxmoxNode | ForEach-Object {
            
            $uri = $proxmoxApiBaseUri.AbsoluteUri + "nodes/$($_.node)/network"
            if ($InterfaceName) {

                $InterfaceName | ForEach-Object {
                    
                    $uri = $uri + '/' + $_
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
            else {

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

    }
    end { if ($SkipProxmoxCertificateCheck -and -not $NoCertCheckPSCore) { Enable-CertificateValidation } }

}