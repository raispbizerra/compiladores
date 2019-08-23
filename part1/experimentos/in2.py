def seq_search(lst, num):
    """This method performs a sequential search in a list

    Parameters
    ----------
    lst: list
        list to search the number
    num: int
        Number to be searched

    Returns
    -------
    int or None
        if the list contains the number, returns number index
        else, returns None
    """
    assert isinstance(lst, list)
    for i, n in enumerate(lst):
        if n == num:
            return i
    else:
        return None
        
lst = [1. , .1 , 2.1 , 2.0] # List
seq_search(lst, 2)