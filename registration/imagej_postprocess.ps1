# crop the registered slides to remove the padding

## variables
# folders
$inputfolder = ".\data\registration\output\"
$outputfolder = ".\data\registration\output_cropped\"
# settings
$quality = "100%"
$width = "45%" # keep $width (%) of total
$height = "50%" # keep $height (%) of total
$offset_w = "0.25" # offset by offset_w*total_width
$offset_h = "0.23" # offset by offset_h*total_height

## crop
# compose crop settings
$crop = "$($width)x$($height)+%[fx:$($offset_w)*w]+%[fx:$($offset_h)*h]"
# prepare
New-Item -ItemType Directory -Force $outputfolder | Out-Null # mkdir
# execute
Get-ChildItem "$inputfolder" -Filter *.tif | 
Foreach-Object -Parallel {
    magick $_.FullName -quality "$($using:quality)" -crop "$($using:crop)" ($($using:outputfolder) + "\" + $_.BaseName + ".tif")
}
