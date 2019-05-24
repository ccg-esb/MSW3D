/* 
ImageJ macro for blob intensity measurement
RPM 07/05/2016

Esta version identifica manualmente la posicion de los blobs
Guarda el registro de cada blob (en esta version, representadas por circulos) como ROIs en el RoiManager.
Exporta la informacion del RoiManager a la tabla Results, la cual puede ser exportada como xls o csv para su posterior analisis

Uso:
<Shift> <Left-click>: inserta un blob
<Ctrl> <Left-click>: exporta datos
* Para cambiar posicion de blob: Seleccionar en el ROI Manager y mover manualmente


ToDo:
> Normalize colorbar (& add labels)
> Subract background/Normalize intensity

*/

/************************************************/
// PARAMETERS

dirName="/Users/ESB/SYNC/SYNC_Projects/MSW3D/data/";
fileName="baffle_Colour_1.tif";

//Blob dimensions
maxDiameter=60; 
minDiameter=10;
d=40;

minIntensity=2;
maxIntensity=120;

/************************************************/

// Loads image
//loadImage(dirName+"images/"+fileName);
//run("8-bit");
//run("Calibrate...", "save=/Users/ESB/Desktop/calibration.txt function=[Straight Line] unit=[Gray Value] text1=[20 120] text2=[0 1]");


// Listens to clicks and does stuff
setOption("DisablePopupMenu", true);
if (isOpen("ROI Manager")) {
	selectWindow("ROI Manager");
	run("Close");

	run("Clear Results");

	setFont("Arial", 8, "bold"); 
     setColor("Blue"); 
}

shift=1; ctrl=2; alt=8; leftButton=16; insideROI = 32;
x2=-1; y2=-1; z2=-1; flags2=-1;
roiColors = loadColorsfromLut("glow.lut");

//Draws colorbar
/*
cb_x=1000;
cb_y=200;
cb_w=30;
cb_h=2*256;
cb_numColors=20;

drawColorBar(cb_x,cb_y,cb_w,cb_h);
*/

//parameters for max enclosed circle
var fourIndices = newArray(4); 
var xcenter, ycenter, radius; 

n=1;
while (ctrl!=0) {
	getCursorLoc(x, y, z, flags);
	if (x!=x2 || y!=y2 || z!=z2 || flags!=flags2) {
		s = " ";

		if (flags&shift!=0){
			s = s + "<shift>";
		}

		if (flags&ctrl!=0){
			s = s + "<ctrl>";


			//Export from ROI Manager to ResultsTable
			print("Exporting data");
			exportData();

			//Save image with blobs
			run("Flatten");
			saveAs("Tiff",dirName+"processed/"+fileName);

			//Close original image
			selectWindow(fileName);
			close();

			//Close ROI manager
			selectWindow("ROI Manager");
			run("Close");

			ctrl=0;
		}
		
		if (flags&leftButton!=0){
			s = s + "<left>";
		
			if(flags&shift!=0){

				getCursorLoc(x, y, z, flags);

				//REVISA SI NO HAY OTRO BLOB AQUI ***
				if(getRoiIndex(x,y,z)<0){
				
					makeOval(x-d/2,y-d/2,d,d); 
	
					/*
					doWand(x, y, 5.0, "Legacy");
					run("Line Width...", "line=1"); 
					getSelectionCoordinates(xCoordinates, yCoordinates); 
					smallestEnclosingCircle(xCoordinates, yCoordinates); 
					diameterC = round(2*radius); 
					print(">"+diameterC);
					if(diameterC<maxDiameter && diameterC>maxDiameter){
						makeOval(round(xcenter-radius), round(ycenter-radius), diameterC, diameterC); 
					}else{
						makeOval(x-d/2,y-d/2,d,d);
					}
					*/
					
					roiManager("add");
					roiManager("select",roiManager("count")-1);
	
					
	      			getStatistics(area, mean);
					normIntensity=(mean-minIntensity)/maxIntensity;
					
					
					print("intensity= "+normIntensity);
					thisColor="yellow";
					if (normIntensity>1)
						normIntensity=1;
					if(normIntensity<0)
						normIntensity=0;
					
					c=floor(roiColors.length*normIntensity);
					if(c<1)
						c=1;
					thisColor=roiColors[c];
					roiManager("Set Fill Color", thisColor);

//run("Calibration Bar...", "location="+location+" fill="+fil+" label="+label+" number="+number+" decimal="+decimal+" font="+font+" zoom="+zoom);
    				


					roiManager("select",roiManager("count")-1);
					roiManager("rename",fileName+"_blob"+n+"_x"+x+"_y"+y);
					print("... "+fileName+"_blob"+n+"_x"+x+"_y"+y+"");
					n=n+1;
					//setBackgroundColor(thisColor);
					run("Labels...", "color=black font=18 show");
					roiManager("Show All with labels");
					

					wait(20);
					
				}
				makeOval(0,0,0,0); //Para des-seleccionar
					
			}
		}


	}
	wait(100);
}
x2=x; y2=y; z2=z; flags2=flags;


setOption("DisablePopupMenu", false);


/************************************************/
// Funtion that loads (and prepares) time-lapse image
function loadImage(fileName){
	open(fileName);
	run("Remove Overlay"); // cleans up any previous overlays -- may be deleted or commented out
	run("RGB Color");
}

//
function exportData(){

	  n = roiManager("count");
	  for (i=0; i<n; i++) {
	      roiManager("select", i);
	      label=call("ij.plugin.frame.RoiManager.getName", i);

	      imageFile=substring(label, 0, indexOf(label, "_"));
	      label=substring(label, indexOf(label, "_")+5);
	      
	      id=substring(label, 0, indexOf(label, "_"));
		  label=substring(label, indexOf(label, "_")+2);
	
	   	  x=substring(label, 0, indexOf(label, "_"));	
		  y=substring(label, indexOf(label, "_")+2);
	
	   	  
	      getStatistics(area, mean);
	      setResult("image", i, imageFile);
	      setResult("blob",i, id);
	      setResult("x",i, x);
	      setResult("y",i, y);
	      setResult("Mean", i, mean);	
	
	  
	  updateResults();
	}
	makeOval(0,0,0,0); //Para des-seleccionar
}

/************************************************/
// Function that returns the index of a ROI from
// the RoiManager given its position
function getRoiIndex(x,y,z){
	n = roiManager("count");
	for (i=0; i<n; i++) {
		label=call("ij.plugin.frame.RoiManager.getName", i);
	  		roiManager("select", i);
			run("Enlarge...", "enlarge=10");
			inside = Roi.contains(x, y); 
			if (inside > 0 ) {
				return i;
			}
	}
	return -1;
}
/******************************************************/
/* Finds the smallest circle enclosing a set of points */ 
/* Input: arrays of x and y coordinates of the points */ 
/* Returns global variables xcenter, ycenter, radius */ 
function smallestEnclosingCircle(x,y) { 
  n = x.length; 
  if (n==1) 
    return newArray(x[0], y[0], 0); 
  else if (n==2) 
    return circle2(x[0], y[0], x[1], y[1]); 
  else if (n==3) 
    return circle3(x[0], y[0], x[1], y[1], x[2], y[2]); 
  //As starting point, find indices of min & max x & y 
  xmin = 999999999; ymin=999999999; xmax=-1; ymax=-1; 
  for (i=0; i<n; i++) { 
    if (x[i]<xmin) {xmin=x[i]; fourIndices[0]=i;} 
    if (x[i]>xmax) {xmax=x[i]; fourIndices[1]=i;} 
    if (y[i]<ymin) {ymin=y[i]; fourIndices[2]=i;} 
    if (y[i]>ymax) {ymax=y[i]; fourIndices[3]=i;} 
  } 
  do { 
    badIndex = circle4(x, y);  //get circle through points listed in  fourIndices 
    newIndex = -1; 
    largestRadius = -1; 
    for (i=0; i<n; i++) {      //get point most distant from center of circle 
      r = vecLength(xcenter-x[i], ycenter-y[i]); 
      if (r > largestRadius) { 
        largestRadius = r; 
        newIndex = i; 
      } 
    } 
    //print(largestRadius); 
    retry = (largestRadius > radius*1.0000000000001); 
    fourIndices[badIndex] = newIndex; //add most distant point 
  } while (retry); 
} 

//circle spanned by diameter between two points. 
function circle2(xa,ya,xb,yb) { 
  xcenter = 0.5*(xa+xb); 
  ycenter = 0.5*(ya+yb); 
  radius = 0.5*vecLength(xa-xb, ya-yb); 
  return; 
} 
//smallest circle enclosing 3 points. 
function circle3(xa,ya,xb,yb,xc,yc) { 
  xab = xb-xa; yab = yb-ya; c = vecLength(xab, yab); 
  xac = xc-xa; yac = yc-ya; b = vecLength(xac, yac); 
  xbc = xc-xb; ybc = yc-yb; a = vecLength(xbc, ybc); 
  if (b==0 || c==0 || a*a>=b*b+c*c) return circle2(xb,yb,xc,yc); 
  if (b*b>=a*a+c*c) return circle2(xa,ya,xc,yc); 
  if (c*c>=a*a+b*b) return circle2(xa,ya,xb,yb); 
  d = 2*(xab*yac - yab*xac); 
  xcenter = xa + (yac*c*c-yab*b*b)/d; 
  ycenter = ya + (xab*b*b-xac*c*c)/d; 
  radius = vecLength(xa-xcenter, ya-ycenter); 
  return; 
} 
//Get enclosing circle for 4 points of the x, y array and return which 
//of the 4 points we may eliminate 
//Point indices of the 4 points are in global array fourIndices 
function circle4(x, y) { 
  rxy = newArray(12); //0...3 is r, 4...7 is x, 8..11 is y 
  circle3(x[fourIndices[1]], y[fourIndices[1]], x[fourIndices[2]], 
y[fourIndices[2]], x[fourIndices[3]], y[fourIndices[3]]); 
  rxy[0] = radius; rxy[4] = xcenter; rxy[8] = ycenter; 
  circle3(x[fourIndices[0]], y[fourIndices[0]], x[fourIndices[2]], 
y[fourIndices[2]], x[fourIndices[3]], y[fourIndices[3]]); 
  rxy[1] = radius; rxy[5] = xcenter; rxy[9] = ycenter; 
  circle3(x[fourIndices[0]], y[fourIndices[0]], x[fourIndices[1]], 
y[fourIndices[1]], x[fourIndices[3]], y[fourIndices[3]]); 
  rxy[2] = radius; rxy[6] = xcenter; rxy[10] = ycenter; 
  circle3(x[fourIndices[0]], y[fourIndices[0]], x[fourIndices[1]], 
y[fourIndices[1]], x[fourIndices[2]], y[fourIndices[2]]); 
  rxy[3] = radius; rxy[7] = xcenter; rxy[11] = ycenter; 
  radius = 0; 
  for (i=0; i<4; i++) 
    if (rxy[i]>radius) { 
      badIndex = i; 
      radius = rxy[badIndex]; 
    } 
  xcenter = rxy[badIndex + 4]; ycenter = rxy[badIndex + 8]; 
  return badIndex; 
} 

function vecLength(dx, dy) { 
  return sqrt(dx*dx+dy*dy); 
} 


/************************************************/
//Funciones auxiliares
function loadColorsfromLut(lut) {
    path = getDirectory("luts")+lut;
    list = File.openAsRawString(path);
    rgbColor = split(list,"\n");
    if(rgbColor.length<255 || rgbColor.length>257)
        verboseExit("Error reading "+path, "Reason: Found unexpected number of columns");
    hexColor = newArray(256);
    firstStrg = substring(rgbColor[0], 0, 1);
    if (isNaN(firstStrg))
        k = 1;    // the lut file has a header (Index Red Green Blue)
     else
        k = 0;    // there is no header. First row is index 0
    for(i=k; i<256; i++) {
        hex = rgbToHex(rgbColor[i]);    
        hexColor[i] = hex;
    }
    return  hexColor;  
}
function rgbToHex(color) {
    color1 = split(color,"\t");
    if(color1.length==1)
        color1 = split(color," ");
    if(color1.length==1)
        verboseExit("Chosen LUT does not seem to be either a tab-delimited",
                    "or a space-delimited text file");
    if(color1.length==4)
        i = 1;    // first column of the lut file is the index number
    else
        i = 0;    // first column of the lut file is the red value
    r = color1[0+i]; g = color1[1+i]; b = color1[2+i];
    return ""+toHex(r)+""+toHex(g)+""+toHex(b);
}


function toHex(n) {
    n = parseInt(n);
    if(n==0 || isNaN(n))
        return "00";
    n = maxOf(0,n); n = minOf(n,255); n = round(n);
    hex = ""+substring("0123456789ABCDEF",((n-n%16)/16),((n-n%16)/16)+1)+
          substring("0123456789ABCDEF",(n%16),(n%16)+1);
    return hex;
}
/***********************************************/
// Colorbar
function drawColorBar(x,y,w,h){
roiColors = loadColorsfromLut("glow.lut");

//setBatchMode(true);
	numColors=roiColors.length;
     hi=h/numColors;
	for(i=2; i<numColors-1; i++){
		thisColor="#"+roiColors[i];
		setColor(thisColor);

		fillRect(x, (h+y)-i*hi, w, hi);
	}
//setBatchMode(false);

}
