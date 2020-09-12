
def NullBasis(param=(3,4,2), seed=None):
    """A quiz generator asking for the null basis.
    
    Input:
        seed: the random seed
        param: a tuple (m,n,r)
            m,n are the dimensions of matrix A
            r is the rank of A
    Output:
        three strings: QUESTION, SOLUTION, CHECKCODE
    """
    
    m, n, r = param
    random.seed(seed)
    
    A, R, pivots = random_good_matrix(m, n, r, return_answer=True)
    free = [j for j in range(n) if j not in pivots]
    x_var = matrix(n, [var('x_%s'%j) for j in range(1,n+1)])
    k = random.randint(1,n-r)
    
    QUESTION = r"""Consider the equation $\textbf{A}\textbf{x} = \textbf{0}$,
where 
\[\textbf{A}=
%s,
\textbf{x}=
%s,\text{ and }
\textbf{0}=
%s.\]
Compute the reduced echelon form $\textbf{R}$ of $\textbf{A}$ 
to get the free variables.  
Let $k=%s$.  
Find a solution $\textbf{x}=\bm{\beta}_k$ by setting 
the $k$-th free variable as $1$ while  
the other free variables as $0$.

\bigskip
Check code $=$ (sum of all entries of $\bm{\beta}_k$) mod $10$
"""%(latex_matrix(A), 
           latex_matrix(x_var), 
           latex_matrix(zero_matrix(n,1)), 
           k
          )
    
    free_text = ','.join(['x_%s'%(j+1) for j in free])
    xk = 'x_%s'%(free[k-1]+1)
    betak = betak_solver(R, free, k)
    checkcode = sum(betak.transpose()[0]) % 10
    CHECKCODE = "%s"%checkcode
    
    SOLUTION = r"""Apply Gaussian elimination to \textbf{A} 
to get its reduced echelon form 
\[\textbf{R} = 
%s.\]
The free variables are $%s$.  

By setting $%s=1$ and all other free variables as $0$, one may solve for 
\[\rboxed{\bm{\beta}_%s = 
%s
}.\]

as the answer.

\bigskip
Check code $=$ (sum of all entries of $\bm{\beta}_%s$) mod $10$ $= %s$. 
"""%(latex_matrix(R), 
     free_text, 
     xk, 
     k, 
     latex_matrix(betak), 
     k, 
     CHECKCODE
    )
    
    return QUESTION, SOLUTION, CHECKCODE