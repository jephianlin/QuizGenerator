def AbsSumEigs(param=(3,5), seed=None):
    """
    A quiz generator for finding the sum of absolute values of eigenvalues
    
    INPUT:
    
    - ``param`` -- tuple `(dim, bound)`; 
      dim is the order of the A matrix  
      bound is the bound for random_int_eigs_matrix  
      
    - ``seed`` -- integer;  you may give a seed for  
      the random process if  you like.  Otherwise  
      the default is ``None`` and a random number  
      will be chosen.
      
    OUTPUT:
    
    three strings: QUESTION, SOLUTION, CHECKCODE
    """
    dim, bound = param
    random.seed(seed)

    A = random_int_eigs_matrix(dim, bound=bound)

    QUESTION = r"""\newcommand{\bv}{{\bf v}}
\newcommand{\rep}{\operatorname{Rep}} 
   
Let 
\[A = %(A)s.\]  
Suppose the eigenvalues of $A$ are $\lambda_1,\ldots,\lambda_%(dim)s$.  
Find the value of $S = \sum_{i=1}^%(dim)s \lambda_i$, where $|\cdot |$ is the absolute value.

\bigskip
Check code $=$ $S$ mod $10$
    """%{'A': latex_matrix(A), 
         'dim': dim
        }
    
    p = A.characteristic_polynomial()
    eigs = A.eigenvalues()
    eigs_stg = ', '.join(['%s'%eig for eig in eigs])
    AbsSum = sum(map(abs, eigs))
    
    checkcode = AbsSum % 10
    CHECKCODE = "%s"%checkcode
    
    SOLUTION = r"""The characteristic polynomial of $A$ is 
\[%(p)s\]
and the eigenvalues are 
\[\{%(eigs_stg)s\}.\]  
Therefore, $S = \rboxed{%(AbsSum)s}$.

\bigskip 
Check code $=$ $\det(A)$ mod $10$ $= %(checkcode)s$.
    """%({'p': latex(p), 
          'eigs_stg': eigs_stg, 
          'AbsSum': AbsSum, 
          'checkcode': checkcode
         })
    
    return QUESTION, SOLUTION, CHECKCODE
