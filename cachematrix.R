## The two functions 'makeCacheMatrix' & 'cacheSolve' work together to cache
#   the inverse of a matrix within the closure of a 'makeCacheMatrix' object.
#   The functions assume that the matrix supplied is always invertable and
#   does not contain 'NA' values.
#

## Example:
# A <- makeCacheMatrix( matrix(data = runif(9), nrow = 3, ncol = 3) )
# cacheSolve(A)
# A$get()       # retrieves 'mat'
# A$getinv()    # retrieves 'inv'



## makeCacheMatrix creates an R object with private storage variables:
#   'mat' = stores the matrix that we want to solve (if provided)
#   'inv' = stores the inverse of 'mat' (if solved)
#   The function returns a list of getters & setters to 'mat' & 'inv' which
#   are to be called from an external environment to get & set the private
#   variables within the closure created by 'makeCacheMatrix'
#   Note: If a valid matrix is passed into this function as an argument,
#   'mat' is set to the value of the matrix
makeCacheMatrix <- function(x = matrix()) {
    ## Initialize 'mat' & 'inv' within this function's closure
    mat <- NULL
    inv <- NULL
    
    ## Define getters & setters for 'mat' & 'inv'
    set <- function(y) {
        mat <<- y
        inv <<- NULL          # assigning new orig. matrix so reset inv
    }
    get <- function() mat
    setinv <- function(inverse) inv <<- inverse     # should not be manually set
    getinv <- function() inv
    
    ## For convenience, if passed in a matrix during object construction,
    #   set the matrix to be the value of 'mat' within this closure
    if(is.matrix(x)) {
        if (nrow(x) == 1 && ncol(x) == 1) {
            if(!is.na(x)) { set(x) }     # if default arg for 'x', don't set() 'mat'
        }
        else {
            set(x)
        }
    }
    
    ## Return list of setters & getters to access 'mat' & 'inv' in this closure
    list(set = set, get = get,
         setinv = setinv,
         getinv = getinv)
}


## cacheSolve accepts an object returned by the 'makeCacheMatrix' function
#   as its argument and returns the inverse of the matrix stored in 'mat'.
#   If the argument object contains a non-NULL inverse (stored in 'inv'), then 
#   this cached value is simply returned.  The assumption is that the inverse 
#   has previously been computed with solve() & stored in 'inv'.
#   If 'inv' in the argument object is NULL, then the inverse is computed using
#   solve() & the value is cached in the object's 'inv' variable.
cacheSolve <- function(x, ...) {
    inverse <- x$getinv()
    if(is.null(inverse)) {
        mat <- x$get()
        inverse <- solve(mat)
        x$setinv(inverse)
    }
    inverse
}
