include <./xyz.scad>

// A "centerable cube"
// The `centering_spec` consists of three characters, each of which may be `-`, `.`, or `+`
//
// - `aligned_cube(size, "+++")` is the same as `cube(size)`
// - `aligned_cube(size, "...")` is the same as `cube(size, center=true)`
module aligned_cube(size, centering_spec)
{
    for (char = centering_spec)
    {
        assert(char == "-" || char == "." || char == "+", "Invalid character in centering spec");
    };

    centering_scale = [for (char = centering_spec) char == "-" ? -1 : (char == "." ? 0 : 1)];
    translate(scale_coordinates(size, centering_scale / 2)) cube(size, center = true);
}
