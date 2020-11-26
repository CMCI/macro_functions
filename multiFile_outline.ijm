fPath = getDirectory("Select a Folder of Images to Analyse"); // Find the folder of images to analyse
fList = getFileList(fPath); //get a list of what's in the folder
titleArray=newArray(); //make a new array to store titles
intensityArray=newArray(); //make a new array to store intensities
countArray = newArray(); //make a new array to store cell counts
setForegroundColor(255, 255, 255); //the foreground is forced to white
setBackgroundColor(0, 0, 0);//the background is forced to black
File.makeDirectory(fPath+"output/"); //make a folder to store images/results that are output by the macro

for (i=0;i<lengthOf(fList);i++){ //for every item in the folder

	if(fList[i]!="output/"){ //if it's not the folder for output images
		roiManager("Reset"); //if you need to delete ROIs between images, then leave this line in
		open(fPath=fList[i]);
		fPref = (fList[i],"."); //this assumes that there is only one '.' in the filename, delineating the extension eg '.tif'
		fPref=fPref[0];
		run("Clear Results"); //clear the previous list of results
		updateResults();
		

	
	}
	run("Clear Results"); //delete existing results for every image
	updateResults();
	run("Close All"); //close it
	
}


