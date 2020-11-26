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
		//run("Bio-Formats", "open=["+fPath+fList[nd2]+"] color_mode=Default open_all_series view=Hyperstack stack_order=XYCZT");
		for (im=1;im<=seriesCount;im++){
			
			run("Bio-Formats", "open=["+fPath+fList[nd2]+"] color_mode=Default view=Hyperstack stack_order=XYCZT series_"+d2s(im,0) );
			saveAs("tif",fPath+"split_files/"+nom+"_"+im+".tif");
			run("Close All");
		}
	}
}
