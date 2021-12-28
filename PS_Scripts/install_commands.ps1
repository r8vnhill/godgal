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

function Install-Chocolatey {
  if (Test-Command choco) {
    Write-Output 'Chocolatey is already installed c:'
  } else {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
    Invoke-WebRequest 'https://chocolatey.org/install.ps1' -UseBasicParsing | Invoke-Expression
  }
}

function Install-7zip {
  if (Test-Command 7z) {
    Write-Output '7-zip is already installed c:'
  } else {
    if (-not $(Test-Command choco)) {
      throw "Cannot find Chocolatey. Install Chocolatey or check the system path."
    }
    choco.exe install 7zip
  }
}

function Install-Boost (OptionalParameters) {
  
}