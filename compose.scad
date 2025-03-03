// Adapted from https://github.com/openscad/openscad/issues/5510#issuecomment-2557902853

// Values for "extraction":
//
// - "carvable"
// - "negative"
// - "positive"
// - "carving" (carvable - positive)
module composition_extract(extraction)
{
    assert(extraction == "carvable" || extraction == "negative" || extraction == "positive" || extraction == "carving",
           "Invalid value for `extraction` parameter.");

    if (extraction == "carving")
    {
        difference()
        {
            children($compose_mode = "carvable");
            children($compose_mode = "negative");
        }
    }
    else
    {
        if ($compose_mode == extraction)
        {
            children($compose_mode = extraction);
        }
    }
}

module compose()
{
    difference()
    {
        children($compose_mode = "carvable");
        children($compose_mode = "negative");
    }
    children($compose_mode = "positive");
}

module carvable()
{
    if ($compose_mode == "carvable")
        children();
}

module negative()
{
    if ($compose_mode == "negative")
        children();
}

module positive()
{
    if ($compose_mode == "positive")
        children();
}
