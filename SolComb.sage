def SolComb(param=(4,3,5), seed=None):
    """
    A quiz generator asking for the vector representation.
    
    INPUT:
    
    - ``param`` -- tuple `(m,n,bound)` (default: `(4,3,5)`);  
      `n` independent columns in `RR^m`
      will be generated, so make sure `m >= n`.
      ``bound`` is the bound for the abs value 
      for (entries of) the solution.
      
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

    m, n, bound = param
    random.seed(seed)
    
    A, R, pivots = random_good_matrix(m, n, n, return_answer=True)
    all_numbers = list(range(-bound,bound+1))
    vec_x = matrix(n, [random.choice(all_numbers) for i in range(n)])
    vec_b = A * vec_x
    
    checkcode = sum(vec_x.transpose()[0]) % 10
    CHECKCODE = "%s"%checkcode
    
    col_string = ', '.join(
        [r"""\bv_{%s}=%s"""%(j+1, latex_matrix(A[:,j:j+1]))
         for j in range(n-1)])
    col_string += r""", \text{and }\bv_{%s}=%s."""%(n, latex_matrix(A[:,n-1:n]))
    
    QUESTION = r"""\newcommand{\bb}{{\bf b}}
\newcommand{\repr}{\operatorname{Repr}}
    
Let 
\[{\bf A} = %s
\text{ and }
\bb = %s.\]
Suppose $\beta$ is the basis formed by the columns of ${\bf A}$.  
Find $\repr_\beta(\bb)$.

\bigskip
Check code $=$ (sum of all entries of $\bb$) mod $10$
    """%(
        latex_matrix(A),
        latex_matrix(vec_b)
        )
    
    SOLUTION = r"""Solve the system of linear equations ${\bf A}{\bf x}=\bb$, 
using Gaussian elimination or any method you like.  The answer is 
\[\repr_\beta(\bb)={\bf x}=\rboxed{%s}.\]

\bigskip 
Check code $=$ (sum of all entries of $\bb$) mod $10$ $= %s$.
"""%(
    latex_matrix(vec_x), 
    CHECKCODE
    )
    
    return QUESTION, SOLUTION, CHECKCODE