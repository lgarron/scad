module duplicate_and_mirror(across = [1, 0, 0]) {
  mirror(across) children();
  children();
}

// `number_of_total_copies` includes the original copy.
module duplicate_and_translate(translation, number_of_total_copies = 2) {
  for (i = [0:(number_of_total_copies - 1)]) {
    translate(translation * i) children();
  }
}

// `number_of_total_copies` includes the original copy.
module duplicate_and_rotate(rotation, number_of_total_copies = 2) {
  for (i = [0:(number_of_total_copies - 1)]) {
    rotate(rotation * i) children();
  }
}
