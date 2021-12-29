#Requires -RunAsAdministrator

$Script:originalErrorAction = $ErrorActionPreference
$Script:originalLocation = Get-Location

function Script:Test-Command {
  param (
    [Parameter(Mandatory = $true)]
    [string]
    $Command
  )
  $ErrorActionPreference = 'Stop'
  try {
    if (Get-Command $Command) {
      return $true
    }
  } catch {
    return $false
  } finally {
    $ErrorActionPreference = $originalErrorAction
  }
  <#
  .SYNOPSIS
    Checks if a command exists.
  #>
}

<#region 7-zip#>
function Install-Chocolatey {
  if (Test-Command choco) {
    Write-Output 'Chocolatey is already installed c:'
  } else {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
    Invoke-WebRequest 'https://chocolatey.org/install.ps1' -UseBasicParsing | Invoke-Expression
  }
  <#
  .SYNOPSIS
    Installs Chocolatey if it's not installed.
  #>
}

function Install-7zip {
  if (Test-Command 7z) {
    Write-Output '7-zip is already installed c:'
  } else {
    if (-not $(Test-Command choco)) {
      throw 'Cannot find Chocolatey. Install Chocolatey or check the system path.'
    }
    choco.exe install 7zip
  }
  <#
  .SYNOPSIS
    Installs 7-zip CLI if it's not already installed using Chocolatey.
  .NOTES
    This function will throw an error if Chocolatey is not installed.
  #>
}
<#endregion#>

function Script:Get-DependencyBinaries {
  param (
    [Parameter(Mandatory = $true)]
    [string]
    $DependencyPath,
    [Parameter(Mandatory = $true)]
    [string]
    $Url,
    [Parameter(Mandatory = $true)]
    [string]
    $OutFile,
    [bool]
    $Clean
  )
  if ($Clean) {
    Remove-Item $DependencyPath -Force -Recurse -Verbose
  }
  Invoke-WebRequest -Uri $Url -OutFile $OutFile
  7z.exe x $OutFile
  Remove-Item $OutFile -Force -Verbose
  <#
  .SYNOPSIS
    Downloads and extracts the dependency binaries.
  .PARAMETER DependencyPath
    The path where the dependency binaries should be saved.
  .PARAMETER Url
    The URL from where the binaries should be downloaded.
  .PARAMETER OutFile
    The file to save the content downloaded from the URL.
  .PARAMETER Clean
    If true, the previous installation of the dependency binaries will be removed.
  #>
}

function Script:Install-Dependency {
  param (
    [Parameter(Mandatory = $true)]
    [string]
    $DependencyPath,
    [Parameter(Mandatory = $true)]
    [string]
    $Url,
    [Parameter(Mandatory = $true)]
    [string]
    $OutFile,
    [bool]
    $Force
  )
  $dependencyExists = Test-Path -Path $DependencyPath -PathType Container
  if ($Force -or -not $dependencyExists) {
    if (-not $(Test-Command 7z)) {
      throw 'Cannot find 7-zip. Install 7-zip or check the system path.'
    }
    try {
      $ErrorActionPreference = 'Stop'
      Get-DependencyBinaries $DependencyPath $Url $OutFile $($Force -and $dependencyExists)
    } catch {
      Write-Output $_
      Write-Output $_.Exception
    } finally {
      $ErrorActionPreference = $originalErrorAction
    }
  } else {
    throw 'Dependency already exists.'
  }
  <#
  .SYNOPSIS
    Installs a dependency on the current location.
  .PARAMETER DependencyPath
    The path where the dependency binaries should be saved.
  .PARAMETER Url
    The URL from where the binaries should be downloaded.
  .PARAMETER OutFile
    The file to save the content downloaded from the URL.
  .PARAMETER Force
    Performs the installation even if a previous dependency distribution is found.
  .NOTES
    This function will throw an error if 7-zip is not installed.
  #>
}

function Install-Boost {
  param (
    [Alias('f')]
    [switch]
    $Force
  )
  try {
    Install-Dependency `
      -DependencyPath '.\boost_1_77_0' `
      -Url 'https://boostorg.jfrog.io/artifactory/main/release/1.77.0/source/boost_1_77_0.7z' `
      -OutFile 'boost_1_77_0.7z' `
      $Force
  } catch {
    Write-Output 'Boost distribution found. To reinstall use `Install-Boost -Force`'
  }
  <#
  .SYNOPSIS
    Installs Boost on the current location.
  .PARAMETER Force
    Performs the installation even if a previous Boost distribution is found.
  .NOTES
    This function will throw an error if 7-zip is not installed.
  #>
}

function Install-MPFR {
  # param (
  #   OptionalParameters
  # )
  param (
    [Alias('f')]
    [switch]
    $Force
  )
  try {
    Install-Dependency `
      -DependencyPath '.\mpfr-4.1.0' `
      -Url 'https://www.mpfr.org/mpfr-current/mpfr-4.1.0.zip' `
      -OutFile 'mpfr-4.1.0.zip' `
      $Force
  } catch {
    Write-Output 'MPFR distribution found. To reinstall use `Install-MPFR -Force`'
  }
  <#
  .SYNOPSIS
    Installs Boost on the current location.
  .PARAMETER Force
    Performs the installation even if a previous MPFR distribution is found.
  .NOTES
    This function will throw an error if 7-zip is not installed.
  #>
}


function Install-CGAL {
  param (
    [Alias('f')]
    [switch]
    $Force
  )
  try {
    Install-Dependency `
      -DependencyPath 'CGAL-5.3.1' `
      -Url 'https://github.com/CGAL/cgal/releases/download/v5.3.1/CGAL-5.3.1.zip' `
      -OutFile 'CGAL-5.3.1.zip' `
      $Force
  } catch {
    Write-Output 'CGAL distribution found. To reinstall use `Install-CGAL -Force`'
  }
}
function Install-GodgalDependencies {
  & "$PSScriptRoot\update_repository.ps1"
  Install-Chocolatey
  Install-7zip
  # Install-Boost
  # Install-MPFR
  Install-CGAL
  <#
  .SYNOPSIS
    Installs all the dependencies needed to run GodGAL.
  #>
}