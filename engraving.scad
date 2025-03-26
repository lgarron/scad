include <./compose.scad>
include <./epsilon.scad>

function _undef_default(v, default) = is_undef(v) ? default : v;

module offset_if_not_0(delta)
{
    if (delta == 0)
    {
        // This can be considerably more perofrmant in some situations.
        children();
    }
    else
    {
        offset(delta) children();
    }
}

module _engraved(engraving_depth, margin = undef, epsilon = undef, linear_extrude_height = undef)
{
    epsilon = _undef_default(epsilon, _EPSILON);
    margin = _undef_default(margin, 0);
    linear_extrude_height = _undef_default(linear_extrude_height, engraving_depth);
    // End of parameter default assignments.

    render() translate([ 0, 0, -engraving_depth ]) linear_extrude(linear_extrude_height + epsilon)
        offset_if_not_0(margin) children();
}

module inset_embossed_comp(engraving_depth, margin = undef, epsilon = undef, embossing_height = undef,
                           negative_color = undef, positive_color = undef)
{
    margin = _undef_default(margin, 1);
    negative_color = _undef_default(negative_color, "navy");
    positive_color = _undef_default(positive_color, "lightblue");
    // End of parameter default assignments.

    negative() color(negative_color) _engraved(engraving_depth, margin = margin, epsilon = epsilon) children();
    positive() color(positive_color)
        _engraved(engraving_depth, margin = 0, epsilon = 0, linear_extrude_height = embossing_height) children();
}

module engraved_comp(engraving_depth, epsilon = undef, negative_color = undef, positive_color = undef)
{
    composition_filter("negative") inset_embossed_comp(engraving_depth, epsilon = epsilon, margin = 0,
                                                       negative_color = negative_color, positive_color = positive_color)
        children();
}

module _text_for_engraving(text_string, size = undef, font = undef, halign = undef, valign = undef)
{
    size = _undef_default(size, 5);
    font = _undef_default(font, "Ubuntu:style=bold");
    halign = _undef_default(halign, "center");
    valign = _undef_default(valign, "center");
    // End of parameter default assignments.

    text(text_string, size = size, font = font, halign = halign, valign = valign);
}

module engraved_text_comp(text_string, engraving_depth, epsilon = undef, size = undef, font = undef, halign = undef,
                          valign = undef, negative_color = undef, positive_color = undef)
{
    engraved_comp(engraving_depth, epsilon = epsilon, negative_color = negative_color, positive_color = positive_color)
        _text_for_engraving(text_string, size = size, font = font, halign = halign, valign = valign);
}

module inset_embossed_text_comp(text_string, engraving_depth, embossing_height = undef, margin = undef, epsilon = undef,
                                size = undef, font = undef, halign = undef, valign = undef, negative_color = undef,
                                positive_color = undef)
{
    inset_embossed_comp(engraving_depth, epsilon = epsilon, embossing_height = embossing_height, margin = margin,
                        negative_color = negative_color, positive_color = positive_color)
        _text_for_engraving(text_string, size = size, font = font, halign = halign, valign = valign);
}

// $fn = 180;

// compose()
// {
//     // carvable() translate([ 0, 0, -50 ]) cube(100, center = true);
//     // engraved_text_comp("Ubuntu", 0.4);
//     // inset_embossed_text_comp("Ubuntu", 0.4);
//     // engraved_comp(0.4) translate([ -10, -10 ]) import("./engravings/engraving.svg", dpi = 25.4);
//     // inset_embossed_comp(0.4) translate([ -10, -10 ]) import("./engravings/engraving.svg", dpi = 25.4);
// }
