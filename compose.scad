// Adapted from https://github.com/openscad/openscad/issues/5510#issuecomment-2557902853

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
