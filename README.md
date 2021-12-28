# GodGAL: Godot Geometry Algorithms Library

![http://creativecommons.org/licenses/by/4.0/](https://i.creativecommons.org/l/by/4.0/88x31.png)

The answer to the eternal question: Can you use CGAL from Godot?

## Pre-requisites

### 7-zip

7-zip is required to install [Boost](#boost).

#### Windows

To install 7-zip we recommend using [Chocolatey](https://chocolatey.org).
*Chocolatey* can be installed by doing:
```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
Invoke-WebRequest 'https://chocolatey.org/install.ps1' -UseBasicParsing | Invoke-Expression
```

Then installing *7/zip* is as simple as running:

```powershell
choco.exe install 7zip
```

### Boost

Boost is part of the requisites to use *CGAL*.

#### Windows

To install *Boost* you can use:

```powershell
Invoke-WebRequest -Uri 'https://www.boost.org/users/history/version_1_77_0.html' -OutFile 'boost_1_77_0.7z'

```

## Building for Windows

To build the project on Windows you can use the Powershell script provided in the repo:
```powershell
# From the repository's root
& .\rebuild_win_x64.ps1
```