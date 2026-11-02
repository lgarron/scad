// Adapted from https://github.com/openscad/openscad/issues/5510#issuecomment-2557902853

// Returns a non-composition ("flat") object consisting of the specified part(s).
//
// Values for "extraction":
//
// - "carvable"
// - "negative"
// - "positive"
// - "carving" (carvable - positive)
module composition_extract(extraction) {
  assert(
    extraction == "carvable" || extraction == "negative" || extraction == "positive" || extraction == "carving",
    "Invalid value for `extraction` parameter.",
  );

  if (extraction == "carving") {
    difference() {
      union() {
        children($compose_mode="carvable");
      }
      children($compose_mode="negative");
    }
  } else {
    children($compose_mode=extraction);
  }
}

// Returns an object composition consisting of the specified part(s).
// Assuming all children are defined using compositions only, this essentially keeps the part(s) of the tree specified (while also retaining their composition roles) while removing all others.
//
// Values for "extraction":
//
// - "carvable"
// - "negative"
// - "positive"
// - "carving" (carvable - positive)
module composition_filter(extraction) {
  assert(
    extraction == "carvable" || extraction == "negative" || extraction == "positive" || extraction == "carving",
    "Invalid value for `extraction` parameter.",
  );

  if (extraction == "carving") {
    if ($compose_mode == "carvable" || $compose_mode == "negative") {
      children($compose_mode=extraction);
    }
  } else {
    if ($compose_mode == extraction) {
      children($compose_mode=extraction);
    }
  }
}

module compose() {
  difference() {
    union() {
      children($compose_mode="carvable");
    }
    children($compose_mode="negative");
  }
  children($compose_mode="positive");
}

module carvable() {
  if ($compose_mode == "carvable")
    children();
}

module negative() {
  if ($compose_mode == "negative")
    children();
}

module positive() {
  if ($compose_mode == "positive")
    children();
}
