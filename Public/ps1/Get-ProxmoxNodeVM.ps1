function Get-ProxmoxNodeVM {

    [CmdletBinding()]
    Param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [PSObject[]]
        $ProxmoxNode,

        [Parameter(Position = 1)]
        [Int[]]
        $VMID
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

        $ProxmoxNode | ForEach-Object {
            
            $node = $_
            if ($VMID) {

                $VMID | ForEach-Object {
                    
                    try {

                        if ($NoCertCheckPSCore) {
                            Invoke-RestMethod `
                            -Method Get `
                            -Uri ($proxmoxApiBaseUri.AbsoluteUri + "nodes/$($node.node)/qemu/$_/status/current") `
                            -SkipCertificateCheck `
                            -WebSession $ProxmoxWebSession | Select-Object -ExpandProperty data
                        }
                        else {
                            Invoke-RestMethod `
                            -Method Get `
                            -Uri ($proxmoxApiBaseUri.AbsoluteUri + "nodes/$($node.node)/qemu/$_/status/current") `
                            -WebSession $ProxmoxWebSession | Select-Object -ExpandProperty data
                        }
                        
                    }
                    catch {
        
                        Write-Error -Exception $_.Exception
        
                    }    

                }

            }
            else {

                try {

                    if ($NoCertCheckPSCore) {
                        Invoke-RestMethod `
                        -Method Get `
                        -Uri ($proxmoxApiBaseUri.AbsoluteUri + "nodes/$($node.node)/qemu") `
                        -SkipCertificateCheck `
                        -WebSession $ProxmoxWebSession | Select-Object -ExpandProperty data
                    }
                    else {
                        Invoke-RestMethod `
                        -Method Get `
                        -Uri ($proxmoxApiBaseUri.AbsoluteUri + "nodes/$($node.node)/qemu") `
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