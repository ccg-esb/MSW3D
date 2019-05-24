/*
*   RPM (29/05/2015)
*   
*
*/
d=.02;
box_width=113.5;
box_height=113.5*.75;
box_depth=10;
box_padding=3;

numRows=3;    //Number of wells per row
numCols=5;    //Number of rows

/*****************************/
well_diameter=(box_width-box_padding)/(numCols+numCols/2);
well_depth=3*box_depth/4;
channel_depth=well_depth/3;

dw=well_diameter/2;
dh=((box_height-box_padding)-numRows*well_diameter)/(numRows+1);
sigma_max=well_diameter/2;
diameter_round=(box_width+box_padding)/5;
shift_round=.35*(box_width+box_padding)-diameter_round/2;

/*****************************/

scale([.5,.5,.5]) device();

module device(){

    difference() {
        
        //PLATE
        //intersection(){
           
        //    cube([box_width+box_padding,box_height+box_padding,box_depth], center=true);
           /*
            #union(){
                translate([-shift_round,shift_round,0],center=true) cylinder( h=box_depth, r=diameter_round/2, center=true);  
                translate([shift_round,shift_round,0],center=true) cylinder( h=box_depth, r=diameter_round/2, center=true);  
                translate([shift_round,-shift_round,0],center=true) cylinder( h=box_depth, r=diameter_round/2, center=true);  
                translate([-shift_round,-shift_round,0],center=true) cylinder( h=box_depth, r=diameter_round/2, center=true); 
                cube(size=[box_width+box_padding, box_width+box_padding-diameter_round,box_depth], center=true);
                cube(size=[box_width+box_padding-diameter_round,box_width+box_padding, box_depth], center=true);
            }
            */
            for ( r = [0:numRows-1] ){
                //shift_y=((box_height-box_padding)/2-well_diameter/2)-r*well_diameter-(r+1)*dh;
                shift_y=28*r;
                translate([0,shift_y,0]) roundedcube([box_width+box_padding, (box_height/3)-box_padding, box_depth], true, 5, "z");
            }
        //}
        //WELLS
        union() {
            for ( r = [0:numRows-1] ){
                shift_y=28*r;
                //shift_y=((box_height-box_padding)/2-well_diameter/2)-r*well_diameter-(r+1)*dh;
                shift_z=(box_depth-well_depth)/2;
                for ( c = [0 : numCols-1] ){
                    shift_x=(-(box_width-box_padding)/2+well_diameter/2)+dw/2+ c*well_diameter+c*dw;
                    translate([shift_x,shift_y,shift_z],center=true) cylinder( h=well_depth, r=well_diameter/2.5, center=true, $fn=100); 
                    translate([shift_x,shift_y,channel_depth+d],center=true) cylinder( h=2*channel_depth, r=well_diameter/2, center=true, $fn=100); 
                }
                sigma=(r)*sigma_max/numRows;
                translate([0,shift_y,-channel_depth/2],center=true)  cube(size=[numCols*(well_diameter+dw)-2*dw,sigma,channel_depth], center=true); 
             }
        }
    }
}
/*******************/

module roundedcube(size = [1, 1, 1], center = false, radius = 0.5, apply_to = "all") {
	// If single value, convert to [x, y, z] vector
	size = (size[0] == undef) ? [size, size, size] : size;

	translate_min = radius;
	translate_xmax = size[0] - radius;
	translate_ymax = size[1] - radius;
	translate_zmax = size[2] - radius;

	diameter = radius * 2;

	obj_translate = (center == false) ?
		[0, 0, 0] : [
			-(size[0] / 2),
			-(size[1] / 2),
			-(size[2] / 2)
		];

	translate(v = obj_translate) {
		hull() {
			for (translate_x = [translate_min, translate_xmax]) {
				x_at = (translate_x == translate_min) ? "min" : "max";
				for (translate_y = [translate_min, translate_ymax]) {
					y_at = (translate_y == translate_min) ? "min" : "max";
					for (translate_z = [translate_min, translate_zmax]) {
						z_at = (translate_z == translate_min) ? "min" : "max";

						translate(v = [translate_x, translate_y, translate_z])
						if (
							(apply_to == "all") ||
							(apply_to == "xmin" && x_at == "min") || (apply_to == "xmax" && x_at == "max") ||
							(apply_to == "ymin" && y_at == "min") || (apply_to == "ymax" && y_at == "max") ||
							(apply_to == "zmin" && z_at == "min") || (apply_to == "zmax" && z_at == "max")
						) {
							sphere(r = radius);
						} else {
							rotate = 
								(apply_to == "xmin" || apply_to == "xmax" || apply_to == "x") ? [0, 90, 0] : (
								(apply_to == "ymin" || apply_to == "ymax" || apply_to == "y") ? [90, 90, 0] :
								[0, 0, 0]
							);
							rotate(a = rotate)
							cylinder(h = diameter, r = radius, center = true);
						}
					}
				}
			}
		}
	}
}

echo(version=version());


