#https://msdn.microsoft.com/en-us/library/windows/desktop/ff468919(v=vs.85).aspx
Add-Type -AssemblyName System.Windows.Forms
Import-Module "$PSSCRIPTROOT\Set-Window.psm1" -force -verbose
Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class Tricks {
        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool SetForegroundWindow(IntPtr hWnd);
    }
"@

$Monitors = [system.windows.forms.screen]::AllScreens     

If ($Monitors.count -ge 2)
{
    $tbHeight = 50

    $mi=0
    $p= Get-Process "FileMaker Pro" 
    $x= $Monitors[$mi].bounds.x + $($Monitors[$mi].bounds.width/2)
    $y= $Monitors[$mi].bounds.y
    $h= $Monitors[$mi].bounds.height -$tbHeight
    $w= $Monitors[$mi].bounds.width /2
    $p.MainWindowHandle | Set-Window -X $x -y $y  -Height $h  -Width $w
    [tricks]::SetForegroundWindow($p.MainWindowHandle)

    $mi=0
    $p= Get-Process "Outlook" 
    $x= $Monitors[$mi].bounds.x
    $y= $Monitors[$mi].bounds.y
    $h= $Monitors[$mi].bounds.height -$tbHeight
    $w= $Monitors[$mi].bounds.width /2
    $p.MainWindowHandle | Set-Window -X $x -y $y  -Height $h  -Width $w
    [tricks]::SetForegroundWindow($p.MainWindowHandle)

    $mi=2
    $p= Get-Process "Chrome" | ?{$_.MainWindowTitle} 
    $x= $Monitors[$mi].bounds.x
    $y= $Monitors[$mi].bounds.y
    $h= $Monitors[$mi].bounds.height -$tbHeight
    $w= $Monitors[$mi].bounds.width /2
    $p.MainWindowHandle | Set-Window -X $x -y $y  -Height $h  -Width $w
    [tricks]::SetForegroundWindow($p.MainWindowHandle)

    $mi=2
    $p= Get-Process "FireFox" | ?{$_.MainWindowTitle} 
    $x= $($Monitors[$mi].bounds.x + [int]$($Monitors[$mi].bounds.width/2)) 
    $y= $Monitors[$mi].bounds.y
    $h=($($Monitors[$mi].bounds.height -$tbHeight )/2)
    $w= $($Monitors[$mi].bounds.width/2)
    $p.MainWindowHandle | Set-Window -X $x -y $y  -Height $h  -Width $w
    [tricks]::SetForegroundWindow($p.MainWindowHandle)

    $mi=2
    $p= Get-Process "Iexplore" | ?{$_.MainWindowTitle} 
    $x= $($Monitors[$mi].bounds.x + [int]$($Monitors[$mi].bounds.width/2)) 
    $y= $Monitors[$mi].bounds.y + ($($Monitors[$mi].bounds.height)/2)
    $h=($($Monitors[$mi].bounds.height -$tbHeight)/2)
    $w= $($Monitors[$mi].bounds.width/2)
    $p.MainWindowHandle | Set-Window -X $x -y $y  -Height $h  -Width $w
    [tricks]::SetForegroundWindow($p.MainWindowHandle)

     $mi=1
    $p= Get-Process "RemoteDesktopManager" | ?{$_.MainWindowTitle} 
    $x= $Monitors[$mi].bounds.x
    $y= $Monitors[$mi].bounds.y 
    $h= $Monitors[$mi].bounds.height -$tbHeight
    $w= $($Monitors[$mi].bounds.width/2)
    $p.MainWindowHandle | Set-Window -X $x -y $y  -Height $h  -Width $w
    [tricks]::SetForegroundWindow($p.MainWindowHandle)

     $mi=1
    $p= Get-Process "SPDesign" | ?{$_.MainWindowTitle} 
    $x= $($Monitors[$mi].bounds.x + $($Monitors[$mi].bounds.width/2) ) 
    $y= $Monitors[$mi].bounds.y 
    $h= $Monitors[$mi].bounds.height -$tbHeight
    $w= $($Monitors[$mi].bounds.width/2)
    $p.MainWindowHandle | Set-Window -X $x -y $y  -Height $h  -Width $w
    [tricks]::SetForegroundWindow($p.MainWindowHandle)


}