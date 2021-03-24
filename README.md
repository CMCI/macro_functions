# macro_functions
A group of short macros that perform commonly-used tasks in FIJI. They are exclusively written in the macro language, ad, as far as I recall, don't require any extra plugins to run. That said, I can highly recommend installing the MorphoLibJ library (https://imagej.net/MorphoLibJ), which has extremely powerful and useful functions.

Cellcounter is used to count dark cells on a light background, such as those found in DAB-stained brain sections. It outputs a cell count for each image, as well as a .tif file in which the found cells are outlined in green.

kymoPicMaker is used to make kymographs on multi-channel images - the user draws lines along the piece of the image that they want to analyse in each time frame, and this is turned into a multi-channel kymograph.

multiFile_outline is essentially the basis of a FOR loop into which a user can insert code that will run on a single image. There are some premade arrays in which to store results, and you can expand how many of these there are, and change the types of data being stored in them. The imNames array should always be retained just to store image names.

The mvd2_Splitter and nd2_Splitter are designed to simply split Volocity library or Nikon multipoint .nd2 files, respectively, into individual .tif images.
