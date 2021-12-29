# GodGAL: Godot Geometry Algorithms Library

![http://creativecommons.org/licenses/by/4.0/](https://i.creativecommons.org/l/by/4.0/88x31.png)

The answer to the eternal question: Can you use CGAL from Godot?

## Table of Contents

- [GodGAL: Godot Geometry Algorithms Library](#godgal-godot-geometry-algorithms-library)
  - [Table of Contents](#table-of-contents)
  - [Pre-requisites](#pre-requisites)
    - [7-zip](#7-zip)
      - [Windows](#windows)
    - [CGAL](#cgal)
    - [Boost](#boost)
      - [Windows](#windows-1)
  - [Building for Windows](#building-for-windows)

## Pre-requisites

Powershell functions to install the pre-requisites on *Windows* can be found [here](https://github.com/islaterm/godgal/blob/master/PS_Scripts/install_commands.ps1).

You can install all the needed dependencies (except [Boost](#boost)) using:
```powershell
. .\PS_Scripts\install_commands.ps1
Install-GodgalDependencies
```

Alternatively, you can install the dependencies manually as explained below.

### 7-zip

7-zip is recommended to install the dependencies.

#### Windows

To install 7-zip we recommend using [Chocolatey](https://chocolatey.org).
*Chocolatey* can be installed by doing:
```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
Invoke-WebRequest 'https://chocolatey.org/install.ps1' -UseBasicParsing | Invoke-Expression
```

Then installing *7-zip* is as simple as running:

```powershell
choco.exe install 7zip
```

### CGAL

We first need to install a CGAL distribution, this can be done by running:
```powershell
Invoke-WebRequest `
  -Uri '"https://github.com/CGAL/cgal/releases/download/v5.3.1/CGAL-5.3.1.zip' `
  -OutFile 'CGAL-5.3.1.zip'
7z.exe x 'CGAL-5.3.1.zip'
```

Then, we have to install GMP, similar to CGAL, we can do that as follows:
```powershell
Set-Location 'CGAL-5.3.1'
Invoke-WebRequest `
  -Uri '"https://github.com/CGAL/cgal/releases/download/v5.3.1/CGAL-5.3.1-win64-auxiliary-libraries-gmp-mpfr.zip' `
  -OutFile 'CGAL-5.3.1-win64-auxiliary-libraries-gmp-mpfr.zip'
7z.exe x 'CGAL-5.3.1-win64-auxiliary-libraries-gmp-mpfr.zip'
```

### Boost

Boost is part of the requisites to use *CGAL*.

#### Windows

To install *Boost* you can use:

```powershell
Invoke-WebRequest `
  -Uri 'https://boostorg.jfrog.io/artifactory/main/release/1.77.0/source/boost_1_77_0.7z' `
  -OutFile 'boost_1_77_0.7z'
7z.exe x $outFile
```

## Building for Windows

To build the project on Windows you can use the Powershell script provided in the repo:
```powershell
# From the repository's root
& .\rebuild_win_x64.ps1
```
