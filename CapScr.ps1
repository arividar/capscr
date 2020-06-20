#!pwsh
<#
.Synopsis
Takes a screenshot and stores it in a file
.DESCRIPTION
Captures a screenshot of the current screen and stores it as `
jpg-file current directory. By default the file is named by the `
current date and time like so 2024-06-20_10.06.37.jpg.
.EXAMPLE
Write-Screenshot
.EXAMPLE
Write-Screenshot -FolderPath \MyStuff\Screenshots
#>
function Write-Screenshot() {

    param(
         [string]$FolderPath = $pwd,
         [string]$Filename 
    )

    function Write-ScreenshotWin([string]$filepath) {
        Add-Type -AssemblyName System.Windows.Forms
        Add-type -AssemblyName System.Drawing

        $screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
        $bitmap = New-Object System.Drawing.Bitmap $screen.Width, $screen.Height
        $graphic = [System.Drawing.Graphics]::FromImage($bitmap)
        $graphic.CopyFromScreen($screen.Left, $screen.Top, 0, 0, $bitmap.Size)
        $bitmap.Save($filepath, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    }

    function Write-ScreenshotMac([string]$filepath) {
        & screencapture -t jpg -x $filepath 
    }

    $baseFileName = Get-Date -Format "yyyy-MM-ddTHH.mm.ss" 
    if ($Filename) {
        $baseFileName = $Filename
    }
    
    if (!(Test-Path $FolderPath)) {
            New-Item -ItemType Directory -Path $FolderPath | Out-Null
    }

    $capFilename = Join-Path (Resolve-Path $FolderPath) "$baseFileName.jpg"
    
    if ($IsWindows) {
        Write-ScreenShotWin $capFilename
    }
    elseif ($IsMacOS) {
        Write-ScreenShotMac $capFilename
    }
    elseif ($IsLinux) {
        Write-Error "Write-Screenshot is not supported on Linux"
    }
    else {
        Write-Error "Write-Screenshot is only supported on MacOS and Windows"
    }

}
