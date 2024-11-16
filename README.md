# `scad`

## Installation

```shell
npm install --save-dev scad # npm
bun add scad # bun
```

## API

```scad
include <./node_modules/scad/round_bevel.scad>

// Creates a vertical (Z) cylinder enclosing a round bevel in the +X znd +Y directions.
// Use with difference() to create round bevels.
round_bevel_complement(height, radius, center_z = false, epsilon = _EPSILON);

// The cylinder used by `round_bevel_complement(…)`, for when a positive shape is needed instead of the negative.
round_bevel_cylinder(height, radius, center_z = false, epsilon = _EPSILON);
```

```scad
include <./node_modules/scad/duplicate_and_mirror.scad>

duplicate_and_mirror(across = [ 1, 0, 0 ]);
```

```scad
include <./node_modules/scad/round_bevel.scad>

// Takes the Minkowski sum of child0 and child1, then takes the difference with child0 to leave a shell.
minkowski_shell() {
  child0();
  child1();
}
```

```scad
include <./node_modules/scad/small_hinge.scad>

// A small hinge design. Rotates vertically (+Z) and is horizontally symmetric (±X).
module small_hinge_30mm(
  rotate_angle_each_side = 0,
  plug_clearance_scale = 1,
  main_clearance_scale = 1,
  round_far_side = false,
  shave_middle = true
)
```
