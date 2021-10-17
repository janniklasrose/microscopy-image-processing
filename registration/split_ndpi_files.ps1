# split the .ndpi files and organise the resulting images

## variables
# folders
$ndpifolder = ".\data\ndpi\" # where .ndpi files are located
$tempfolder = ".\data\tmp\" # temp dir to extract into
$splitfolder = ".\data\ndpi_split" # where to organise (by resolution) the split files
# names
$resolutions = ("20","10","5","2.5","1.25","0.625","0.3125","0.15625") # image resolutions

## call ndpisplit on all files in parallel
# prepare
New-Item -ItemType Directory -Force $tempfolder | Out-Null # mkdir
# execute
Get-ChildItem $ndpifolder -Filter *.ndpi | # find files and pipe to loop
Foreach-Object -Parallel { # in -Parallel, we need $($using:VAR) instead of $VAR
	ndpisplit -O $($using:tempfolder) -p $_.FullName # extract macro & map
	ndpisplit -O $($using:tempfolder) -x"$($using:resolutions -join ",")" $_.FullName
}

## sort into individual folders
# execute
foreach ($name in ( ($resolutions | ForEach-Object {"x$_"}) + ("macro", "map") )) {
    $targetfolder = "$splitfolder\$name"
    New-Item -ItemType Directory -Force "$targetfolder" | Out-Null
    Move-Item -Force "$tempfolder\*$name*.tif" "$targetfolder\"
}
