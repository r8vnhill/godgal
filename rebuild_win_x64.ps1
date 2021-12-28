try {
  $originalLocation = Get-Location
  $originalErrorAction = $ErrorActionPreference

  $ErrorActionPreference = 'Stop'

  if (Test-Path -Path build) {
    Remove-Item build -Recurse -Force -Verbose
  }
  New-Item -Path build -ItemType Directory
  Set-Location build

  cmake.exe -S .. -DCMAKE_BUILD_TYPE=Debug
  cmake.exe --build . --target libgdexample

  Set-Location $originalLocation
  Copy-Item -Path .\build\Debug\ -Destination .\project\bin\win64 -Recurse -Force -Verbose
} catch {
  Write-Output $_
  Write-Output $_.Exception
} finally {
  Set-Location $originalLocation
  $ErrorActionPreference = $originalErrorAction
}