/* The purpose of this code is to allow the user to take timeseries images, and turn them into kymographs
 * This was written with P0/P1/AB cell divisions in C.elegans in mind
 * The user will be prompted to set some parameters, then draw lines that run parallel to the axis of
 * motion in the kymograph. These lines should all be drawn in the same direction!
 *  
 */

//Get information about the image 
roiManager("Associate", "true");
fPath=getInfo("image.directory"); //where is it?
fName=getInfo("image.filename");
imList=getList("image.titles");
fPref=split(fName,".");
fPref=fPref[0];
getPixelSize(unit, pixelWidth, pixelHeight);
getDimensions(width, height, channels, slices, frames);
midX = floor(width/2);
midY = floor(height/2);
cInit = channels;
fInit = frames;
sInit = slices;
projList = newArray("[Sum Slices]","[Max Intensity]","[Min Intensity]","[Average Intensity]","[Standard Deviation]","Median");

//Close every window except the original
close("\\Others")
imList=getList("image.titles");

//Create a dialog box that controls parameters
run("Set Measurements...", "mean centroid fit redirect=None decimal=3");
Dialog.create("Time and Band Parameters"); 
Dialog.addNumber("Start (t): ", 1); //When does the kymograph start...
Dialog.addNumber("End (t): ", frames);//... and end
if (sInit > 1){ //whihc z slices do we include?
	Dialog.addNumber("Start Slice (z): ", 1); //When does the kymograph start...
	Dialog.addNumber("End Slice (z): ", slices);//... and end
	Dialog.addChoice("Projection Type", projList, "[Max Intensity]");
}

/*if (cInit > 1){
	Dialog.addNumber("Channel to kymograph: ", 1); //if there's >1 channel, which to keep
}*/
Dialog.addNumber("Band Width: ", 30); //how wide is each slice of the kymograph going to be?
Dialog.addNumber("Scale factor (0.85-1.0): ", 1); // What reduction of scale in the final kymograph?
Dialog.addCheckbox("Saved Kymo Lines", false); // Do kymo lines exist already?
Dialog.show();
t1=Dialog.getNumber();
t2=Dialog.getNumber();
if (sInit > 1){ //which z slices do we include?
	z1 = Dialog.getNumber(); //When does the kymograph start...
	z2 = Dialog.getNumber();//... and end
	projType = Dialog.getChoice();
}
/*if (cInit > 1){
	dataChannel = Dialog.getNumber(); //if there's >1 channel, which to keep
}*/
bandWidth=Dialog.getNumber();
hBandWidth = bandWidth/2;
scaleF=Dialog.getNumber();
roiState = Dialog.getCheckbox(); //do rois exist for this embryo?

roiManager("reset"); //delete existing ROIs

//if (cInit > 1){
//	run("Duplicate...", "duplicate channels="+dataChannel+" slices="+z1+"-"+z2+" frames="+t1+"-"+t2);
//}else{
	run("Duplicate...", "duplicate slices="+z1+"-"+z2+" frames="+t1+"-"+t2);
//}


rename("Substack");

selectWindow(imList[0]);
close();

getDimensions(width, height, channels, slices, frames);
if (sInit > 1){ //which z slices do we include?
	run("Z Project...", "projection="+projType+" all");
	rename("Temp");
	selectWindow("Substack");
	close();
	selectWindow("Temp");
	rename("Substack");
}
Stack.setDisplayMode("composite");
if (roiState == true || roiState ==1){
	roiManager("Open",fPath+fPref+"_kymoLines.zip");
}
else{
	setTool("Line");
	frames=8;
	for (f=1;f<=frames;f++){
		Stack.setFrame(f);
		waitForUser("Draw a line along which you want to plot a kymo");
		roiManager("add");
	}
	roiManager("save", fPath+fPref+"_kymoLines.zip");
}

//Work out the longest line (for determining Kymo limits)
count = roiManager("Count");
lineLength = 0;
for (roi = 0; roi<count;roi++){
	roiManager("Select",roi);
	run("Measure");
	tempLength = getResult("Length",nResults-1);
	if (tempLength > lineLength){
		lineLength = tempLength;
	}
}
lineLength = lineLength/pixelWidth; //line length is scaled in µm, so needs to be in pixels
hLineLength = round(lineLength/2);

//make windows for each individual timeframe that are lengthxbandWidth-sized frames around the axis of the plane of division
for (roi = 0; roi<roiManager("count");roi++){
	selectWindow("Substack");
	Stack.setFrame(roi+1);
	run("Duplicate...", "duplicate frames="+roi+1);
	roiManager("Select",roi);
	Roi.setStrokeWidth(bandWidth);
	roiManager("update");
	run("Measure");
	run("Line to Area");
	ang = getResult("Angle",nResults-1);
	centX = getResult("X",nResults-1);
	centY = getResult("Y",nResults-1);
	centX = centX/pixelWidth;
	centY = centY/pixelWidth;
	run("Select None");
	run("Translate...", "x="+(midX-centX)+" y="+(midY-centY)+" interpolation=None stack");
	run("Rotate... ", "angle="+ang+" grid=1 interpolation=Bilinear enlarge stack");
	getDimensions(width, height, channels, slices, frames);
	makeRectangle(floor(width/2)-hLineLength, floor(height/2)-hBandWidth, lineLength, bandWidth);
	run("Crop");
	run("Split Channels");
}

imList=getList("image.titles");
q=t2-t1+1;
run("Images to Stack", "method=[Copy (center)] name=Stack title=[] use");
run("Stack to Hyperstack...", "order=xyczt(default) channels="+cInit+" slices=1 frames="+q+" display=Composite");

run("Make Montage...", "columns=1 rows="+q+" scale=1");

if (cInit > 1){
	saveAs(fPath+fPref+"_merged_kymo.tif");
}else{
	saveAs(fPath+fPref+"_kymo.tif");
}

