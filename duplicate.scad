module duplicate_and_mirror(across = [ 1, 0, 0 ])
{
    mirror(across) children();
    children();
}

module duplicate_and_translate(translation, number_of_duplicated_copies = 1)
{
    for (i = [0:(number_of_duplicated_copies - 1)])
    {
        translate(translation * i) children();
    }
}

module duplicate_and_rotate(rotation, number_of_duplicated_copies = 1)
{
    for (i = [0:(number_of_duplicated_copies - 1)])
    {
        rotate(rotation * i) children();
    }
}
