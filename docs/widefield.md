# Processing of *Wide-Field Microscopy* images

## ImageJ

ImageJ is best installed as [Fiji](https://fiji.sc/), which is ImageJ with many useful pre-installed plug-ins. The most relevant one of these is probably [Bio-Formats](https://imagej.net/Bio-Formats).

Notable exceptions (can be installed separately) are:

- [ndpitools](https://www.imnc.in2p3.fr/pagesperso/deroulers/software/ndpitools/imagejplugins.html)
- [SlideJ](https://imagej.net/SlideJ)

## Hamamatsu NDP.view2

The official [NDP.view2 Viewing software](https://www.hamamatsu.com/us/en/product/type/U12388-01/index.html) by Hamamatsu allows for fast viewing of individual slices from all NanoZoomer scanners.

Documentation is available for download [[PDF]](https://www.hamamatsu.com/sp/sys/en/manual/NDPview2_manual_en.pdf).

The viewer also reports the resolution corresponding to the highest optical zoom available in the file.

## ndpitools

[ndpitools](https://www.imnc.in2p3.fr/pagesperso/deroulers/software/ndpitools/) was published [here](https://doi.org/10.1186/1746-1596-8-92). It has command line binaries for scripted image extraction (with support for cropping and tiling), and also provides an ImageJ plug-in (see relevant section).

## Scripting

NDPI files are just [TIFF](https://en.wikipedia.org/wiki/TIFF) (Tagged Image File Format) with extra tags.

### Python

One open-source implementation is [ndPytools](https://github.com/fepegar/ndPytools), but users can also attempt to write their own Python code to [read tiff tags](https://stackoverflow.com/q/46283224), provided the correct tag ID is known. To handle tiff files, one might need to `pip install libtiff pytiff`.

### MATLAB

See `scripts/extract_ndpi.mlx` for an example of how to read ndpi files in MATLAB.

Note that if we display a large image with `imshow`, MATLAB will keep throwing a warning. As part of a script, this can be annoying and lead to the user missing other important warnings. We can disable the specific warning temporarily as such:

```matlab
msgID = 'images:initSize:adjustingMag'; % 'window too small ...'
bak = warning('query', msgID); % store state
warning('off', msgID); % turn off temporarily

% ... do someting ...

warning(bak.state, msgID); % reset
```

## Registration

- [bwferet](https://www.mathworks.com/help/images/ref/bwferet.html)
- [B-spline Grid, Image and Point based Registration](https://uk.mathworks.com/matlabcentral/fileexchange/20057-b-spline-grid-image-and-point-based-registration)
- [multimodality non-rigid demon algorithm image registration](https://www.mathworks.com/matlabcentral/fileexchange/21451-multimodality-non-rigid-demon-algorithm-image-registration)
