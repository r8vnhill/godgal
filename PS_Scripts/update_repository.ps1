$Script:originalLocation = Get-Location

if ($(Split-Path -Path $(Get-Location) -Leaf) -eq "PS_Scripts") {
  Set-Location ..
}
git.exe pull
git.exe submodule update
Set-Location .\godot-cpp
git.exe submodule update
Set-Location $originalLocation