// Black divider strip that sits in the groove between the two green
// light-pipe ridges on the NSM Emerald Ice side pillar.
// Print flat (as modelled), black PLA. 273 mm is longer than the A1's
// 256 mm bed, so rotate it to lie DIAGONALLY on the plate (~45 deg).
// Units mm.

length = 272;    // 10.75"
groove_w = 4.0;  // measured groove/strip width
clr = 0.2;       // total side clearance so it drops into the groove
thick = 2.0;     // depth (estimate; adjust)
end_r = 0;       // >0 rounds the ends (half the width = fully round)

// optional locating pegs for the rectangular holes in the groove.
// List each hole centre, measured in mm from the TOP end. Empty = no pegs.
pegs = [10, 80, 150, 220, 255];  // 4 holes 70 mm apart, 5th 35 mm after
peg_w = 2.0;         // across the groove
peg_l = 4.6;         // along the groove
peg_h = 2;           // how far it pokes into the hole

w = groove_w - clr;

module strip() {
    if (end_r > 0)
        hull() for (y = [end_r, length - end_r])
            translate([0, y, 0]) cylinder(h = thick, r = end_r, $fn = 32);
    else
        translate([-w/2, 0, 0]) cube([w, length, thick]);
}

strip();
// peg sits on the top face as printed (= the back face in the jukebox)
for (d = pegs)
    translate([-peg_w/2, length - d - peg_l/2, thick])
        cube([peg_w, peg_l, peg_h]);
