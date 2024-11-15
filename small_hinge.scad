include <./epsilon.scad>
include <./round_bevel.scad>

/********************************/

__SMALL_HINGE__THICKNESS = 5;
__SMALL_HINGE__PLUG_RADIUS = 3.5 / 2;
__SMALL_HINGE__CLEARANCE = 0.5;
__SMALL_HINGE__DEFAULT_PLUG_CLEARANCE = 0.15;

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

module __SMALL_HINGE__outer_hinge(h, gear_offset, flip_helix, round_far_side = false) union()
{
    gear_h = h - __SMALL_HINGE__GEAR_OFFSET_HEIGHT;

    difference()
    {
        cube([ __SMALL_HINGE__THICKNESS, __SMALL_HINGE__THICKNESS, h ]);

        translate([
            __SMALL_HINGE__CUBE_HINGE_OFFSET_FOR_FULL_TOOTH, __SMALL_HINGE__GEAR_BACK_SPACING - _EPSILON,
            gear_h / 2 + __SMALL_HINGE__GEAR_OFFSET_HEIGHT + _EPSILON / 2
        ]) cube([ __SMALL_HINGE__THICKNESS, __SMALL_HINGE__THICKNESS + _EPSILON, gear_h + _EPSILON ], center = true);
        translate([ 0, 0, -_EPSILON ])
            round_bevel_complement(__SMALL_HINGE__GEAR_OFFSET_HEIGHT + _EPSILON * 2, __SMALL_HINGE__THICKNESS / 2);

        if (round_far_side)
        {
            translate([ 0, __SMALL_HINGE__THICKNESS, 0 ]) rotate([ 0, 0, -90 ])
                round_bevel_complement(h, __SMALL_HINGE__THICKNESS / 2);
        }

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

module __SMALL_HINGE__port_negative(plug_clearance_scale)
{
    translate([ 0, 0, -__SMALL_HINGE__PLUG_LENGTH + __SMALL_HINGE__PLUG_FRUSTRUM_LENGTH ])
        cylinder(h = __SMALL_HINGE__PLUG_LENGTH - __SMALL_HINGE__PLUG_FRUSTRUM_LENGTH +
                     __SMALL_HINGE__PLUG_VERTICAL_CLEARANCE + _EPSILON,
                 r = __SMALL_HINGE__PLUG_RADIUS + __SMALL_HINGE__DEFAULT_PLUG_CLEARANCE * plug_clearance_scale);
    translate([ 0, 0, -__SMALL_HINGE__PLUG_LENGTH ]) cylinder(
        h = __SMALL_HINGE__PLUG_FRUSTRUM_LENGTH,
        r1 = __SMALL_HINGE__PLUG_FRUSTRUM_END_RADIUS + __SMALL_HINGE__DEFAULT_PLUG_CLEARANCE * plug_clearance_scale,
        r2 = __SMALL_HINGE__PLUG_RADIUS + __SMALL_HINGE__DEFAULT_PLUG_CLEARANCE * plug_clearance_scale);
}

module rotate_angle(angle, offset)
{
    translate(-offset) rotate([ 0, 0, -angle ]) translate(offset) children();
}

module __SMALL_HINGE__half(gear_offset, rotate_angle_each_side, plug_clearance_scale, round_far_side)
{
    difference()
    {
        union()
        {
            rotate_angle(rotate_angle_each_side, [ -__SMALL_HINGE__THICKNESS / 2, -__SMALL_HINGE__THICKNESS / 2, 0 ])
                difference()
            {
                translate([ 0, 0, 10 ]) mirror([ 0, 0, 1 ])
                    __SMALL_HINGE__outer_hinge(10, gear_offset, false, round_far_side = round_far_side);
                translate([ __SMALL_HINGE__THICKNESS / 2, __SMALL_HINGE__THICKNESS / 2, 10 ])
                    __SMALL_HINGE__port_negative(plug_clearance_scale = plug_clearance_scale);
            }

            rotate_angle(rotate_angle_each_side, [ -__SMALL_HINGE__THICKNESS / 2, -__SMALL_HINGE__THICKNESS / 2, 0 ])
                difference()
            {
                translate([ 0, 0, 20 ])
                    __SMALL_HINGE__outer_hinge(10, gear_offset, false, round_far_side = round_far_side);
                translate([ __SMALL_HINGE__THICKNESS / 2, __SMALL_HINGE__THICKNESS / 2, 20 ]) mirror([ 0, 0, -1 ])
                    __SMALL_HINGE__port_negative(plug_clearance_scale = plug_clearance_scale);
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
}

module small_hinge_30mm(rotate_angle_each_side = 0, plug_clearance_scale = 1, round_far_side = false)
{
    mirror([ 1, 0, 0 ])
        __SMALL_HINGE__half(360 / 8 / 2, rotate_angle_each_side = rotate_angle_each_side,
                            plug_clearance_scale = plug_clearance_scale, round_far_side = round_far_side);
    __SMALL_HINGE__half(0, rotate_angle_each_side = rotate_angle_each_side, plug_clearance_scale = plug_clearance_scale,
                        round_far_side = round_far_side);
};
