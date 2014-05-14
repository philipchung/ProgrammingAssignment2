### Intro to Solution

## The two functions 'makeCacheMatrix' & 'cacheSolve' work together to cache
the inverse of a matrix within the closure of a 'makeCacheMatrix' object.
The functions assume that the matrix supplied is always invertable and
does not contain 'NA' values.

## Example:
A <- makeCacheMatrix( matrix(data = runif(9), nrow = 3, ncol = 3) )
cacheSolve(A)
A$get()       # retrieves 'mat'
A$getinv()    # retrieves 'inv'