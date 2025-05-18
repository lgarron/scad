function __scale_coordinate_at_index(scale_factor, index) =
  assert(is_num(scale_factor) || is_list(scale_factor))
  is_num(scale_factor) ? scale_factor
  : scale_factor[index];

// Could be used to scale a position, a size, or a scale in itself.
function __xyz__scale_entries_independently(components, scale_factor) =
  [
    for (i = [0:len(components) - 1]) components[i] * __scale_coordinate_at_index(scale_factor, i),
  ];

function __xyz__coordinate_index_or_num(v, i) = is_num(v) ? v : v[i];

/* 3D */

function _x_(v, scale_factor = 1) = __xyz__scale_entries_independently([__xyz__coordinate_index_or_num(v, 0), 0, 0], scale_factor);
function _y_(v, scale_factor = 1) = __xyz__scale_entries_independently([0, __xyz__coordinate_index_or_num(v, 1), 0], scale_factor);
function _z_(v, scale_factor = 1) = __xyz__scale_entries_independently([0, 0, __xyz__coordinate_index_or_num(v, 2)], scale_factor);

function _xy_(v, scale_factor = 1) = _x_(v, scale_factor) + _y_(v, scale_factor);
function _xz_(v, scale_factor = 1) = _x_(v, scale_factor) + _z_(v, scale_factor);
function _yz_(v, scale_factor = 1) = _y_(v, scale_factor) + _z_(v, scale_factor);

function _xyz_(v, scale_factor = 1) = _x_(v, scale_factor) + _y_(v, scale_factor) + _z_(v, scale_factor);

/* 2D */

function _x_2d(v, scale_factor = 1) = __xyz__scale_entries_independently([__xyz__coordinate_index_or_num(v, 0), 0], scale_factor);
function _y_2d(v, scale_factor = 1) = __xyz__scale_entries_independently([0, __xyz__coordinate_index_or_num(v, 1)], scale_factor);

function _xy2d_(v, scale_factor = 1) = _x_2d(v, scale_factor) + _y_2d(v, scale_factor);
