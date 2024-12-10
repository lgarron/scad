module duplicate_and_mirror(across = [ 1, 0, 0 ])
{
    mirror(across) children();
    children();
}

module duplicate_and_translate(translation)
{
    translate(translation) children();
    children();
}

module duplicate_and_rotate(rotation)
{
    rotate(rotation) children();
    children();
}
