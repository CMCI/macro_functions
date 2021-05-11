name = getInfo("image.filename");
getDimensions(width, height, channels, slices, frames);
maskArray = newArray(width*height);
maskArray = Array.fill(maskArray, 1);

rename("original");
run("Duplicate...","duplicate");
rename("mask");
run("Gaussian Blur 3D...", "x=1 y=1 z=1");
setAutoThreshold("Triangle dark");
run("Threshold...");
setOption("BlackBackground", false);

waitForUser("Adjust Threshold as desired");
run("Convert to Mask", "background=Dark");
run("16-bit");


setBatchMode(true);
for (slice=slices;slice>0;slice--){
	count = 0;
	selectWindow("original");
	Stack.setSlice(slice);
	selectWindow("mask");
	Stack.setSlice(slice);
	for (xPx = 1;xPx<width+1;xPx++){
		for (yPx = 1;yPx<width+1;yPx++){
			if (maskArray[count] == 1 &&  getPixel(xPx,yPx)==255){
					maskArray[count]=0;
					selectWindow("original");
					t = getPixel(xPx, yPx);
					selectWindow("mask");
					setPixel(xPx, yPx,t);
					count = count + 1;
			}
			else{
					setPixel(xPx, yPx,0);
					count = count + 1;
				}
			
		}	
	}
}
selectWindow("original");
rename(name);
selectWindow("mask");
run("Invert LUT");
