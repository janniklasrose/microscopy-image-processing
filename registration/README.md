# Registration of a wide-field microscopy image stack

## Software

Most scripts here are PowerShell scripts. Since PowerShell is now available on [Linux](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux) and [macOS](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-macos), this is a good universal approach. They were developed using **PowerShell 7** so no guarantees are made that they will run in older versions without the [new features](https://docs.microsoft.com/en-us/powershell/scripting/whats-new/what-s-new-in-powershell-70).

The [NDPITools](https://www.imnc.in2p3.fr/pagesperso/deroulers/software/ndpitools/) software is a very powerful tool to extract data from `.ndpi` files.

For image registration, we use [ImageJ](https://imagej.net/). It is recommended to install [Fiji](https://imagej.net/software/fiji/) (_Fiji is just ImageJ_, with "batteries included").

For image processing, we use [Imagemagick](https://imagemagick.org/). The scripts (`magick` and `convert`) have a lot of well-documented [command line options](https://imagemagick.org/script/command-line-options.php) to accomplish almost anything.

## Automatic detection of the image subject

Using MATLAB, run the [`crop_ndpi_with_mask.m`](./crop_ndpi_with_mask.m) script. This can be done from the MATLAB GUI (if already open) or non-interactively via the command prompt:
```shell
matlab -batch crop_ndpi_with_mask
```

Before doing so, make sure to open the file and edit the following variables in the beginning of the file:
```matlab
basename_pattern = 'Slide%03d'; % basename of file (no extension)
stack_indices = 1:312; % indices for basename_pattern
max_lens = 20; % 20x maximum magnification
input_folder = fullfile('data/', 'ndpi/');
output_folder = fullfile('data/', 'ndpi_masked/');
padding_factor = 0.05; % 5% extra
```

This will extract the autofocus map and macro image from the .ndpi files. Using `regionprops`, it then finds the largest contiguous region in the autofocus image and uses this as a mask to crop the two extracted images (with optional padding applied).

The [Image Processing Toolbox](https://mathworks.com/help/images/) needs to be installed in order to use `regionprops`. The code makes use of the `NDPI` class (specified in [`NDPI.m`](./NDPI.m)). Make sure this file is available and on the path (if you move it somewhere else).

## Extraction of individual images from NDPI format

Here we provide the PowerShell script [`split_ndpi_files.ps1`](./split_ndpi_files.ps1) as a wrapper around the `ndpisplit` (NDPITools) command. It handles organisation of the data and parallelises the extraction, which can be time consuming for a large batch of files.

We require `ndpisplit.exe` to be on the system path. To do this in PowerShell, you can (for example) do the following:
```powershell
$Env:Path += ";path\to\ndpitools\bin\"
```
Note the `;` at the start of the path!
Alternatively, edit the user environment variable `PATH` using the graphical interface in Windows.

Before running the script, open it and make any necessary changes to the variables at the top of the file:
```powershell
## variables
# folders
$ndpifolder = ".\data\ndpi\" # where .ndpi files are located
$tempfolder = ".\data\tmp\" # temp dir to extract into
$splitfolder = ".\data\ndpi_split" # where to organise (by resolution) the split files
# names
$resolutions = ("20","10","5","2.5","1.25","0.625","0.3125","0.15625") # image resolutions
```
The list of `$resolutions` determines which magnification levels are extracted.

## Animation of slide stack

To generate a GIF of slides, we can use `ffmpeg`. The following PowerShell snippet gives a good set of arguments to produce a small GIF:
```powershell
$frames = ".\data\ndpi_masked\macro\Slide%03d.jpg" # input file (pattern)
$output = ".\data\ndpi_masked\macro.gif" # output file
$xsize = "200" # number of pixels in x (images scale isotropically)
ffmpeg.exe -i $frames -filter:v scale="$xsize":-1 $output
```
An equivalent command can easily be constructed on Linux or macOS.

## Registration of slides

### Pre-processing

We want to carry out the registration quickly, using a low-resolution stack of images. The macro images should not be used, because the registration does not directly apply to the full-resolution images. The macro image has a different aspect ratio from the images at the various resolutions, which have been pre-cropped. The best approach is to select the smallest common resolution (in this case `x1.25`) and downsample the stack.

Make sure to edit the [`imagej_preprocess.ps1`](./imagej_preprocess.ps1) script file first:
```powershell
## variables
# folders
$inputfolder = ".\data\ndpi_split\x1.25\" # choose the resolution
$outputfolder = ".\data\registration\input\" # where to put them
# settings
$scale = "10%" # to what scale we should minimise the input images
```

### Registration

ImageJ supports various forms of [image registration](https://imagej.net/imaging/registration). The plugin that we choose here is called [Register Virtual Stack Slices](https://imagej.net/plugins/register-virtual-stack-slices). It is very simple to set up and is suitable to the stacks of microscopy images that we have.

To accelerate the processing workflow, ImageJ supports [scripting](https://imagej.net/scripting) both interactively and [in headless mode](https://imagej.net/scripting/headless).

The registration script to execute the plugin is [`imagej_registration.py`](./imagej_registration.py). Runtime parameters (the folders and filenames) are passed as key-value arguments to `ImageJ`, which relays them to the script. The user-facing script is the PowerShell script [`imagej_registration.ps1`](./imagej_registration.ps1). It takes care of correctly calling `ImageJ`. Before executing, make sure to confirm the variables at the start of the file:
```powershell
## variables
# script
$script = ".\imagej_registration.py"
# folders
$sourcedir = ".\data\registration\input\"
$targetdir = ".\data\registration\output\"
$transfdir = ".\data\registration\transform\"
# file
$reference = "Slide001_x1.25_z0.tif" # relative to $sourcedir
```

The `ImageJ` executable (on Windows, `ImageJ-win64`) needs to be on the `PATH`.

### Post-processing

The registered images have a lot of padding around the subject, due to excessive rotation of some slides. This post-processing step removes this.

Some fine-tuning is necessary. Specifically, the following settings need to be tweaked:
```powershell
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
```
The choice of this is very dependent on the image stack and are chosen for the specific files at hand.
