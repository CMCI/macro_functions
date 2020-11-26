fPath = getDirectory("Choose a Directory");
fList = getFileList(fPath);
parent=split(fPath,"/");
parent = parent[lengthOf(parent)-1];
setBatchMode(true);
Array.print(fList);
File.makeDirectory(fPath+parent+"_split_files");
for (mvd2 = 0;mvd2 <lengthOf(fList); mvd2++){ //for every library file in the folder
	
	if (fList[mvd2]!="Data/" && fList[mvd2]!=parent+"_split_files/"){
		nom = split(fList[mvd2],".");
		Array.print(nom);
		if (nom[1]=="mvd2"){
			nom = nom[0];
			run("Bio-Formats Macro Extensions"); 
			Ext.setId(fPath+fList[mvd2]);
			Ext.getSeriesCount(seriesCount);
			print(seriesCount);
			//run("Bio-Formats", "open=["+fPath+fList[mvd2]+"] color_mode=Default open_all_series view=Hyperstack stack_order=XYCZT");
			for (im=1;im<=seriesCount;im++){
				
				run("Bio-Formats", "open=["+fPath+fList[mvd2]+"] color_mode=Default view=Hyperstack stack_order=XYCZT series_"+d2s(im,0));
				saveAs("tif",fPath+parent+"_split_files/"+nom+"_"+im+".tif");
				run("Close All");
			}
		}
	}
}
