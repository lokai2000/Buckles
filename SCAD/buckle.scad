include <meso_stretchy.scad>;

button_diameter = 16;
button_elliptical = 1.2;
chamfer_diameter = 5.5;
channel_width = 4.0;
tolerance = 0.5;

generate_slits = true;
slit_count = 1;
slit_width = 1.2;
slit_seperation = (button_diameter/4)/slit_count;


generate_clip_meso  = false;
generate_shell_meso = false;
mesosegs   = 90;
mesoradius = 2.25;
mesobands  = 4;

//--Clip----------------------------------------------------------------------------------------


chamfer_rez=32;

torus_diameter = button_diameter-chamfer_diameter;

module torus(r1, r2, rsa=128, rsb=128){
  rotate_extrude(convexity = 10, $fn = rsa)
  translate([r1, 0, 0])
  circle(r = r2, $fn = rsb);
}


module button(){
  intersection(){
    union(){
      translate([0,0,chamfer_diameter/2.0]) hull(){
       translate([0,0,8.0-chamfer_diameter]) torus(torus_diameter/2,chamfer_diameter/2.0,128,32);
       torus(torus_diameter/2,chamfer_diameter/2.0,128,4);
      }
    }
    rotate([0,20,0]) cylinder(h=16, d=button_diameter*2, $fn=64, center=true);
  }
}


module diffcell(){
  union(){
    cylinder(h=3,d=button_diameter + button_diameter/4,$fn=128);
    hull(){
      hull(){
        translate([0,-button_diameter/2,0]) cylinder(h=3, d=button_diameter/4,$fn=64);
        translate([button_diameter/2  + button_diameter/8,-button_diameter/2,0]) cylinder(h=3, d=button_diameter/4,$fn=64);
      }
      hull(){
        translate([0,button_diameter/2,0]) cylinder(h=3, d=button_diameter/4,$fn=64);
        translate([button_diameter/2  + button_diameter/8,button_diameter/2,0]) cylinder(h=3, d=button_diameter/4,$fn=64);
      }
    }
    hull(){
      translate([button_diameter/2  + button_diameter/4,-button_diameter/2,chamfer_diameter/2+1.75/2]) sphere(d=chamfer_diameter,$fn=64);
      translate([button_diameter/2  + button_diameter/4,button_diameter/2,chamfer_diameter/2+1.75/2]) sphere(d=chamfer_diameter,$fn=64);
    }
  }
}

module button_tab(){
    union(){
      difference(){
        translate([0,-button_diameter/2,0]) cube([button_diameter,button_diameter,1.75]);
        hull(){
          translate([0,-button_diameter/2,0]) cylinder(h=3, d=button_diameter/4,$fn=64);    
          translate([button_diameter/2,-button_diameter/2,0]) cylinder(h=3, d=button_diameter/2,$fn=64);
        }
        hull(){
          translate([0,button_diameter/2,0]) cylinder(h=3, d=button_diameter/4,$fn=64);    
          translate([button_diameter/2,button_diameter/2,0]) cylinder(h=3, d=button_diameter/2,$fn=64);
        }
      }
      scale([1,button_elliptical,1]) button();
    }
}



module clip_base(tol=0.0){
  hull(){
    hull(){
      translate([button_diameter,-button_diameter/2 -button_diameter/4,chamfer_diameter/2]) sphere(d=chamfer_diameter+tol,$fn=chamfer_rez);
      translate([button_diameter,button_diameter/2 + button_diameter/4,chamfer_diameter/2]) sphere(d=chamfer_diameter+tol,$fn=chamfer_rez);
    }
    hull(){
      translate([-button_diameter+button_diameter/4,-button_diameter/2 -button_diameter/4,chamfer_diameter/2]) sphere(d=chamfer_diameter+tol,$fn=chamfer_rez);
      translate([-button_diameter+button_diameter/4,button_diameter/2 + button_diameter/4,chamfer_diameter/2]) sphere(d=chamfer_diameter+tol,$fn=chamfer_rez);
    }
  }
}

module clip_main(tol=0.0){
    hull(){
      clip_base(tol);
      translate([0,0,6-chamfer_diameter]) clip_base(tol);
    }
}

module clip_parta(){
  slit_cnt = floor((slit_count-1)/2);
  difference(){
    union(){
      difference(){
        clip_main();
        scale([1,1,2]) diffcell();
        scale([1,button_elliptical,1]) cylinder(h=10,d=button_diameter+1.4,$fn=128);
      }
      button_tab();
    }
    if (generate_slits==true){
      hull(){
        translate([button_diameter/2.0+slit_width/2.0,0,0]) cylinder(h=10,d=slit_width,$fn=8);
        translate([button_diameter/2.0+button_diameter/4.0-slit_width/2.0,0,0]) cylinder(h=10,d=slit_width,$fn=8);
      }
      for (i=[0:slit_cnt]){
        translate([0,i*(slit_seperation+slit_width),0]) hull(){
          translate([button_diameter/2.0+slit_width/2.0,0,0]) cylinder(h=10,d=slit_width,$fn=8);
          translate([button_diameter/2.0+button_diameter/4.0-slit_width/2.0,0,0]) cylinder(h=10,d=slit_width,$fn=8);
        }
        translate([0,-i*(slit_seperation+slit_width),0]) hull(){
          translate([button_diameter/2.0+slit_width/2.0,0,0]) cylinder(h=10,d=slit_width,$fn=8);
          translate([button_diameter/2.0+button_diameter/4.0-slit_width/2.0,0,0]) cylinder(h=10,d=slit_width,$fn=8);
        }
      }
    }
  }
}


module clip_backa(){
  hull(){
    hull(){
      translate([channel_width/2+3,-button_diameter/2 -button_diameter/4,chamfer_diameter/2]) sphere(d=chamfer_diameter,$fn=chamfer_rez);
      translate([channel_width/2+3,button_diameter/2 + button_diameter/4,chamfer_diameter/2]) sphere(d=chamfer_diameter,$fn=chamfer_rez);
    }
    hull(){
      translate([-channel_width/2-3,-button_diameter/2 -button_diameter/4,chamfer_diameter/2]) sphere(d=chamfer_diameter,$fn=chamfer_rez);
      translate([-channel_width/2-3,button_diameter/2 + button_diameter/4,chamfer_diameter/2]) sphere(d=chamfer_diameter,$fn=chamfer_rez);
    }
  }
}

module clip_back(){
  union(){
    difference(){
      hull(){
        clip_backa();
        translate([0,0,9-chamfer_diameter]) clip_backa();
      }

      hull(){
        hull(){
          translate([0,-button_diameter/2,0]) cylinder(h=9,d=channel_width,$fn=32);
          translate([0,button_diameter/2,0]) cylinder(h=9,d=channel_width,$fn=32);
        }
        hull(){
          translate([-channel_width*20,-button_diameter/2,0]) cylinder(h=9,d=channel_width,$fn=32);
          translate([-channel_width*20,button_diameter/2,0]) cylinder(h=9,d=channel_width,$fn=32);
        }
      }
    }
    
    hull(){
      //hull(){
        translate([-channel_width/2-3,0,chamfer_diameter/2]) rotate([90,0,0]) cylinder(h=button_diameter+button_diameter/2,d=chamfer_diameter,$fn=chamfer_rez,center=true);
      //  translate([-channel_width/2-3+(channel_width-chamfer_diameter)/2,0,chamfer_diameter/2]) rotate([90,0,0]) cylinder(h=button_diameter+button_diameter/2,d=chamfer_diameter,$fn=chamfer_rez,center=true);
      //}
      
      //translate([0,0,6-chamfer_diameter])hull(){
        translate([0,0,6-chamfer_diameter]) translate([-channel_width/2-3,0,chamfer_diameter/2]) rotate([90,0,0]) cylinder(h=button_diameter+button_diameter/2,d=chamfer_diameter,$fn=chamfer_rez,center=true);
      //  translate([-channel_width/2-3+(channel_width-chamfer_diameter)/2,0,chamfer_diameter/2]) rotate([90,0,0]) cylinder(h=button_diameter+button_diameter/2,d=chamfer_diameter,$fn=chamfer_rez,center=true);
      //}
      
    }

  }
}

module clip(){

  clip_width = 1.5*button_diameter + chamfer_diameter;
  mesothick = 0.75;
  mesowidth = mesosegs * (mesoradius-mesothick);

  union(){
    clip_parta();
    if (generate_clip_meso==false){
      translate([-button_diameter+button_diameter/4 - channel_width/2 -3 -chamfer_diameter/2,0,0]) clip_back();
    } else {
      translate([-button_diameter+button_diameter/4,0,0]) rotate([0,0,180]) translate([0,-clip_width/2,0]) mesoStretch(mesosegs,mesobands,mesodiam=mesoradius, mesodis=(clip_width/mesobands)-mesoradius,mesoheight=6,mesowidth=mesothick);
      translate([-mesowidth -button_diameter+button_diameter/4 - channel_width/2 -3 ,0,0]) clip_back();
    }
  }
}



//--Shell----------------------------------------------------------------------------------------

module shell_core(){
  hull(){
    hull(){
      translate([button_diameter+chamfer_diameter/2,-2-button_diameter/2 -button_diameter/4,chamfer_diameter/2]) sphere(d=chamfer_diameter,$fn=chamfer_rez);
      translate([button_diameter+chamfer_diameter/2,2+button_diameter/2 + button_diameter/4,chamfer_diameter/2]) sphere(d=chamfer_diameter,$fn=chamfer_rez);
    }
    hull(){
      translate([-button_diameter +button_diameter/4 +chamfer_diameter/2,-2 -button_diameter/2 -button_diameter/4,chamfer_diameter/2]) sphere(d=chamfer_diameter,$fn=chamfer_rez);
      translate([-button_diameter+button_diameter/4 +chamfer_diameter/2,2+button_diameter/2 + button_diameter/4,chamfer_diameter/2]) sphere(d=chamfer_diameter,$fn=chamfer_rez);
    }
  }
}

module shell_diff(tol=0.0){
  hull(){
    hull(){
      translate([button_diameter ,-button_diameter/2 -button_diameter/4,chamfer_diameter/2]) cylinder(h=chamfer_diameter, d=chamfer_diameter+tol,$fn=chamfer_rez, center=true);
      translate([button_diameter,button_diameter/2 + button_diameter/4,chamfer_diameter/2]) cylinder(h=chamfer_diameter, d=chamfer_diameter+tol,$fn=chamfer_rez, center=true);
    }
    hull(){
      translate([-button_diameter+button_diameter/4,-button_diameter/2 -button_diameter/4,chamfer_diameter/2]) cylinder(h=chamfer_diameter, d=chamfer_diameter+tol,$fn=chamfer_rez, center=true);
      translate([-button_diameter+button_diameter/4,button_diameter/2 + button_diameter/4,chamfer_diameter/2]) cylinder(h=chamfer_diameter, d=chamfer_diameter+tol,$fn=chamfer_rez, center=true);
    }
  }
}


module shell_base(){
  difference(){
    hull(){
      translate([0,0,-1]) shell_core();
      translate([0,0,9-chamfer_diameter]) shell_core();
    }
    translate([0,0,0]) clip_main(tolerance);
    translate([0,0,-chamfer_diameter/2]) shell_diff(-2);
    scale([1,button_elliptical,1]) cylinder(h=10,d=button_diameter+0.7,$fn=128);
    scale([1,button_elliptical,1]) translate([0,0,8]) cylinder(h=10,d1=button_diameter+0.7,d2=button_diameter*1.5+0.7,$fn=128);
    //translate([-button_diameter+button_diameter/4,-button_diameter/3,6]) rotate([90,0,0]) cylinder(h=0.35*button_diameter*button_elliptical+0.7,d=4,$fn=4,center=true);
    //translate([-button_diameter+button_diameter/4,button_diameter/3,6]) rotate([90,0,0]) cylinder(h=0.35*button_diameter*button_elliptical+0.7,d=4,$fn=4,center=true);
    translate([-button_diameter+button_diameter/4,0,6]) rotate([90,0,0]) cylinder(h=button_diameter*button_elliptical+0.7,d=4,$fn=4,center=true);
  }
}



module shell_backa(){
  hull(){
    hull(){
      translate([channel_width/2+3,-button_diameter/2 -button_diameter/4,chamfer_diameter/2]) sphere(d=chamfer_diameter,$fn=chamfer_rez);
      translate([channel_width/2+3,button_diameter/2 + button_diameter/4,chamfer_diameter/2]) sphere(d=chamfer_diameter,$fn=chamfer_rez);
    }
    hull(){
      translate([-channel_width/2-3,-button_diameter/2 -button_diameter/4,chamfer_diameter/2]) sphere(d=chamfer_diameter,$fn=chamfer_rez);
      translate([-channel_width/2-3,button_diameter/2 + button_diameter/4,chamfer_diameter/2]) sphere(d=chamfer_diameter,$fn=chamfer_rez);
    }
  }
}

module shell_back(){
  union(){
    difference(){
      hull(){
        shell_backa();
        translate([0,0,10-chamfer_diameter]) shell_backa();
      }

      hull(){
          hull(){
            translate([0,-button_diameter/2,0]) cylinder(h=10,d=channel_width,$fn=32);
            translate([0,button_diameter/2,0]) cylinder(h=10,d=channel_width,$fn=32);
          }
          hull(){
            translate([-channel_width*20,-button_diameter/2,0]) cylinder(h=10,d=channel_width,$fn=32);
            translate([-channel_width*20,button_diameter/2,0]) cylinder(h=10,d=channel_width,$fn=32);
          }
        }
    }
  
    hull(){
      //hull(){
        translate([-channel_width/2-3,0,chamfer_diameter/2]) rotate([90,0,0]) cylinder(h=button_diameter+button_diameter/2,d=chamfer_diameter,$fn=chamfer_rez,center=true);
      //  translate([-channel_width/2-3+(channel_width-chamfer_diameter)/2,0,chamfer_diameter/2]) rotate([90,0,0]) cylinder(h=button_diameter+button_diameter/2,d=chamfer_diameter,$fn=chamfer_rez,center=true);
      //}
      //translate([0,0,6-chamfer_diameter])hull(){
        translate([0,0,6-chamfer_diameter]) translate([-channel_width/2-3,0,chamfer_diameter/2]) rotate([90,0,0]) cylinder(h=button_diameter+button_diameter/2,d=chamfer_diameter,$fn=chamfer_rez,center=true);
      //  translate([-channel_width/2-3+(channel_width-chamfer_diameter)/2,0,chamfer_diameter/2]) rotate([90,0,0]) cylinder(h=button_diameter+button_diameter/2,d=chamfer_diameter,$fn=chamfer_rez,center=true);
      //}
    }
  
  
  }
}



module shell(){

  clip_width = 1.5*button_diameter + chamfer_diameter;
  mesothick = 0.75;
  mesowidth = mesosegs * (mesoradius-mesothick);

  union(){
    shell_base();
  
    if (generate_shell_meso==false){
      translate([button_diameter+channel_width/2+3+chamfer_diameter+tolerance,0,9]) rotate([0,180,0]) shell_back();
    }else{
      translate([button_diameter+chamfer_diameter/2+tolerance,0,3]) translate([0,-clip_width/2,0]) mesoStretch(mesosegs,mesobands,mesodiam=mesoradius, mesodis=(clip_width/mesobands)-mesoradius,mesoheight=6,mesowidth=mesothick);
      translate([mesowidth+button_diameter+channel_width/2+chamfer_diameter,0,9]) rotate([0,180,0]) shell_back();
    }
  }

}

//--Render--------------------------------------------------------------------------------------

clip();
//shell();
//rotate([180,0,0]) shell();