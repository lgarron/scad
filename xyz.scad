function _x(coordinates, scale_factor = 1) = coordinates[0] * scale_factor;
function _y(coordinates, scale_factor = 1) = coordinates[1] * scale_factor;
function _z(coordinates, scale_factor = 1) = coordinates[2] * scale_factor;

function __scale_coordinate_at_index(scale_factor, index) = assert(is_num(scale_factor) || is_list(scale_factor))
                                                                    is_num(scale_factor)
                                                                ? scale_factor
                                                                : scale_factor[index];

function scale_coordinates(coordinates, scale_factor) = [for (i = [0:len(coordinates) - 1]) coordinates[i] *
                                                         __scale_coordinate_at_index(scale_factor, i)];

function scale_as_vector3(scale_factor) = assert(is_num(scale_factor) || is_list(scale_factor)) is_num(scale_factor)
                                              ? [for (i = [0:2]) scale_factor]
                                              : scale_factor[index];

function _x_(coordinates, scale_factor = 1) = scale_coordinates([ coordinates[0], 0, 0 ], scale_factor);
function _y_(coordinates, scale_factor = 1) = scale_coordinates([ 0, coordinates[1], 0 ], scale_factor);
function _z_(coordinates, scale_factor = 1) = scale_coordinates([ 0, 0, coordinates[2] ], scale_factor);

function _x_y_(coordinates, scale_factor = 1) = scale_coordinates([ coordinates[0], coordinates[1], 0 ], scale_factor);
function _x_z_(coordinates, scale_factor = 1) = scale_coordinates([ coordinates[0], 0, coordinates[2] ], scale_factor);
function _y_z_(coordinates, scale_factor = 1) = scale_coordinates([ 0, coordinates[1], coordinates[2] ], scale_factor);