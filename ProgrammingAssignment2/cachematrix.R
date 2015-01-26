## These functions enable the caching of the calculated inverse of a matrix
## so that the calculation does not need to be repeated every time it is used.

## This function establishes the functions for setting and getting the matrix and its inverse.
## These are stored in a list.

makeCacheMatrix <- function(x = matrix()) {
        m <- NULL
        set <- function(y) {
                x <<- y
                m <<- NULL
                chkm <<- NULL
        }
        get <- function() x
        setmatrix <- function(solve) m <<- solve
        getmatrix <- function() m
        list(set = set, get = get,
             setmatrix = setmatrix,
             getmatrix = getmatrix)

}


## This function calculates the inverse of the original matrix.
## If this calculation has already been done, the result is returned.

cacheSolve <- function(x, ...) {
        ## Return a matrix that is the inverse of 'x'
        m <- x$getmatrix()
        ## If m has been calculated and is unchanged, return m
        if(!is.null(m) && identical(m,chkm)) {
                message("getting cached data")
                return(m)
        }
        ## If test for m failed, get matrix and calculate inverse
        matrix <- x$get()
        m <- solve(matrix, ...)
        ## create copy of matrix for comparison
        chkm <- m
        x$setmatrix(m)
        m        
}