/*
 * This code was written for people capturing multichannel images in Volocity who want to be able to look
 * at these or process them as individual .tiff files. The user is prompted to point it at a directory (navigate into the 
 * Volocity library!), then in that directory it will create a folder to store the individual tif files, then one-by-one it will open
 * the Volocity items, and save them to the folder in batch mode (i.e. the images will not appear on screen!)
 * 
 */
 
fPath = getDirectory("Choose a Directory");
fList = getFileList(fPath);
parent=split(fPath,"/");
parent = parent[lengthOf(parent)-1];
setBatchMode(true);
Array.print(fList);
File.makeDirectory(fPath+parent+"_split_files");
for (mvd2 = 0;mvd2 <lengthOf(fList); mvd2++){ //for every library file in the folder
	if (fList[mvd2]!="Data/" && fList[mvd2]!=parent+"_split_files/"){
		ext = substring(fList[mvd2],lengthOf(fList[mvd2])-4,lengthOf(fList[mvd2])); //this checks if it's an mvd2 file
		bas = substring(fList[mvd2],0,lengthOf(fList[mvd2])-5); //this saves the name of the folder
		if (ext=="mvd2"){ //if it's the mvd2 file
			run("Bio-Formats Macro Extensions"); 
			Ext.setId(fPath+fList[mvd2]);
			Ext.getSeriesCount(seriesCount);
			for (im=1;im<=seriesCount;im++){ //for every image in the library
				//open it
				run("Bio-Formats", "open=["+fPath+fList[mvd2]+"] color_mode=Default view=Hyperstack stack_order=XYCZT series_"+d2s(im,0));
				
				//save it
				saveAs("tif",fPath+parent+"_split_files/"+bas+"_"+im+".tif");
				
				//close it
				run("Close All");
			}
		}
	}
}
