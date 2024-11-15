include <./epsilon.scad>
include <./round_bevel.scad>

/********************************/

__SMALL_HINGE__THICKNESS = 5;
__SMALL_HINGE__PLUG_RADIUS = 3.5 / 2;
__SMALL_HINGE__CLEARANCE = 0.5;
__SMALL_HINGE__PLUG_CLEARANCE = 0.15;

__SMALL_HINGE__HINGE_SHAVE = 0.05;
__SMALL_HINGE__HINGE_SHAVE_BELOW_GEARS = 0.05;

__SMALL_HINGE__CUBE_HINGE_OFFSET_FOR_FULL_TOOTH = 0.16;
__SMALL_HINGE__GEAR_BACK_SPACING = 0.2;

__SMALL_HINGE__PLUG_LENGTH = 5;
__SMALL_HINGE__PLUG_FRUSTRUM_LENGTH = 2.5;
__SMALL_HINGE__PLUG_FRUSTRUM_END_RADIUS = 0.3;
__SMALL_HINGE__PLUG_VERTICAL_CLEARANCE = 0.15;

__SMALL_HINGE__GEAR_VERTICAL_CLEARANCE = 0.2; // for 0.2mm layer height
__SMALL_HINGE__GEAR_OFFSET_HEIGHT = __SMALL_HINGE__PLUG_LENGTH - __SMALL_HINGE__PLUG_FRUSTRUM_LENGTH / 2;

module __SMALL_HINGE__outer_hinge(h, gear_offset, flip_helix) union()
{
    gear_h = h - __SMALL_HINGE__GEAR_OFFSET_HEIGHT;

    difference()
    {
        cube([ __SMALL_HINGE__THICKNESS, __SMALL_HINGE__THICKNESS, h ]);

        translate([
            __SMALL_HINGE__CUBE_HINGE_OFFSET_FOR_FULL_TOOTH, __SMALL_HINGE__GEAR_BACK_SPACING,
            gear_h / 2 + __SMALL_HINGE__GEAR_OFFSET_HEIGHT + _EPSILON / 2
        ]) cube([ __SMALL_HINGE__THICKNESS, __SMALL_HINGE__THICKNESS, gear_h + _EPSILON ], center = true);
        translate([ 0, 0, __SMALL_HINGE__GEAR_OFFSET_HEIGHT / 2 - _EPSILON / 2 ]) rotate([ 0, 180, 0 ])
            round_bevel_complement(__SMALL_HINGE__THICKNESS / 2, __SMALL_HINGE__GEAR_OFFSET_HEIGHT + _EPSILON);

        translate([ -_EPSILON, -_EPSILON, __SMALL_HINGE__GEAR_OFFSET_HEIGHT - _EPSILON ])
            cube([ _EPSILON + __SMALL_HINGE__HINGE_SHAVE, __SMALL_HINGE__THICKNESS + 2 * _EPSILON, gear_h + _EPSILON ]);
        translate([ -_EPSILON, -_EPSILON, -_EPSILON ]) cube([
            _EPSILON + __SMALL_HINGE__HINGE_SHAVE_BELOW_GEARS, __SMALL_HINGE__THICKNESS + 2 * _EPSILON,
            __SMALL_HINGE__GEAR_OFFSET_HEIGHT +
            _EPSILON
        ]);
    }

    translate([ 0, 0, __SMALL_HINGE__GEAR_OFFSET_HEIGHT ]) intersection()
    {
        translate([ __SMALL_HINGE__CUBE_HINGE_OFFSET_FOR_FULL_TOOTH, 0, gear_h / 2 ])
            cube([ __SMALL_HINGE__THICKNESS, __SMALL_HINGE__THICKNESS, gear_h ], center = true);
        translate(
            [ __SMALL_HINGE__THICKNESS / 2, __SMALL_HINGE__THICKNESS / 2, __SMALL_HINGE__GEAR_VERTICAL_CLEARANCE ])
            rotate([ 0, 0, gear_offset ])
                linear_extrude(gear_h - __SMALL_HINGE__GEAR_VERTICAL_CLEARANCE,
                               twist = 90 * gear_h / __SMALL_HINGE__THICKNESS * (flip_helix ? -1 : 1)) offset(-0.05)
                    import("./small_hinge/involute_gear_5mm_8_teeth.svg", center = true);

        // TODO: do this better
        translate([ 0, 0, 0 ]) translate([ 0, 3, 0 ]) cylinder(r = __SMALL_HINGE__THICKNESS / 2 + 1.5, h = gear_h);
    }

    translate([ __SMALL_HINGE__THICKNESS / 2, __SMALL_HINGE__THICKNESS / 2, __SMALL_HINGE__GEAR_OFFSET_HEIGHT ])
        cylinder(r = 3.5 / 2, h = gear_h);
}

module __SMALL_HINGE__plug()
{
    translate([ 0, 0, -__SMALL_HINGE__PLUG_LENGTH + __SMALL_HINGE__PLUG_FRUSTRUM_LENGTH ])
        cylinder(h = __SMALL_HINGE__PLUG_LENGTH - __SMALL_HINGE__PLUG_FRUSTRUM_LENGTH +
                     __SMALL_HINGE__PLUG_VERTICAL_CLEARANCE + _EPSILON,
                 r = __SMALL_HINGE__PLUG_RADIUS);
    translate([ 0, 0, -__SMALL_HINGE__PLUG_LENGTH ])
        cylinder(h = __SMALL_HINGE__PLUG_FRUSTRUM_LENGTH, r1 = __SMALL_HINGE__PLUG_FRUSTRUM_END_RADIUS,
                 r2 = __SMALL_HINGE__PLUG_RADIUS);
}

module __SMALL_HINGE__port_negative()
{
    translate([ 0, 0, -__SMALL_HINGE__PLUG_LENGTH + __SMALL_HINGE__PLUG_FRUSTRUM_LENGTH ])
        cylinder(h = __SMALL_HINGE__PLUG_LENGTH - __SMALL_HINGE__PLUG_FRUSTRUM_LENGTH +
                     __SMALL_HINGE__PLUG_VERTICAL_CLEARANCE + _EPSILON,
                 r = __SMALL_HINGE__PLUG_RADIUS + __SMALL_HINGE__PLUG_CLEARANCE);
    translate([ 0, 0, -__SMALL_HINGE__PLUG_LENGTH ])
        cylinder(h = __SMALL_HINGE__PLUG_FRUSTRUM_LENGTH,
                 r1 = __SMALL_HINGE__PLUG_FRUSTRUM_END_RADIUS + __SMALL_HINGE__PLUG_CLEARANCE,
                 r2 = __SMALL_HINGE__PLUG_RADIUS + __SMALL_HINGE__PLUG_CLEARANCE);
}

module __SMALL_HINGE__half(gear_offset)
{
    difference()
    {
        union()
        {
            difference()
            {
                translate([ 0, 0, 10 ]) mirror([ 0, 0, 1 ]) __SMALL_HINGE__outer_hinge(10, gear_offset, false);
                translate([ __SMALL_HINGE__THICKNESS / 2, __SMALL_HINGE__THICKNESS / 2, 10 ])
                    __SMALL_HINGE__port_negative();
            }

            difference()
            {
                translate([ 0, 0, 20 ]) __SMALL_HINGE__outer_hinge(10, gear_offset, false);
                translate([ __SMALL_HINGE__THICKNESS / 2, __SMALL_HINGE__THICKNESS / 2, 20 ]) mirror([ 0, 0, -1 ])
                    __SMALL_HINGE__port_negative();
            }

            translate([ __SMALL_HINGE__THICKNESS / 2, __SMALL_HINGE__THICKNESS / 2, 10 ]) __SMALL_HINGE__plug();

            translate([ __SMALL_HINGE__THICKNESS / 2, __SMALL_HINGE__THICKNESS / 2, 20 ]) mirror([ 0, 0, 1 ])
                __SMALL_HINGE__plug();
        }
        // cube([ 100, 2.5, 100 ]);
    }

    translate(
        [ __SMALL_HINGE__THICKNESS / 2, __SMALL_HINGE__THICKNESS / 2, 10 + __SMALL_HINGE__PLUG_VERTICAL_CLEARANCE ])
        cylinder(h = 10 - 2 * __SMALL_HINGE__PLUG_VERTICAL_CLEARANCE, r = __SMALL_HINGE__THICKNESS / 2);

    translate([
        -_EPSILON, __SMALL_HINGE__THICKNESS / 2 - __SMALL_HINGE__THICKNESS / 2, 10 +
        __SMALL_HINGE__PLUG_VERTICAL_CLEARANCE
    ])
        cube([
            __SMALL_HINGE__THICKNESS / 2 + _EPSILON, __SMALL_HINGE__THICKNESS / 2 * 2, 10 - 2 *
            __SMALL_HINGE__PLUG_VERTICAL_CLEARANCE
        ]);

    // translate([ 5 - _EPSILON, 0, 0 ]) cube([ 7.5 + _EPSILON, 5, 5 ]);
    // translate([ 5 - _EPSILON, 0, 25 ]) cube([ 7.5 + _EPSILON, 5, 5 ]);
    // translate([ 7.5, 0, 0 ]) cube([ 5, 5, 30 ]);
}

module small_hinge_30mm()
{
    mirror([ 1, 0, 0 ]) __SMALL_HINGE__half(360 / 8 / 2);
    __SMALL_HINGE__half(0);
};
