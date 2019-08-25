
button_diameter = 20;
chamfer_diameter = 4.0;
channel_width = 6.5;
tolerance = 0.5;

//--Clip----------------------------------------------------------------------------------------

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
       translate([0,0,9.0-chamfer_diameter]) torus(torus_diameter/2,chamfer_diameter/2.0,128,32);
       torus(torus_diameter/2,chamfer_diameter/2.0,128,32);
      }
    }
    rotate([0,10,0]) cylinder(h=18, d=button_diameter*2, $fn=64, center=true);
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
  }
}

module button_tab(){
    union(){
      difference(){
        translate([0,-button_diameter/2,0]) cube([button_diameter,button_diameter,3]);
        hull(){
          translate([0,-button_diameter/2,0]) cylinder(h=3, d=button_diameter/4,$fn=64);    
          translate([button_diameter/2,-button_diameter/2,0]) cylinder(h=3, d=button_diameter/2,$fn=64);
        }
        hull(){
          translate([0,button_diameter/2,0]) cylinder(h=3, d=button_diameter/4,$fn=64);    
          translate([button_diameter/2,button_diameter/2,0]) cylinder(h=3, d=button_diameter/2,$fn=64);
        }
      }
      button();
    }
}

module clip_base(tol=0.0){
  hull(){
    hull(){
      translate([button_diameter,-button_diameter/2 -button_diameter/4,chamfer_diameter/2]) sphere(d=chamfer_diameter+tol,$fn=32, $fa=32);
      translate([button_diameter,button_diameter/2 + button_diameter/4,chamfer_diameter/2]) sphere(d=chamfer_diameter+tol,$fn=32, $fa=32);
    }
    hull(){
      translate([-button_diameter+button_diameter/4,-button_diameter/2 -button_diameter/4,chamfer_diameter/2]) sphere(d=chamfer_diameter+tol,$fn=32, $fa=32);
      translate([-button_diameter+button_diameter/4,button_diameter/2 + button_diameter/4,chamfer_diameter/2]) sphere(d=chamfer_diameter+tol,$fn=32, $fa=32);
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
  union(){
    difference(){
      clip_main();
      scale([1,1,2]) diffcell();
    }
    button_tab();
  }
}


module clip_backa(){
  hull(){
    hull(){
      translate([channel_width/2+3,-button_diameter/2 -button_diameter/4,chamfer_diameter/2]) sphere(d=chamfer_diameter,$fn=32, $fa=32);
      translate([channel_width/2+3,button_diameter/2 + button_diameter/4,chamfer_diameter/2]) sphere(d=chamfer_diameter,$fn=32, $fa=32);
    }
    hull(){
      translate([-channel_width/2-3,-button_diameter/2 -button_diameter/4,chamfer_diameter/2]) sphere(d=chamfer_diameter,$fn=32, $fa=32);
      translate([-channel_width/2-3,button_diameter/2 + button_diameter/4,chamfer_diameter/2]) sphere(d=chamfer_diameter,$fn=32, $fa=32);
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
      /*
      hull(){
        translate([0,-button_diameter/2,0]) cylinder(h=9,d=channel_width,$fn=32);
        translate([0,button_diameter/2,0]) cylinder(h=9,d=channel_width,$fn=32);
      }
      hull(){
        hull(){
          translate([0,-button_diameter/2,6]) cylinder(h=9,d=channel_width,$fn=32);
          translate([0,button_diameter/2,6]) cylinder(h=9,d=channel_width,$fn=32);
        }
        hull(){
          translate([-channel_width*20,-button_diameter/2,6]) cylinder(h=9,d=channel_width,$fn=32);
          translate([-channel_width*20,button_diameter/2,6]) cylinder(h=9,d=channel_width,$fn=32);
        }
      }
      */

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
      hull(){
        translate([-channel_width/2-3,0,chamfer_diameter/2]) rotate([90,0,0]) cylinder(h=button_diameter+button_diameter/2,d=chamfer_diameter,$fn=32,center=true);
        translate([-channel_width/2-3+(channel_width-chamfer_diameter)/2,0,chamfer_diameter/2]) rotate([90,0,0]) cylinder(h=button_diameter+button_diameter/2,d=chamfer_diameter,$fn=32,center=true);
      }
      translate([0,0,6-chamfer_diameter])hull(){
        translate([-channel_width/2-3,0,chamfer_diameter/2]) rotate([90,0,0]) cylinder(h=button_diameter+button_diameter/2,d=chamfer_diameter,$fn=32,center=true);
        translate([-channel_width/2-3+(channel_width-chamfer_diameter)/2,0,chamfer_diameter/2]) rotate([90,0,0]) cylinder(h=button_diameter+button_diameter/2,d=chamfer_diameter,$fn=32,center=true);
      }
    }

  }
}

module clip(){
  union(){
    clip_parta();
    translate([-button_diameter+button_diameter/4 - channel_width/2 -3 -chamfer_diameter/2,0,0]) clip_back();
  }
}



//--Shell----------------------------------------------------------------------------------------

module shell_core(){
  hull(){
    hull(){
      translate([button_diameter+chamfer_diameter/2,-2-button_diameter/2 -button_diameter/4,chamfer_diameter/2]) sphere(d=chamfer_diameter,$fn=32, $fa=32);
      translate([button_diameter+chamfer_diameter/2,2+button_diameter/2 + button_diameter/4,chamfer_diameter/2]) sphere(d=chamfer_diameter,$fn=32, $fa=32);
    }
    hull(){
      translate([-button_diameter +button_diameter/4 +chamfer_diameter/2,-2 -button_diameter/2 -button_diameter/4,chamfer_diameter/2]) sphere(d=chamfer_diameter,$fn=32, $fa=32);
      translate([-button_diameter+button_diameter/4 +chamfer_diameter/2,2+button_diameter/2 + button_diameter/4,chamfer_diameter/2]) sphere(d=chamfer_diameter,$fn=32, $fa=32);
    }
  }
}

module shell_diff(tol=0.0){
  hull(){
    hull(){
      translate([button_diameter ,-button_diameter/2 -button_diameter/4,chamfer_diameter/2]) cylinder(h=chamfer_diameter, d=chamfer_diameter+tol,$fn=32, center=true);
      translate([button_diameter,button_diameter/2 + button_diameter/4,chamfer_diameter/2]) cylinder(h=chamfer_diameter, d=chamfer_diameter+tol,$fn=32, center=true);
    }
    hull(){
      translate([-button_diameter+button_diameter/4,-button_diameter/2 -button_diameter/4,chamfer_diameter/2]) cylinder(h=chamfer_diameter, d=chamfer_diameter+tol,$fn=32, center=true);
      translate([-button_diameter+button_diameter/4,button_diameter/2 + button_diameter/4,chamfer_diameter/2]) cylinder(h=chamfer_diameter, d=chamfer_diameter+tol,$fn=32, center=true);
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
    cylinder(h=10,d=button_diameter+1,$fn=128);
  }
}


module shell_backa(){
  hull(){
    hull(){
      translate([channel_width/2+3,-2-button_diameter/2 -button_diameter/4,chamfer_diameter/2]) sphere(d=chamfer_diameter,$fn=32, $fa=32);
      translate([channel_width/2+3,2+button_diameter/2 + button_diameter/4,chamfer_diameter/2]) sphere(d=chamfer_diameter,$fn=32, $fa=32);
    }
    hull(){
      translate([-channel_width/2-3,-2-button_diameter/2 -button_diameter/4,chamfer_diameter/2]) sphere(d=chamfer_diameter,$fn=32, $fa=32);
      translate([-channel_width/2-3,2+button_diameter/2 + button_diameter/4,chamfer_diameter/2]) sphere(d=chamfer_diameter,$fn=32, $fa=32);
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
      /*
      hull(){
        translate([0,-button_diameter/2,0]) cylinder(h=10,d=channel_width,$fn=32);
        translate([0,button_diameter/2,0]) cylinder(h=10,d=channel_width,$fn=32);
      }
      hull(){
        hull(){
          translate([0,-button_diameter/2,6]) cylinder(h=10,d=channel_width,$fn=32);
          translate([0,button_diameter/2,6]) cylinder(h=10,d=channel_width,$fn=32);
        }
        hull(){
          translate([-channel_width*20,-button_diameter/2,6]) cylinder(h=10,d=channel_width,$fn=32);
          translate([-channel_width*20,button_diameter/2,6]) cylinder(h=10,d=channel_width,$fn=32);
        }
      }
      */
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
      hull(){
        translate([-channel_width/2-3,0,chamfer_diameter/2]) rotate([90,0,0]) cylinder(h=button_diameter+button_diameter/2,d=chamfer_diameter,$fn=32,center=true);
        translate([-channel_width/2-3+(channel_width-chamfer_diameter)/2,0,chamfer_diameter/2]) rotate([90,0,0]) cylinder(h=button_diameter+button_diameter/2,d=chamfer_diameter,$fn=32,center=true);
      }
      translate([0,0,6-chamfer_diameter])hull(){
        translate([-channel_width/2-3,0,chamfer_diameter/2]) rotate([90,0,0]) cylinder(h=button_diameter+button_diameter/2,d=chamfer_diameter,$fn=32,center=true);
        translate([-channel_width/2-3+(channel_width-chamfer_diameter)/2,0,chamfer_diameter/2]) rotate([90,0,0]) cylinder(h=button_diameter+button_diameter/2,d=chamfer_diameter,$fn=32,center=true);
      }
    }
  
  
  }
}



module shell(){
  shell_base();
  translate([button_diameter+channel_width/2+3+chamfer_diameter+tolerance,0,9]) rotate([0,180,0]) shell_back();
}

//--Render--------------------------------------------------------------------------------------

clip();
shell();
//rotate([180,0,0]) shell();