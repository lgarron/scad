module conditional_translate(condition, translation) {
  if (condition) {
    translate(translation) children();
  } else {
    children();
  }
}

module conditional_rotate(condition, rotation) {
  if (condition) {
    rotate(rotation) children();
  } else {
    children();
  }
}

module conditional_mirror(condition, mirror_by) {
  if (condition) {
    mirror(mirror_by) children();
  } else {
    children();
  }
}

module conditional_front_half(condition) {
  if (condition) {
    front_half() children();
  } else {
    children();
  }
}

module conditional_left_half(condition) {
  if (condition) {
    left_half() children();
  } else {
    children();
  }
}

module conditional_right_half(condition) {
  if (condition) {
    right_half() children();
  } else {
    children();
  }
}
