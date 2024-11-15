include <./epsilon.scad>

module round_bevel_cylinder(radius, width, center_z = false, epsilon = _EPSILON)
{
    translate([ radius, radius, center_z ? 0 : width / 2 ])
        cylinder(h = width + 2 * epsilon, r = radius, center = true);
}

module round_bevel_complement(radius, width, center_z = false, epsilon = _EPSILON)
{
    lip = _EPSILON;
    difference()
    {
        translate([ radius / 2 - lip / 2, radius / 2 - lip / 2, center_z ? 0 : width / 2 ])
            cube([ radius + lip, radius + lip, width + 2 * epsilon ], center = true);
        round_bevel_cylinder(radius, width, center_z = center_z, epsilon = epsilon * 2);
    }
}
