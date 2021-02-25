
#region Package Variables

$windowsGeneric = "https://gist.githubusercontent.com/neurongaragesale/a7616c121560ac8badf98b703368b881/raw/3d05bb301ebf3bae2443aee3f50f15c7867a7377/boxstarter-generic-windows.txt"
$developerBase = "https://gist.githubusercontent.com/neurongaragesale/8580e8766b19c253c517f6ff67537d8b/raw/5e8888820bb1b27de7857ff049c086b1422d1a9c/boxstarter-windows-dev-base.txt"
$developerDocker = "https://gist.githubusercontent.com/neurongaragesale/0603afa48c49bad37abd3e5a21cb7889/raw/8507461f2ffd284bc5f9d87049153bde69643eb9/boxstarter-windows-dev-docker"
$cieWindows = "https://gist.githubusercontent.com/neurongaragesale/b0ef496e1f14a445e42116eadcc0232c/raw/903f2c22d18c67c44968fe40c6af28aa7de55cde/boxstarter-cie-windows.txt"
$gatsby = "https://gist.githubusercontent.com/neurongaragesale/e4a0747f75e8b103fce0e6a5bd0cd93a/raw/1d4c931d1ba47b648a2cc0a498b047cd101a7fcc/boxstarter-windows-gatsby.txt";

#endregion



function Get-AvailablePackages{

    Write-Host "Generic-Windows: Used for base windows config"
    Write-Host "Developer-Base: used for general development"
    Write-Host "Developer-Docker: used for developing solutions in docker"
    Write-Host "CIE-Windows: Used for int servers"
    Write-Host "Developer-Gatsby: Setup for developing with gatsby.js"
}

function Set-MachineConfig {
    param (
        [Parameter(Mandatory=$false)]
        $ConfigName
    )

    switch ($ConfigName) {
        "Generic-Windows" { Install-BoxstarterPackage -PackageName $windowsGeneric  }
        "Developer-Base" { Install-BoxstarterPackage -PackageName $developerBase  }
        "Developer-Docker" { Install-BoxstarterPackage -PackageName $developerDocker  }
        "CIE-Windows" { Install-BoxstarterPackage -PackageName $cieWindows  }
        "Developer-Gatsby" { Install-BoxstarterPackage -PackageName $gatsby  }
        Default {
            Write-Error "Unknown config"
        }
    }
}

function Install-NgsBootstrapper (){
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
}


Export-ModuleMember Get-AvailablePackages, Set-MachineConfig, Install-NgsBootstrapper