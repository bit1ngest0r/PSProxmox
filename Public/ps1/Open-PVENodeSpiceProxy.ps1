function Open-PVENodeSpiceProxy {

    [CmdletBinding()]
    [Alias('opvenspice')]
    Param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [ProxmoxNode]
        $ProxmoxNode,

        [Parameter(
            Mandatory = $true,
            Position = 1
        )]
        [Int]
        $VMID,

        [Parameter(
            Mandatory = $true,
            Position = 2
        )]
        [ValidateNotNullOrEmpty()]
        [String]
        $OutFilePath,

        [Parameter(Position = 3)]
        [ValidateNotNullOrEmpty()]
        [String]
        $SpiceProxy = $ProxmoxApiBaseUri.Host
    )
    process {

        $body = @{proxy = $SpiceProxy}
        try {
            $spiceClientObject = Send-PveApiRequest -Method Post -Uri ($proxmoxApiBaseUri.AbsoluteUri + "nodes/$($ProxmoxNode.node)/qemu/$VMID/spiceproxy") -Body $body | 
            Select-Object -ExpandProperty data 

            # Array of strings that will form the virt-viewer INI key=value file
            [array]$content = '[virt-viewer]'
            $content += $spiceClientObject | Get-Member -MemberType NoteProperty | Sort-Object Name -Descending | # Form an array of strings in the format of key=value
            ForEach-Object { $name = $_.Name ; $name + '=' + $spiceClientObject.$name }
            $file = New-Item -ItemType File -Path $OutFilePath -Force -ErrorAction Stop      
            $content | Out-File $file.FullName -Encoding ascii -Force -ErrorAction Stop
            
            Start-Job -ScriptBlock {Invoke-Item $args} -ArgumentList $file.FullName | Out-Null
        }
        catch {
            throw $_.Exception
        }

    }

}
