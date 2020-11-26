/*
 * This code was written for people counting dark cells in DAB-stained brain sections.
 * It looks up the contents of a user-defined directory, which should all be RGB .tiffs, then 
 *  for each image, allows the user to define a region to analyse, counts the dark spots in that region 
 * using the Isodata thresholding technique, then outputs the counts and areas to a .csv file.
 * 
 * This does *NOT* measure the intensities within the measured cells
 * 
 */

//user defines a directory, do other setup
fPath=getDirectory("Choose a Directory");
fList=getFileList(fPath);
File.makeDirectory(fPath+"output/");
run("Clear Results"); 
updateResults();
run("Set Measurements...", "area redirect=None decimal=3");
setBackgroundColor(0);
setForegroundColor(255);

//initialise arrays to store data
fileNames =newArray();
cellCounts=newArray();
areaArray = newArray();

//for every inmage in the directory
for (i=0;i<lengthOf(fList);i++){
	//if it's not the output folder
	if(fList[i]!="output/"){
		
		//reset ROI, open image and store Filename
		roiManager("reset");
		open(fList[i]);
		fName = getInfo("image.filename");
		fileNames = Array.concat(fileNames,fName);
		getPixelSize(unit, pixelWidth, pixelHeight);
		
		//user defines region to analyse (or just does the whole image)
		setTool("freehand");
		waitForUser("Select the region you want to analyse.\n Select nothing to do the whole image");
		getSelectionBounds(x, y, width, height);
		if (x==0 && y==0){
			run("Select All");
		}
		roiManager("Add");

		//Duplicate the whole image, and threshold this
		run("Select All");
		run("Duplicate...", " ");
		rename("duplicate");
		run("16-bit");
		roiManager("Select",0);
		setAutoThreshold("IsoData"); //change this line to play with the threshold
		setOption("BlackBackground", false);
		run("Select All");
		run("Convert to Mask");

		//A few binary operations can help clean up the image
		run("Open");
		run("Close-");
		run("Watershed");

		//select the area to analyse and measure its area
		roiManager("Select",0);
		run("Measure");
		area = getResult("Area",nResults-1);
		areaArray = Array.concat(areaArray,area);
		run("Clear Results");
		updateResults();
		
		//count how many cells are in this area
		run("Clear Outside");
		run("Analyze Particles...", "size=10-10000 circularity=0.5-1.00 show=[Bare Outlines] clear include add");
		
		//Make the outlines of the cells green, and overlay them on the original image
		run("Green");
		run("Invert");
		run("RGB Color");
		imageCalculator("Add create", fList[i],"Drawing of duplicate");
		selectWindow("Result of "+fList[i]);
		saveAs("tiff", fPath+"output/"+fList[i]);
		cellCounts = Array.concat(cellCounts,roiManager("Count"));
		run("Close All");
	}
}
run("Clear Results"); 
updateResults();
for (i=0;i<lengthOf(fileNames);i++){
	setResult("Filename",nResults,fileNames[i]);
	setResult("Cell Count",nResults-1,cellCounts[i]);
	setResult("Area Measured ("+unit+")", nResults-1,areaArray[i]);
}
saveAs("Results", fPath+"output/results.csv");

