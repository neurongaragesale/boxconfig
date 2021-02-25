
#region Package Variables

$windowsGeneric = "https://gist.githubusercontent.com/neurongaragesale/a7616c121560ac8badf98b703368b881/raw/3d05bb301ebf3bae2443aee3f50f15c7867a7377/boxstarter-generic-windows.txt"
$developerBase = "https://gist.githubusercontent.com/neurongaragesale/8580e8766b19c253c517f6ff67537d8b/raw/5e8888820bb1b27de7857ff049c086b1422d1a9c/boxstarter-windows-dev-base.txt"
$developerDocker = "https://gist.githubusercontent.com/neurongaragesale/0603afa48c49bad37abd3e5a21cb7889/raw/8507461f2ffd284bc5f9d87049153bde69643eb9/boxstarter-windows-dev-docker"
$cieWindows = "https://gist.githubusercontent.com/neurongaragesale/b0ef496e1f14a445e42116eadcc0232c/raw/903f2c22d18c67c44968fe40c6af28aa7de55cde/boxstarter-cie-windows.txt"

#endregion



function Get-AvailablePackages{

    Write-Host "Generic-Windows: Used for base windows config"
    Write-Host "Developer-Base: used for general development"
    Write-Host "Developer-Docker: used for developing solutions in docker"
    Write-Host "CIE-Windows: Used for int servers"
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
        Default {
            Write-Error "Unknown config"
        }
    }
    
}


Export-ModuleMember Get-AvailablePackages, Set-MachineConfig