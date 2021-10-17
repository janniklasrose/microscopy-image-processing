# carry out registration of image stack

## variables
# script
$script = ".\imagej_registration.py"
# folders
$sourcedir = ".\data\registration\input\"
$targetdir = ".\data\registration\output\"
$transfdir = ".\data\registration\transform\"
# file
$reference = "Slide001_x1.25_z0.tif" # relative to $sourcedir

## execute ImageJ
# prepare folders
New-Item -ItemType Directory -Force $targetdir | Out-Null # mkdir
New-Item -ItemType Directory -Force $transfdir | Out-Null # mkdir
# prepare name-value pairs
$options="sourcedir=" + "'" + $sourcedir + "'" + "," + "targetdir=" + "'" + $targetdir + "'" + "," + "transfdir=" + "'" + $transfdir + "'" + "," + "reference=" + "'" + $reference + "'"
# execute ImageJ in batch mode (ImageJ-win64 should be on PATH, change name for different OS)
ImageJ-win64 --ij2 --headless --console --run $script $options
