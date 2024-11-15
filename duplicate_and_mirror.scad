module duplicate_and_mirror(across = [ 1, 0, 0 ])
{
    mirror(across) children();
    children();
}
