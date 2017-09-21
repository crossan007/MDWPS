<#
    .SYNOPSIS
        Handler for invoking and registring the window location manager




#>


[CmdletBinding()]
param(
    [String]
    $ConfigFile ="$PSScriptRoot\WindowConfigs.json",
    [Switch]
    $DumpWindows,
    [Switch]
    $ApplyConfig
)
#region Import Modules

    Import-Module "$PSScriptRoot\Set-Window.psm1"

#endregion

if ($DumpWindows)
{
    $Processes = Get-Process | Where-Object {-not [String]::IsNullOrEmpty($_.MainWindowTitle)}
    $WindowConfigs = @()
    Foreach($Process in $Processes)
    {
        $ThisWindow = New-Object -TypeName PSObject
        $ThisWindow |Add-Member -MemberType NoteProperty -Name ProcessName -Value $($Process.Name)
        $ThisWindow |Add-Member -MemberType NoteProperty -Name WindowTitle -Value $($Process.MainWindowTitle)
        $ThisWindow |Add-Member -MemberType NoteProperty -Name Top -Value 0
        $ThisWindow |Add-Member -MemberType NoteProperty -Name Left -Value 0
        $ThisWindow |Add-Member -MemberType NoteProperty -Name Width -Value 0
        $ThisWindow |Add-Member -MemberType NoteProperty -Name Height -Value 0
        $WindowConfigs += $ThisWindow
        
    }
    $WindowConfigs | ConvertTo-Json | Out-File -FilePath $ConfigFile
}
elseif ($ApplyConfig)
{
    $RunningProcesses = Get-Process
    $Config = Get-Content -Path $ConfigFile | ConvertFrom-Json
    Foreach($WindowConfig in $Config)
    {
        Write-Host "Attempting window update for: $($WindowConfig.MainWindowTitle)"
        $ThisWindowProcess = $RunningProcesses | Where-Object{ $_.MainWindowTitle -eq $WindowConfig.MainWindowTitle}
        If( $ThisWindowProcess )
        {
            Write-Host "Process found: $($ThisWindowProcess.MainWindowHandle)"
            Set-Window -MainWindowHandle $($ThisWindowProcess.MainWindowHandle) -X $($WindowConfig.X) -Y $($WindowConfig.Y) -Width $($WindowConfig.Width) -Height $($WindowConfig.Height)
        }
        else {
            Throw "Could not find active window for: $($WindowConfig.MainWindowTitle)"
        }
    }


}