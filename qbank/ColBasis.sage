def ColBasis(param=(3,4,2), seed=None):
    """
    A quiz generator asking the first redundant column.
    
    INPUT:
    
    - ``param`` -- tuple `(m,n,r)`;  
      `n` columns in `RR^m`, while the generated space  
      is of dimension `r`.
      
    - ``seed`` -- integer;  you may give a seed for  
      the random process if  you like.  Otherwise  
      the default is ``None`` and a random number  
      will be chosen.
      
    OUTPUT:
    
    three strings: QUESTION, SOLUTION, CHECKCODE
    """
    
    # EXAMPLES:

    # sage: load('../common_lib.sage')
    # sage: load('../ColBasis.sage')
    # sage: 
    # sage: seed = 1
    # sage: QUESTION, SOLUTION, CHECKCODE = ColBasis(param=(4,5,3), seed=seed)
    # sage: HEADING = r"""\centerline{Quiz 2 \hfill MATH 103 / GEAI 1215: Linear Algebra I}"""
    # sage: KEY = r"""ColBasis %s"""%seed
    # sage: 
    # sage: tex_writer(sol=True, seed=seed, pdf=True)
    # tw_output.tex has been generated.
    # Trying to compile the tex file.
    # The pdf file has been generated.

    m, n, r = param
    random.seed(seed)
    
    A, R, pivots = random_good_matrix(m, n, r, return_answer=True)
    free = [j for j in range(n) if j not in pivots]
    first_free = free[0]
    vk = A[:,first_free:first_free+1]
    checkcode = sum(vk.transpose()[0]) % 10
    CHECKCODE = "%s"%checkcode
    
    col_string = ', '.join(
        [r"""\bv_{%s}=%s"""%(j+1, latex_matrix(A[:,j:j+1]))
         for j in range(n-1)])
    col_string += r""", \text{and }\bv_{%s}=%s."""%(n, latex_matrix(A[:,n-1:n]))
    
    QUESTION = r"""\newcommand{\bv}{{\bf v}}
Let 
\[%s\] 
Find the vector $\bv_k$ with the smallest $k$ such that 
$\{\bv_1,\ldots,\bv_{k-1}\}$ is linearly independent but 
$\{\bv_1,\ldots,\bv_k\}$ is linearly dependent.

\bigskip
Check code $=$ (sum of all entries of $\bv_k$) mod $10$
    """%(col_string)
    
    
    SOLUTION = r"""Let ${\bf A}$ be the matrix whose columns 
are $\{\bv_1,\ldots,\bv_{%s}\}$.  The reduced echelon form of ${\bf A}$ is 
\[{\bf R} = %s\]
and the first free variable occurs on the $%s$-th column.

Therefore, $k=%s$ and $\rboxed{\bv_k=%s}$.

\bigskip 
Check code $=$ (sum of all entries of $\bv_k$) mod $10$ $= %s$.
"""%(n, 
    latex_matrix(R), 
    first_free+1,
    first_free+1,
    latex_matrix(vk),
    CHECKCODE
    )
    
    return QUESTION, SOLUTION, CHECKCODE