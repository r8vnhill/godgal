#Requires -RunAsAdministrator

$Script:originalErrorAction = $ErrorActionPreference

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

<#region BOOST#>
function Script:Get-BoostBinaries {
  param (
    [Parameter(Mandatory = $true)]
    [bool]
    $BoostExists,
    [Parameter(Mandatory = $true)]
    [string]
    $BoostPath,
    [bool]
    $Force
  )
  if ($Force -and $BoostExists) {
    Remove-Item $BoostPath -Force -Recurse -Verbose
  }
  $outFile = 'boost_1_77_0.7z'
  Invoke-WebRequest `
    -Uri 'https://boostorg.jfrog.io/artifactory/main/release/1.77.0/source/boost_1_77_0.7z' `
    -OutFile $outFile
  7z.exe x $outFile
  Remove-Item $outFile -Force -Verbose
  <#
  .SYNOPSIS
    Downloads and extracts Boost binaries.
  #>
}

function Install-Boost {
  param (
    [Alias('f')]
    [switch]
    $Force
  )
  $boostPath = '.\boost_1_77_0'
  $boostExists = Test-Path -Path $boostPath -PathType Container
  if ($Force -or -not $boostExists) {
    if (-not $(Test-Command 7z)) {
      throw 'Cannot find 7-zip. Install 7-zip or check the system path.'
    }
    try {
      $ErrorActionPreference = 'Stop'
      Get-BoostBinaries $boostExists $boostPath $Force
    } catch {
      Write-Output $_
      Write-Output $_.Exception
    } finally {
      $ErrorActionPreference = $originalErrorAction
    }
  } else {
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
<#endregion#>