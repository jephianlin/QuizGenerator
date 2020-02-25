def MatRep(param=(3,2), seed=None):
    """
    A quiz generator for finding the matrix representation
    
    INPUT:
    
    - ``param`` -- tuple `(dim, bound)`; 
      dim is the order of the A matrix  
      bound is the bound for random_int_matrix  
      and random_good_matrix
      
    - ``seed`` -- integer;  you may give a seed for  
      the random process if  you like.  Otherwise  
      the default is ``None`` and a random number  
      will be chosen.
      
    OUTPUT:
    
    three strings: QUESTION, SOLUTION, CHECKCODE
    """
    dim, bound = param
    random.seed(seed)

    A = random_int_matrix(dim, dim, bound=bound)
    B = random_good_matrix(dim, dim, dim, bound=bound)

    QUESTION = r"""\newcommand{\bv}{{\bf v}}
\newcommand{\rep}{\operatorname{Rep}} 
   
Let 
\[A = %(A)s \text{ and }
B = %(B)s.\]
Suppose $f:\mathbb{R}^%(dim)s\rightarrow\mathbb{R}^%(dim)s$ is a homomorphism  
defined by $f(\bv) = A\bv$ for all $\bv\in\mathbb{R}^%(dim)s$  
and $\mathcal{B}$ is a basis of $\mathbb{R}^%(dim)s$ composed of the columns of $B$.  
Find $\rep_{\mathcal{B},\mathcal{B}}(f)$.

\bigskip
Check code $=$ (sum of all entries of $\rep_{\mathcal{B},\mathcal{B}}(f)$) mod $10$
    """%{'A': latex_matrix(A), 
         'B': latex_matrix(B), 
         'dim': dim
        }
    
    AB = A * B
    Av_stg = ', '.join([r'A\bv_%s = %s'%(j+1, latex_matrix(AB[:,j])) for j in range(dim-1)]) + \
             r', \text{ and } A\bv_%s = %s'%(dim, latex_matrix(AB[:,dim-1]))
    BinvAB = B.inverse() * AB
    repAv_stg = ', '.join([r'\rep_{\mathcal{B}}(A\bv_%s) = %s'%(j+1, latex_matrix(BinvAB[:,j])) for j in range(dim-1)]) + \
                r', \text{ and } \rep_{\mathcal{B}}(A\bv_%s) = %s'%(dim, latex_matrix(BinvAB[:,dim-1]))
    
    checkcode = sum(BinvAB[i,j] for i in range(dim) for j in range(dim)) % 10
    CHECKCODE = "%s"%checkcode
    
    SOLUTION = r"""Let $\bv_j$ be the $j$-th column of $B$.  
Then $f(\bv_j)$'s can be computed as  
\[%(Av_stg)s\]
and $\rep_{\mathcal{B}}(f(\bv_j))$'s are
\[%(repAv_stg)s.\]  
Thus, 
\[\rep_{\mathcal{B},\mathcal{B}}(f) = \rboxed{%(BinvAB)s}.\]  

\bigskip 
Check code $=$ (sum of all entries of $\rep_{\mathcal{B},\mathcal{B}}(f)$) mod $10$ $= %(checkcode)s$.
    """%({'Av_stg': Av_stg, 
          'repAv_stg': repAv_stg,
          'BinvAB': latex_matrix(BinvAB),
          'checkcode': checkcode
         })
    
    return QUESTION, SOLUTION, CHECKCODE