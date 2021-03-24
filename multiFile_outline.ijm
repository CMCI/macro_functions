fPath = getDirectory("Select a Folder of Images to Analyse"); // Find the folder of images to analyse
fList = getFileList(fPath); //get a list of what's in the folder
resultsArray1=newArray(); //make a new array to some results
resultsArray2=newArray(); //make a new array to some results
resultsArray3 = newArray(); //make a new array to some results
imNames = newArray(); //make an array to store names
setForegroundColor(255, 255, 255); //the foreground is forced to white
setBackgroundColor(0, 0, 0);//the background is forced to black
File.makeDirectory(fPath+"output/"); //make a folder to store images/results that are output by the macro
setBatchMode(true);
for (i=0;i<lengthOf(fList);i++){ //for every item in the folder

	if(fList[i]!="output/"){ //if it's not the folder for output images
		roiManager("Reset"); //if you need to delete ROIs between images, then leave this line in
		//open(fPath+fList[i]);//if your file is a proprietary filetype (e.g. .nd2, .czi), then you should comment this line, 
		//and uncomment the Bioformats line below
		run("Bio-Formats", "open="+fPath+fList[i]+" autoscale color_mode=Composite rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");

		
		fPref = split(fList[i],"."); //this assumes that there is only one '.' in the filename, delineating the extension eg '.tif'
		fPref=fPref[0];



		/* Insert your single-image macro code here 
		 * If it produces a results window, you can use the results loop below to pull data from the results window and
		 * save it so that you can export all the data from all the processed images at the same time. The image name
		 * will be the first column, so you can tie your data to specific images for statistics purposes.		
		*/

		for (res = 0;res <nResults; res++){ //results loop
			imNames = Array.concat(imNames,fPref);
			resultsArray1 = Array.concat(resultsArray1,getResult("Mean",res));
			resultsArray2 = Array.concat(resultsArray2,getResult("Min",res));
			resultsArray3 = Array.concat(resultsArray3,getResult("Max",res));
		} //end results loop
		run("Clear Results"); //clear the previous list of results
		updateResults();
		run("Close All"); //close all images
	}//end if !=output loop
	
}//end for each image loop


//make a new results table with all the results in the arrays you saved
for (res = 0;res <lengthOf(resultsArray1); res++){
	setResult("Name",res,imNames[res]);
	setResult("Mean",res,resultsArray1[res]);
	setResult("Min",res,resultsArray2[res]);
	setResult("Max",res,resultsArray3[res]);
	
}
saveAs("results", fPath+"output/resultsFile.csv"); //save this file into the output folder
