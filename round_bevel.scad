include <./epsilon.scad>

module round_bevel_cylinder(height, radius, center_z = false, epsilon = _EPSILON) {
  translate([radius, radius, center_z ? 0 : height / 2])
    cylinder(h=height + 2 * epsilon, r=radius, center=true);
}

module round_bevel_complement(height, radius, center_z = false, epsilon = _EPSILON, cap_epsilon = _EPSILON) {
  lip = _EPSILON;
  difference() {
    translate([radius / 2 - lip / 2, radius / 2 - lip / 2, center_z ? 0 : height / 2])
      cube([radius + lip, radius + lip, height + 2 * epsilon], center=true);
    round_bevel_cylinder(height, radius, center_z=center_z, epsilon=cap_epsilon * 2);
  }
}
