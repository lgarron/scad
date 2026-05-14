module duplicate_and_mirror(across = [1, 0, 0]) {
  mirror(across) children();
  children();
}

// `total_number_of_copies` includes the original copy.
module duplicate_and_translate(translation, total_number_of_copies = 2, number_of_total_copies = undef) {
  assert(is_undef(number_of_total_copies), "WARNING: `number_of_total_copies` is no longer supported. Use `number_of_total_copies`.");
  copies = !is_undef(number_of_total_copies) ? number_of_total_copies : total_number_of_copies;
  for (i = [0:(copies - 1)]) {
    translate(translation * i) children();
  }
}

// `total_number_of_copies` includes the original copy.
module duplicate_and_rotate(rotation, total_number_of_copies = 2, number_of_total_copies = undef) {
  assert(is_undef(number_of_total_copies), "WARNING: `number_of_total_copies` is no longer supported. Use `number_of_total_copies`.");
  copies = !is_undef(number_of_total_copies) ? number_of_total_copies : total_number_of_copies;
  for (i = [0:(copies - 1)]) {
    rotate(rotation * i) children();
  }
}
