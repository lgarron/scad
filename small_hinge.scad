include <./epsilon.scad>
include <./round_bevel.scad>

/********************************/

__SMALL_HINGE__PLUG_RADIUS_FRACTION = 0.35;
__SMALL_HINGE__DEFAULT_PLUG_CLEARANCE = 0.15;

__SMALL_HINGE__HINGE_SHAVE = 0.15;
__SMALL_HINGE__HINGE_SHAVE_BELOW_GEARS = 0.15;

__SMALL_HINGE__END_TANGENT_SHAVE = 0.15;

__SMALL_HINGE__GEAR_VERTICAL_BACK_GUTTER = 0.2;
__SMALL_HINGE__GEAR_VERTICAL_FRONT_GUTTER = 0.2;

__SMALL_HINGE__PLUG_LENGTH = 5;
__SMALL_HINGE__PLUG_FRUSTRUM_LENGTH = 2.5;
__SMALL_HINGE__PLUG_FRUSTRUM_END_RADIUS = 0.3;
__SMALL_HINGE__PLUG_VERTICAL_CLEARANCE = 0.2;

// Fraction of the effective gear radius which the gear is outset and inset.
// This fraction the same by choice of gear design.
// TODO: this value is supposed to be exact but appears to be off by a few hundredths of a mm. It's not stroke width, so
// what is it?
__SMALL_HINGE__MAX_RADIAL_DIVERGENCE_FACTOR = 0.25;

__SMALL_HINGE__GEAR_VERTICAL_CLEARANCE = 0.2; // for 0.2mm layer height
__SMALL_HINGE__GEAR_OFFSET_HEIGHT = __SMALL_HINGE__PLUG_LENGTH - __SMALL_HINGE__PLUG_FRUSTRUM_LENGTH / 2;

__SMALL_HINGE__CONNECTOR_OUTSIDE_CLEARANCE = 0.2;

module rotate_extra_degrees(main_thickness, extra_degrees)
{
    translate([ main_thickness / 2, main_thickness / 2, 0 ]) rotate([ 0, 0, extra_degrees ])
        translate([ -main_thickness / 2, -main_thickness / 2, 0 ]) children();
}

module __SMALL_HINGE__outer_hinge_block(main_thickness, h, gear_offset, flip_helix, round_far_side,
                                        main_clearance_scale, shave_middle, extra_degrees, shave_end_tangents,
                                        extend_block_ends)
{
    gear_h_spaced = h - __SMALL_HINGE__GEAR_OFFSET_HEIGHT + __SMALL_HINGE__GEAR_VERTICAL_CLEARANCE;
    block_h = h + extend_block_ends;

    difference()
    {
        cube([ main_thickness, main_thickness, h + extend_block_ends ]);

        union()
        {
            translate([
                0, __SMALL_HINGE__GEAR_VERTICAL_BACK_GUTTER - _EPSILON,
                gear_h_spaced / 2 + __SMALL_HINGE__GEAR_OFFSET_HEIGHT + _EPSILON / 2
            ]) cube([ main_thickness, main_thickness + _EPSILON, gear_h_spaced + _EPSILON ], center = true);

            rotate_extra_degrees(main_thickness = main_thickness, extra_degrees = extra_degrees - 90)
                translate([ main_thickness, 0, gear_h_spaced / 2 + __SMALL_HINGE__GEAR_OFFSET_HEIGHT + _EPSILON / 2 ])
                    cube([ main_thickness, main_thickness + _EPSILON, gear_h_spaced + _EPSILON ], center = true);
            rotate_extra_degrees(main_thickness = main_thickness, extra_degrees = extra_degrees - 90) translate([
                main_thickness + (1 - __SMALL_HINGE__MAX_RADIAL_DIVERGENCE_FACTOR) * main_thickness / 2,
                __SMALL_HINGE__GEAR_VERTICAL_FRONT_GUTTER,
                gear_h_spaced / 2 + __SMALL_HINGE__GEAR_OFFSET_HEIGHT + _EPSILON / 2
            ]) cube([ main_thickness, main_thickness + _EPSILON, gear_h_spaced + _EPSILON ], center = true);
        }
        translate([ 0, 0, -_EPSILON ])
            round_bevel_complement(__SMALL_HINGE__GEAR_OFFSET_HEIGHT + _EPSILON * 2, main_thickness / 2);

        translate([ 0, 0, 10 + __SMALL_HINGE__PLUG_VERTICAL_CLEARANCE - _EPSILON ])
            round_bevel_complement(extend_block_ends + _EPSILON, main_thickness / 2);

        translate([ 0, 0, -_EPSILON ])
            rotate_extra_degrees(main_thickness = main_thickness, extra_degrees = extra_degrees)
                round_bevel_complement(__SMALL_HINGE__GEAR_OFFSET_HEIGHT + _EPSILON * 2, main_thickness / 2);

        translate([ 0, 0, 10 + __SMALL_HINGE__PLUG_VERTICAL_CLEARANCE - _EPSILON ])
            rotate_extra_degrees(main_thickness = main_thickness, extra_degrees = extra_degrees)
                round_bevel_complement(extend_block_ends + _EPSILON, main_thickness / 2);

        rotate_extra_degrees(main_thickness = main_thickness, extra_degrees = extra_degrees) translate([
            main_thickness / 2, -main_thickness / 2 + (shave_end_tangents ? __SMALL_HINGE__END_TANGENT_SHAVE : 0),
            block_h / 2
        ]) cube([ main_thickness, main_thickness, block_h ], center = true);

        if (round_far_side)
        {
            translate([ 0, main_thickness, 0 ]) rotate([ 0, 0, -90 ])
                round_bevel_complement(block_h, main_thickness / 2);
        }

        //     translate([ -_EPSILON, -_EPSILON, __SMALL_HINGE__GEAR_OFFSET_HEIGHT - _EPSILON ]) cube([
        //         _EPSILON , main_thickness + 2 * _EPSILON,
        //         gear_h_spaced +
        //         _EPSILON
        //     ]);
        //     translate([ -_EPSILON, -_EPSILON, -_EPSILON ]) cube([
        //         _EPSILON,
        //         main_thickness + 2 * _EPSILON, __SMALL_HINGE__GEAR_OFFSET_HEIGHT +
        //         _EPSILON
        //     ]);
    }

    translate([ main_thickness / 2, main_thickness / 2, __SMALL_HINGE__GEAR_OFFSET_HEIGHT ])
        cylinder(r = 3.5 / 2, h = block_h - __SMALL_HINGE__GEAR_OFFSET_HEIGHT);
}

module __SMALL_HINGE__outer_hinge_gears(main_thickness, h, gear_offset, flip_helix, round_far_side,
                                        main_clearance_scale, shave_middle, extra_degrees, shave_end_tangents) union()
    translate([ 0, 0, __SMALL_HINGE__GEAR_OFFSET_HEIGHT ])
{
    gear_h = 10 - __SMALL_HINGE__GEAR_OFFSET_HEIGHT;

    difference()
    {
        translate(
            [ main_thickness / 2, main_thickness / 2, __SMALL_HINGE__GEAR_VERTICAL_CLEARANCE * main_clearance_scale ])
            rotate([ 0, 0, gear_offset ])
                linear_extrude(gear_h - __SMALL_HINGE__GEAR_VERTICAL_CLEARANCE * main_clearance_scale,
                               twist = 90 * gear_h / main_thickness * (flip_helix ? -1 : 1)) offset(-0.05)
                    scale(main_thickness / 5) import("./small_hinge/involute_gear_5mm_8_teeth.svg", center = true);

        rotate_extra_degrees(main_thickness = main_thickness, extra_degrees = extra_degrees - 90) translate(
            [ main_thickness, main_thickness + __SMALL_HINGE__GEAR_VERTICAL_FRONT_GUTTER + _EPSILON, gear_h / 2 ])
            cube([ main_thickness * 2, main_thickness, gear_h ], center = true);
        rotate_extra_degrees(main_thickness = main_thickness, extra_degrees = extra_degrees - 90) translate([
            main_thickness * 1.5 - ((shave_end_tangents ? __SMALL_HINGE__END_TANGENT_SHAVE : 0)), main_thickness,
            gear_h / 2
        ]) cube([ main_thickness, main_thickness, gear_h ], center = true);
        translate([ main_thickness / 2, main_thickness + __SMALL_HINGE__GEAR_VERTICAL_BACK_GUTTER, gear_h / 2 ])
            cube([ main_thickness * 2, main_thickness, gear_h ], center = true);

        translate([
            -main_thickness / 2 + (shave_end_tangents ? __SMALL_HINGE__END_TANGENT_SHAVE : __SMALL_HINGE__HINGE_SHAVE),
            main_thickness, gear_h / 2
        ]) cube([ main_thickness, main_thickness, gear_h ], center = true);

        // TODO: add  a little clearance?
        rotate_extra_degrees(main_thickness = main_thickness, extra_degrees = extra_degrees)
            translate([ main_thickness / 2, -main_thickness, 0 ]) rotate([ 0, 0, 90 ])
                round_bevel_complement(gear_h, main_thickness);
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
                             main_clearance_scale, extra_degrees, shave_end_tangents, extend_block_ends)
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
                    mirror([ 0, 0, 1 ]) difference()
                {
                    __SMALL_HINGE__outer_hinge_block(
                        main_thickness, 10, gear_offset, false, round_far_side = round_far_side,
                        main_clearance_scale = main_clearance_scale, extra_degrees = extra_degrees,
                        shave_end_tangents = shave_end_tangents, extend_block_ends = extend_block_ends);

                    if (shave_end_tangents)
                    {
                        translate([ 0, 0, 10 ]) mirror([ 0, 0, 1 ]) translate([ -_EPSILON, -_EPSILON, -_EPSILON ])
                            cube([
                                _EPSILON + (shave_end_tangents ? __SMALL_HINGE__END_TANGENT_SHAVE
                                                               : (shave_end_tangents ? __SMALL_HINGE__END_TANGENT_SHAVE
                                                                                     : __SMALL_HINGE__HINGE_SHAVE)) *
                                               main_clearance_scale,
                                main_thickness + 2 * _EPSILON, 10 + 2 *
                                _EPSILON
                            ]);
                    }
                }
                translate([ 0, 0, 10 ]) mirror([ 0, 0, 1 ])
                    translate([ -_EPSILON, -_EPSILON, __SMALL_HINGE__GEAR_OFFSET_HEIGHT - _EPSILON ]) cube([
                        _EPSILON + (shave_end_tangents ? __SMALL_HINGE__END_TANGENT_SHAVE : __SMALL_HINGE__HINGE_SHAVE),
                        main_thickness + 2 * _EPSILON, gear_h +
                        _EPSILON
                    ]);
                translate([ 0, 0, 10 ]) mirror([ 0, 0, 1 ]) translate([ -_EPSILON, -_EPSILON, -_EPSILON ]) cube([
                    _EPSILON + __SMALL_HINGE__HINGE_SHAVE * main_clearance_scale, main_thickness + 2 * _EPSILON,
                    __SMALL_HINGE__GEAR_OFFSET_HEIGHT +
                    _EPSILON
                ]);
                translate([ 0, 0, 10 ]) mirror([ 0, 0, 1 ]) //
                    translate([ -_EPSILON, -_EPSILON, 10 - _EPSILON ]) cube([
                        _EPSILON + __SMALL_HINGE__HINGE_SHAVE * main_clearance_scale, main_thickness + 2 * _EPSILON,
                        extend_block_ends + 2 *
                        _EPSILON
                    ]);
            }

            __SMALL_HINGE__rotate_angle(main_thickness, rotate_angle_each_side,
                                        [ -main_thickness / 2, -main_thickness / 2, 0 ]) translate([ 0, 0, 10 ])
                mirror([ 0, 0, 1 ]) __SMALL_HINGE__outer_hinge_gears(
                    main_thickness, 10, gear_offset, false, round_far_side = round_far_side,
                    main_clearance_scale = main_clearance_scale, extra_degrees = extra_degrees,
                    shave_end_tangents = shave_end_tangents);
        }

        __SMALL_HINGE__rotate_angle(main_thickness, rotate_angle_each_side,
                                    [ -main_thickness / 2, -main_thickness / 2, 0 ])
            translate([ main_thickness / 2, main_thickness / 2, 10 ])
                __SMALL_HINGE__port_negative(main_thickness, plug_clearance_scale = plug_clearance_scale);
    }
}

module __SMALL_HINGE__half(main_thickness, gear_offset, rotate_angle_each_side, plug_clearance_scale, round_far_side,
                           main_clearance_scale, extra_degrees, shave_end_tangents, extend_block_ends)
{
    difference()
    {
        union()
        {
            __SMALL_HINGE__bottom(main_thickness, gear_offset, rotate_angle_each_side, plug_clearance_scale,
                                  round_far_side, main_clearance_scale, extra_degrees, shave_end_tangents,
                                  extend_block_ends);
            translate([ 0, 0, 30 ]) mirror([ 0, 0, 1 ]) mirror([ 1, 0, 0 ]) __SMALL_HINGE__bottom(
                main_thickness, gear_offset, rotate_angle_each_side, plug_clearance_scale, round_far_side,
                main_clearance_scale, extra_degrees, shave_end_tangents, extend_block_ends);

            translate([ main_thickness / 2, main_thickness / 2, 10 ]) __SMALL_HINGE__plug(main_thickness);

            translate([ main_thickness / 2, main_thickness / 2, 20 ]) mirror([ 0, 0, 1 ])
                __SMALL_HINGE__plug(main_thickness);
        }
        // cube([ 100, 2.5, 100 ]);
    }

    translate([ main_thickness / 2, main_thickness / 2, 10 + __SMALL_HINGE__PLUG_VERTICAL_CLEARANCE ])
        cylinder(h = 10 - 2 * __SMALL_HINGE__PLUG_VERTICAL_CLEARANCE,
                 r = main_thickness / 2 - __SMALL_HINGE__CONNECTOR_OUTSIDE_CLEARANCE);

    translate([
        -_EPSILON, main_thickness / 2 - main_thickness / 2 + __SMALL_HINGE__CONNECTOR_OUTSIDE_CLEARANCE, 10 +
        __SMALL_HINGE__PLUG_VERTICAL_CLEARANCE
    ])
        cube([
            main_thickness / 2, main_thickness / 2 * 2 - __SMALL_HINGE__CONNECTOR_OUTSIDE_CLEARANCE * 2, 10 - 2 *
            __SMALL_HINGE__PLUG_VERTICAL_CLEARANCE
        ]);
}

// `extra_degrees`: from 0 to 90
module small_hinge_30mm(main_thickness = 5, rotate_angle_each_side = 0, plug_clearance_scale = 1,
                        main_clearance_scale = 1, round_far_side = false, common_gear_offset = 0, extra_degrees = 0,
                        shave_end_tangents = false, extend_block_ends = 0)
{
    mirror([ 1, 0, 0 ])
        __SMALL_HINGE__half(main_thickness, common_gear_offset, rotate_angle_each_side = rotate_angle_each_side,
                            main_clearance_scale = main_clearance_scale, plug_clearance_scale = plug_clearance_scale,
                            round_far_side = round_far_side, extra_degrees = extra_degrees,
                            shave_end_tangents = shave_end_tangents, extend_block_ends = extend_block_ends);
    __SMALL_HINGE__half(main_thickness, 360 / 8 / 2 + common_gear_offset,
                        rotate_angle_each_side = rotate_angle_each_side, main_clearance_scale = main_clearance_scale,
                        plug_clearance_scale = plug_clearance_scale, round_far_side = round_far_side,
                        extra_degrees = extra_degrees, shave_end_tangents = shave_end_tangents,
                        extend_block_ends = extend_block_ends);
};

// $fn = 180;

// union()
// {
//     small_hinge_30mm(rotate_angle_each_side = 20, main_thickness = 5, extra_degrees = 90, shave_end_tangents = true,
//                      extend_block_ends = 5);
//     // difference()
//     // {
//     //     translate([ -5, 5, 0 ]) cube([ 10, 2, 30 ]);
//     //     cube([ __SMALL_HINGE__HINGE_SHAVE * 2, 100, 100 ], center = true);
//     // }
// }
