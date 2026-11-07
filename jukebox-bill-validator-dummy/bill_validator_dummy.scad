// Dummy MEI-style bill validator plug for NSM Emerald Ice jukebox
// Print FACE DOWN on the textured PEI plate (z=0 is the visible front face).
// All units mm.

$fn = 48;

// ---- Measured opening (calipers) ----
open_w = 82.55;   // 3.25"
open_h = 38.10;   // 1.50"

// ---- Fit tuning ----
clr    = 0.30;    // total clearance per axis on the sleeve body
rib    = 0.35;    // crush-rib interference per side (raise if loose, lower if tight)

// ---- Shape ----
lip       = 4;    // front flange overhang past the opening, each side
face_t    = 4;    // front flange thickness
depth     = 14;   // how far the sleeve goes into the hole
wall      = 2;    // sleeve wall thickness
corner_r  = 2.5;

sleeve_w = open_w - clr;
sleeve_h = open_h - clr;
face_w   = open_w + 2*lip;
face_h   = open_h + 2*lip;

module rrect(w, h, r, t) {
    linear_extrude(t) offset(r) square([w - 2*r, h - 2*r], center = true);
}

// rib running along the sleeve (z), tapered at the back for lead-in
module rib_at(x, y) {
    rr = 1.2;
    len = depth - 2;
    translate([x, y, face_t + 2]) {
        cylinder(h = len - 3, r = rr);
        translate([0, 0, len - 3]) cylinder(h = 3, r1 = rr, r2 = 0.3);
    }
}

module body() {
    // front flange with a 1 mm chamfer on the visible edge
    hull() {
        rrect(face_w - 2, face_h - 2, corner_r, 0.01);
        translate([0, 0, 1]) rrect(face_w, face_h, corner_r, face_t - 1);
    }
    // hollow sleeve
    translate([0, 0, face_t]) difference() {
        rrect(sleeve_w, sleeve_h, 1.5, depth);
        translate([0, 0, -1]) rrect(sleeve_w - 2*wall, sleeve_h - 2*wall, 0.5, depth + 2);
    }
    // crush ribs: rib centre sits so it protrudes (clr/2 + rib) past the sleeve
    off = 1.2 - (clr/2 + rib);
    for (x = [-26, 0, 26]) {
        rib_at(x,  sleeve_h/2 - off);
        rib_at(x, -sleeve_h/2 + off);
    }
    for (y = [-8, 8]) {
        rib_at( sleeve_w/2 - off, y);
        rib_at(-sleeve_w/2 + off, y);
    }
}

slot_y = 6;

module front_details() {
    // funnel mouth tapering into the bill slot
    translate([0, slot_y, 0]) hull() {
        translate([0, 0, -0.01]) rrect(76, 10, 1.5, 0.01);
        translate([0, 0, 2.2]) rrect(70, 3, 0.6, 0.01);
    }
    // the slot itself (blind, leaves 0.6 mm skin)
    translate([0, slot_y, 2]) rrect(70, 3, 0.6, face_t - 0.6 - 2);

    // LED dimples at each end of the slot
    for (x = [-41, 41]) translate([x, slot_y, -0.01]) cylinder(h = 1, d = 2.6);

    // "insert this way" arrow pointing up toward the slot
    translate([0, -9, -0.01]) linear_extrude(0.8) union() {
        polygon([[-6, 0], [6, 0], [0, 6]]);
        translate([-1.75, -6]) square([3.5, 6.01]);
    }
}

difference() {
    body();
    front_details();
}
