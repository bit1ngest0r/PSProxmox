function Get-PVEClusterStorage {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    [Alias('gpvecstorage')]
    Param (
        [Parameter(ParameterSetName = 'All')]
        [Switch]
        $All,
        
        [Parameter(ParameterSetName = 'Type')]
        [ValidateSet('cephfs', 'cifs', 'dir', 'drbd', 'glusterfs', 'iscsi', 'iscsidirect', 'lvm', 'lvmthin', 'nfs', 'pbs', 'rbd', 'zfs', 'zfspool')]
        [String]
        $Type,

        [Parameter(ParameterSetName = 'Name')]
        [String]
        $StorageId
    )
    begin {

        $body = @{}
        if ($PSBoundParameters['Type']) { $body.Add('type', $PSBoundParameters['Type']) }

    }
    process {

        if ($StorageId) {

            $StorageId | ForEach-Object {

                try {
                    Send-PveApiRequest -Method Get -Uri (($ProxmoxApiBaseUri.AbsoluteUri + 'storage/'+ $_)) | Select-Object -ExpandProperty data
                }
                catch {
                    Write-Error -Exception $_.Exception
                }        

            }

        }
        else {

            try {
                Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + 'storage') -Body $body | Select-Object -ExpandProperty data
            }
            catch {
                throw $_.Exception
            }

        }

    }

}
