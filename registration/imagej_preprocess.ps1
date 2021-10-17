# copy a scaled-down version of the image stack to the registration input folder

## variables
# folders
$inputfolder = ".\data\ndpi_split\x1.25\" # choose the resolution
$outputfolder = ".\data\registration\input\" # where to put them
# settings
$scale = "10%" # to what scale we should minimise the input images

## convert
# prepare
New-Item -ItemType Directory -Force $outputfolder | Out-Null # mkdir
# execute
Get-ChildItem "$inputfolder" -Filter *.tif | # find files and pipe to loop
Foreach-Object -Parallel { # in -Parallel, we need $($using:VAR) instead of $VAR
    magick $_.FullName -scale $($using:scale) ($($using:outputfolder) + $_.BaseName + ".tif")
}
