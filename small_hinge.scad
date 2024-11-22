include <./epsilon.scad>
include <./round_bevel.scad>

/********************************/

__SMALL_HINGE__PLUG_RADIUS_FRACTION = 0.35;
__SMALL_HINGE__DEFAULT_PLUG_CLEARANCE = 0.15;

__SMALL_HINGE__HINGE_SHAVE = 0.05;
__SMALL_HINGE__HINGE_SHAVE_BELOW_GEARS = 0.1;

__SMALL_HINGE__CUBE_HINGE_OFFSET_FOR_FULL_TOOTH = 0.16;
__SMALL_HINGE__GEAR_BACK_SPACING = 0.2;

__SMALL_HINGE__PLUG_LENGTH = 5;
__SMALL_HINGE__PLUG_FRUSTRUM_LENGTH = 2.5;
__SMALL_HINGE__PLUG_FRUSTRUM_END_RADIUS = 0.3;
__SMALL_HINGE__PLUG_VERTICAL_CLEARANCE = 0.2;

__SMALL_HINGE__GEAR_VERTICAL_CLEARANCE = 0.2; // for 0.2mm layer height
__SMALL_HINGE__GEAR_OFFSET_HEIGHT = __SMALL_HINGE__PLUG_LENGTH - __SMALL_HINGE__PLUG_FRUSTRUM_LENGTH / 2;

module __SMALL_HINGE__outer_hinge_block(main_thickness, h, gear_offset, flip_helix, round_far_side,
                                        main_clearance_scale, shave_middle)
{
    gear_h = h - __SMALL_HINGE__GEAR_OFFSET_HEIGHT;

    difference()
    {
        cube([ main_thickness, main_thickness, h ]);

        translate([
            __SMALL_HINGE__CUBE_HINGE_OFFSET_FOR_FULL_TOOTH, __SMALL_HINGE__GEAR_BACK_SPACING - _EPSILON,
            gear_h / 2 + __SMALL_HINGE__GEAR_OFFSET_HEIGHT + _EPSILON / 2
        ]) cube([ main_thickness, main_thickness + _EPSILON, gear_h + _EPSILON ], center = true);
        translate([ 0, 0, -_EPSILON ])
            round_bevel_complement(__SMALL_HINGE__GEAR_OFFSET_HEIGHT + _EPSILON * 2, main_thickness / 2);

        if (round_far_side)
        {
            translate([ 0, main_thickness, 0 ]) rotate([ 0, 0, -90 ]) round_bevel_complement(h, main_thickness / 2);
        }

        //     translate([ -_EPSILON, -_EPSILON, __SMALL_HINGE__GEAR_OFFSET_HEIGHT - _EPSILON ]) cube([
        //         _EPSILON , main_thickness + 2 * _EPSILON,
        //         gear_h +
        //         _EPSILON
        //     ]);
        //     translate([ -_EPSILON, -_EPSILON, -_EPSILON ]) cube([
        //         _EPSILON,
        //         main_thickness + 2 * _EPSILON, __SMALL_HINGE__GEAR_OFFSET_HEIGHT +
        //         _EPSILON
        //     ]);
    }

    translate([ main_thickness / 2, main_thickness / 2, __SMALL_HINGE__GEAR_OFFSET_HEIGHT ])
        cylinder(r = 3.5 / 2, h = gear_h);
}

module __SMALL_HINGE__outer_hinge_gears(main_thickness, h, gear_offset, flip_helix, round_far_side,
                                        main_clearance_scale, shave_middle) union()
    translate([ 0, 0, __SMALL_HINGE__GEAR_OFFSET_HEIGHT ])
{
    gear_h = 10 - __SMALL_HINGE__GEAR_OFFSET_HEIGHT;
    intersection()
    {
        translate([ __SMALL_HINGE__CUBE_HINGE_OFFSET_FOR_FULL_TOOTH, 0, gear_h / 2 ])
            cube([ main_thickness, main_thickness, gear_h ], center = true);
        translate(
            [ main_thickness / 2, main_thickness / 2, __SMALL_HINGE__GEAR_VERTICAL_CLEARANCE * main_clearance_scale ])
            rotate([ 0, 0, gear_offset ])
                linear_extrude(gear_h - __SMALL_HINGE__GEAR_VERTICAL_CLEARANCE * main_clearance_scale,
                               twist = 90 * gear_h / main_thickness * (flip_helix ? -1 : 1)) offset(-0.05)
                    scale(main_thickness / 5) import("./small_hinge/involute_gear_5mm_8_teeth.svg", center = true);

        // TODO: do this better
        translate([ 0, 0, 0 ]) translate([ 0, 3, 0 ]) cylinder(r = main_thickness / 2 + 1.5, h = gear_h);
    }
}

module __SMALL_HINGE__plug(main_thickness)
{
    translate([ 0, 0, -__SMALL_HINGE__PLUG_LENGTH + __SMALL_HINGE__PLUG_FRUSTRUM_LENGTH ])
        cylinder(h = __SMALL_HINGE__PLUG_LENGTH - __SMALL_HINGE__PLUG_FRUSTRUM_LENGTH +
                     __SMALL_HINGE__PLUG_VERTICAL_CLEARANCE + _EPSILON,
                 r = main_thickness * __SMALL_HINGE__PLUG_RADIUS_FRACTION);
    translate([ 0, 0, -__SMALL_HINGE__PLUG_LENGTH ])
        cylinder(h = __SMALL_HINGE__PLUG_FRUSTRUM_LENGTH, r1 = __SMALL_HINGE__PLUG_FRUSTRUM_END_RADIUS,
                 r2 = main_thickness * __SMALL_HINGE__PLUG_RADIUS_FRACTION);
}

module __SMALL_HINGE__port_negative(main_thickness, plug_clearance_scale)
{
    translate([ 0, 0, -__SMALL_HINGE__PLUG_LENGTH + __SMALL_HINGE__PLUG_FRUSTRUM_LENGTH ])
        cylinder(h = __SMALL_HINGE__PLUG_LENGTH - __SMALL_HINGE__PLUG_FRUSTRUM_LENGTH +
                     __SMALL_HINGE__PLUG_VERTICAL_CLEARANCE + _EPSILON,
                 r = main_thickness * __SMALL_HINGE__PLUG_RADIUS_FRACTION +
                     __SMALL_HINGE__DEFAULT_PLUG_CLEARANCE * plug_clearance_scale);
    translate([ 0, 0, -__SMALL_HINGE__PLUG_LENGTH ]) cylinder(
        h = __SMALL_HINGE__PLUG_FRUSTRUM_LENGTH,
        r1 = __SMALL_HINGE__PLUG_FRUSTRUM_END_RADIUS + __SMALL_HINGE__DEFAULT_PLUG_CLEARANCE * plug_clearance_scale,
        r2 = main_thickness * __SMALL_HINGE__PLUG_RADIUS_FRACTION +
             __SMALL_HINGE__DEFAULT_PLUG_CLEARANCE * plug_clearance_scale);
}

module __SMALL_HINGE__rotate_angle(main_thickness, angle, offset)
{
    translate(-offset) rotate([ 0, 0, -angle ]) translate(offset) children();
}

module __SMALL_HINGE__bottom(main_thickness, gear_offset, rotate_angle_each_side, plug_clearance_scale, round_far_side,
                             main_clearance_scale)
{

    mirror([ 1, 0, 0 ]) difference()
    {

        union()
        {
            gear_h = 10 - __SMALL_HINGE__GEAR_OFFSET_HEIGHT;
            difference()
            {
                __SMALL_HINGE__rotate_angle(main_thickness, rotate_angle_each_side,
                                            [ -main_thickness / 2, -main_thickness / 2, 0 ]) translate([ 0, 0, 10 ])
                    mirror([ 0, 0, 1 ]) __SMALL_HINGE__outer_hinge_block(main_thickness, 10, gear_offset, false,
                                                                         round_far_side = round_far_side,
                                                                         main_clearance_scale = main_clearance_scale);
                translate([ 0, 0, 10 ]) mirror([ 0, 0, 1 ])
                    translate([ -_EPSILON, -_EPSILON, __SMALL_HINGE__GEAR_OFFSET_HEIGHT - _EPSILON ]) cube(
                        [ _EPSILON + __SMALL_HINGE__HINGE_SHAVE, main_thickness + 2 * _EPSILON, gear_h + _EPSILON ]);
                translate([ 0, 0, 10 ]) mirror([ 0, 0, 1 ]) translate([ -_EPSILON, -_EPSILON, -_EPSILON ]) cube([
                    _EPSILON + __SMALL_HINGE__HINGE_SHAVE_BELOW_GEARS * main_clearance_scale,
                    main_thickness + 2 * _EPSILON, __SMALL_HINGE__GEAR_OFFSET_HEIGHT +
                    _EPSILON
                ]);
            }

            __SMALL_HINGE__rotate_angle(main_thickness, rotate_angle_each_side,
                                        [ -main_thickness / 2, -main_thickness / 2, 0 ]) translate([ 0, 0, 10 ])
                mirror([ 0, 0, 1 ]) __SMALL_HINGE__outer_hinge_gears(main_thickness, 10, gear_offset, false,
                                                                     round_far_side = round_far_side,
                                                                     main_clearance_scale = main_clearance_scale);
        }

        __SMALL_HINGE__rotate_angle(main_thickness, rotate_angle_each_side,
                                    [ -main_thickness / 2, -main_thickness / 2, 0 ])
            translate([ main_thickness / 2, main_thickness / 2, 10 ])
                __SMALL_HINGE__port_negative(main_thickness, plug_clearance_scale = plug_clearance_scale);
    }
}

module __SMALL_HINGE__half(main_thickness, gear_offset, rotate_angle_each_side, plug_clearance_scale, round_far_side,
                           main_clearance_scale)
{
    difference()
    {
        union()
        {
            __SMALL_HINGE__bottom(main_thickness, gear_offset, rotate_angle_each_side, plug_clearance_scale,
                                  round_far_side, main_clearance_scale);
            translate([ 0, 0, 30 ]) mirror([ 0, 0, 1 ]) mirror([ 1, 0, 0 ])
                __SMALL_HINGE__bottom(main_thickness, gear_offset, rotate_angle_each_side, plug_clearance_scale,
                                      round_far_side, main_clearance_scale);

            translate([ main_thickness / 2, main_thickness / 2, 10 ]) __SMALL_HINGE__plug(main_thickness);

            translate([ main_thickness / 2, main_thickness / 2, 20 ]) mirror([ 0, 0, 1 ])
                __SMALL_HINGE__plug(main_thickness);
        }
        // cube([ 100, 2.5, 100 ]);
    }

    translate([ main_thickness / 2, main_thickness / 2, 10 + __SMALL_HINGE__PLUG_VERTICAL_CLEARANCE ])
        cylinder(h = 10 - 2 * __SMALL_HINGE__PLUG_VERTICAL_CLEARANCE, r = main_thickness / 2);

    translate([ -_EPSILON, main_thickness / 2 - main_thickness / 2, 10 + __SMALL_HINGE__PLUG_VERTICAL_CLEARANCE ]) cube(
        [ main_thickness / 2 + _EPSILON, main_thickness / 2 * 2, 10 - 2 * __SMALL_HINGE__PLUG_VERTICAL_CLEARANCE ]);
}

module small_hinge_30mm(main_thickness = 5, rotate_angle_each_side = 0, plug_clearance_scale = 1,
                        main_clearance_scale = 1, round_far_side = false, common_gear_offset = 0)
{
    mirror([ 1, 0, 0 ])
        __SMALL_HINGE__half(main_thickness, common_gear_offset, rotate_angle_each_side = rotate_angle_each_side,
                            main_clearance_scale = main_clearance_scale, plug_clearance_scale = plug_clearance_scale,
                            round_far_side = round_far_side);
    __SMALL_HINGE__half(main_thickness, 360 / 8 / 2 + common_gear_offset,
                        rotate_angle_each_side = rotate_angle_each_side, main_clearance_scale = main_clearance_scale,
                        plug_clearance_scale = plug_clearance_scale, round_far_side = round_far_side);
};
