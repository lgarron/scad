module minkowski_shell()
{
    difference()
    {
        minkowski()
        {
            children(0);
            children(1);
        }
        children(0);
    }
}
