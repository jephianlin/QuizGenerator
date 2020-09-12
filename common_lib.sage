
import random

### modified from minrank_aux/general_Lib.sage
def latex_matrix(A):
    m,n=A.dimensions();
    stg = r"""\begin{bmatrix}
"""
    for i in range(m):
        for j in range(n-1):
            stg += r""" %s &"""%A[i][j]
        stg += r""" %s \\ 
"""%A[i][n-1]
    stg += r"""\end{bmatrix}"""
    return stg

def random_int_matrix(m, n, bound=5):
    """A generator of random mxn integer matrices
    
    INPUT:
    
    - ``m``, ``n`` -- integers; dimensions of output matrix
      
    - ``bound`` -- integer; the absolute value  
      of the entries of output matrix is  
      at most bound
      
    OUTPUT:
    
    a random mxn integer matrices whose entries  
    are at most bound
    """
    all_numbers = list(range(-bound, bound+1))
    entries = [random.choice(all_numbers) for i in range(m) for j in range(n)]
    return matrix(m, entries)

def random_ref(m, n, r, bound=5, return_pivots=False):
    """A generator of 
    random reduced echelon form 
    (where the pivots are 1)
    
    Input:
        m, n: integers
        r: positive integer with r <= m and r <= n
        bound: positive integer
            |matrix entries| <= bound
        return_pivots: boolean
            if True, return the pivots also
    Output:
        an m x n matrix with rank r
        in its reduced echelon form
        whose pivots are 1.
        Note: the first pivot always locates at (0,0).
    """
    R = zero_matrix(m,n)
    all_numbers = list(range(-bound, bound+1))
    all_choices = list(Combinations(list(range(1,n)),r-1))
    pivots = [0] + random.choice(all_choices)
    pivots += [n]
    for i in range(r):
        j = pivots[i]
        R[i,j] = 1
        for ii in range(i+1):
            for jj in range(j+1, pivots[i+1]):
                R[ii,jj] = random.choice(all_numbers)
    R = R.change_ring(QQ)
    pivots.remove(n)
    if return_pivots:
        return R, pivots
    else:
        return R

def random_good_matrix(m, n, r, bound=5, return_answer=False):
    """A generator of 
    matrix whose Gaussian elimination is easy.
    
    Input:
        m, n: integers
        r: positive integer with r <= m and r <= n
        bound: positive integer
            |coeff for row operation| <= bound
        return_answer: boolean
            if True, return the reduced echelon form and the pivots also.
    Output:
        an m x n matrix with rank r
        whose Gaussian elimination is easy.
    """
    R, pivots = random_ref(m, n, r, return_pivots=True)
    A = copy(R)
    pivots_rev = copy(pivots)
    pivots_rev.reverse()
    all_numbers = list(range(-bound, bound+1))
    ### upward mix 
    for i in range(r):
        j = pivots_rev[i]
        for ii in range(i):
            A[ii,:] += A[i,:] * random.choice(all_numbers)
    ### downward mix
    for i in range(r):
        j =  pivots_rev[i]
        for ii in range(i+1,m):
            A[ii,:] += A[i,:] * random.choice(all_numbers)
    if return_answer:
        return A, R, pivots
    else:
        return A
    
def find_pivots(ref):
    """Find the pivots of a reduced echelon form.
    
    Input:
        ref: a matrix in reduced echelon form
    Outpu: 
        a list of of indices of the pivots
    """
    m,n = ref.dimensions()
    pivots = []
    for i in range(m):
        for j in range(n):
            if ref[i,j] != 0:
                pivots.append(j)
                break
        else:
            break    
    return pivots

def betak_solver(ref, free, k):
    """Return the solution for 
    ref * x = 0
    whereas the k-th (1-indexing) free variable is 1
    while all other free variables are 0.
    
    Input:
        ref: matrix in reduced echelon form
        free: a list of indices of the free variables
        k: positive integer
    Output:
        A column vector beta_k (n x 1 matrix)
        that satisfies ref * beta_k = 0
        whereas the k-th (1-indexing) free variable is 1
        while all other free variables are 0.
    """
    m,n = ref.dimensions()
    pivots = [j for j in range(n) if j not in free]
    rank = len(pivots)
    betak = [0] * n
    ### k is 1-indexing
    ### free is 0-indexing
    betak[free[k-1]] = 1
    for i in range(rank-1,-1,-1):
        j = pivots[i]
        betak[j] = -sum([ref[i,jj]*betak[jj] for jj in range(j+1,n)])
    return  matrix(n,betak)
    
def random_int_eigs_matrix(n, bound=5):
    """A generator of integer matrices with integer eigenvalues  
    
    INPUT: 
    
    - `n` -- integer; order of output matrix
    
    - `bound` -- bound for eigenvalues
    
    OUTPUT: 
    
    return a random nxn integer matrix whose  
    eigenvalues are integers of magnitude  
    at most bound  
    """

    all_nz_numbers = list(range(-bound, bound+1))
    all_nz_numbers.remove(0)
    D = diagonal_matrix([random.choice(all_nz_numbers) for i in range(n)])
    V = random_good_matrix(n, n, n, bound=2)
    A = V.inverse() * D * V
    return A