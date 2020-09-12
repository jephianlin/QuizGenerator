def FindDet(param=(4,3), seed=None):
    """
    A quiz generator for finding the determinant
    
    INPUT:
    
    - ``param`` -- tuple `(dim, bound)`; 
      dim is the order of the A matrix  
      bound is the bound for random_int_matrix  
      
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

    QUESTION = r"""\newcommand{\bv}{{\bf v}}
\newcommand{\rep}{\operatorname{Rep}} 
   
Let 
\[A = %(A)s.\]
Find $\det(A)$.

\bigskip
Check code $=$ $\det(A)$ mod $10$
    """%{'A': latex_matrix(A)
        }
    
    Adet = A.determinant()
    
    checkcode = Adet % 10
    CHECKCODE = "%s"%checkcode
    
    SOLUTION = r"""You may use Laplace's expansion or the permutation expansion to compute the determinant.  
The determinant of $A$ is $\rboxed{%(Adet)s}$.

\bigskip 
Check code $=$ $\det(A)$ mod $10$ $= %(checkcode)s$.
    """%({'Adet': Adet, 
          'checkcode': checkcode
         })
    
    return QUESTION, SOLUTION, CHECKCODE
