function Script:Invoke-BuildCMake {
  [CmdletBinding()]
  param (
      [Parameter(Mandatory = $true)]
      [string]
      $Target
  )
  try {
    New-Item -Path build -ItemType Directory
    Set-Location build
    cmake.exe -S .. -DCMAKE_BUILD_TYPE=Debug
    cmake.exe --build . --target $Target
  } catch {
    Write-Error 'There was an error while building the project'
    throw
  }
  <#
  .SYNOPSIS
    Builds the CMake project in the current scope.
  #>
}

function Script:Invoke-CleanCMake {
  try {
    if (Test-Path -Path build) {
      Remove-Item build -Recurse -Force -Verbose
    }
  } catch {
    Write-Error 'There was an error while cleaning the project'
    throw
  }
  <#
  .SYNOPSIS
    Remove files from previous builds.
  #>
}

function Script:Sync-Binaries {
  try {
    Set-Location $originalLocation
    Copy-Item -Path .\build\Debug\ -Destination .\project\bin\win64 -Recurse -Force -Verbose
  } catch {
    Write-Error 'There was an error while syncing the binaries with the Godot project'
    throw
  }
  <#
  .SYNOPSIS
    Creates a copy of the built binaries on the corresponding folder of the Godot project.
  #>
}

<#region MAIN #>
# We store the original location and error action preference to restore them later
$Script:originalLocation = Get-Location
$Script:originalErrorAction = $ErrorActionPreference

function Invoke-RebuildCMake {
  param (
      [Parameter(Mandatory = $true)]
      [string]
      $Target
  )
  try {
    $ErrorActionPreference = 'Stop' # This tells pwsh to throw an exception for **all** errors
    Set-Location "$PSScriptRoot\.."
    Invoke-CleanCMake
    Invoke-BuildCMake $Target
    Sync-Binaries
  } catch {
    Write-Output $_
    Write-Output $_.Exception
  } finally {
    Set-Location $originalLocation
    $ErrorActionPreference = $originalErrorAction
  }
}
<#endregion#>