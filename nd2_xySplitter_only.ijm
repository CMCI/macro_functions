/*
 * This code was written for people capturing multipoint images in NIS Elements who want to split these into individual .tif 
 * files. The user is prompted to point it at a directory containing just .nd2 files (navigate into the folder!), 
 * then in that directory it will create a folder to store the individual tif files, then one-by-one it will open
 * the multipoints from each nd2 file items, and save them to the folder in batch mode (i.e. the images will not appear on screen.)
 * 
 */

fPath = getDirectory("Choose a Directory");
fList = getFileList(fPath);
setBatchMode(true);
File.makeDirectory(fPath+"split_files");
for (nd2 = 0;nd2 <lengthOf(fList); nd2++){ //for every nd2 file in the folder
	nom = split(fList[nd2],".");
	Array.print(nom);
	if (nom[1]=="nd2"){
		nom = nom[0];
		run("Bio-Formats Macro Extensions"); 
		Ext.setId(fPath+fList[nd2]);
		Ext.getSeriesCount(seriesCount);
		print(seriesCount);
		for (im=1;im<=seriesCount;im++){
			
			run("Bio-Formats", "open=["+fPath+fList[nd2]+"] color_mode=Default view=Hyperstack stack_order=XYCZT series_"+d2s(im,0) );
			saveAs("tif",fPath+"split_files/"+nom+"_"+im+".tif");
			run("Close All");
		}
	}
}
