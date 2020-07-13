# Working with *Confocal Microscopy* images

## Software

- [Mimics](https://materialise.com/mimics)
- [itk-SNAP](http://www.itksnap.org)
- [ImageJ](https://imagej.net), for which there are a few plug-ins:
  - [3D_Viewer](https://imagej.net/3D_Viewer)
  - [3d-viewer](https://imagej.nih.gov/ij/plugins/3d-viewer/) (by NIH, potentially the same)

## File formats

It may be worth converting image stacks to a series of DICOM images. While not required for viewing and processing the stack, some segmentation tools are designed for DICOM images. Additionally, there is a Box app for viewing DICOM stacks directly in the browser.

## MATLAB

- Deconvolution: `deconvblind` and `deconvlucy`
- Processing of segmentation: `regionprops3(segmentation, 'volume')`
