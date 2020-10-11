
<#
    .SYNOPSIS
        Bootstraps a fresh Windows install for scripted install
    .DESCRIPTION
       Removes any prexisting connector of the same name and then adds the new one.  If removal is needed, you will be prompted to OK it. 

    .PARAMETER Hostname
        The desired hostname for the computer
    
    .EXAMPLE
		bootstrap.ps1 -Hostname mydevbox1
		# Installs the necessary packages, sets hostmane to mydevbox1, and reboots

		bootstrap.ps1
		# User is prompted for a hostname Installs the necessary packages, sets hostmane to whatever the user entered, and reboots
    #>


    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$false)]
        [string]$Hostname = (Read-Host "Enter desired Hostname: "),

        [Parameter(Mandatory=$false)]
        [string]$DomainToJoin

	)


	Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
	CINST Boxstarter -y
    CINST GIT -y

    git clone https://github.com/neurongaragesale/boxconfig.git c:\boxconfig

    Write-Warning "Remember kids, if you are planing on running containers nested in Hyper-V, Shutdown this box after the reboot and run set-VMforhyper-v.ps1, or you are gonna have a bad time "

    if([string]::IsNullOrEmpty($DomainToJoin)){
        if ($env:computername -ne $Hostname) {
            Rename-Computer -NewName $Hostname
            Write-Host "Press Any key to reboot your machine" -ForegroundColor Green
        }
    }
    else{
        $username = Read-Host "Domain UserName: "
        add-computer -ComputerName $Hostname -DomainName $DomainToJoin -Credential $username -Restart -Force
    }


	
	
