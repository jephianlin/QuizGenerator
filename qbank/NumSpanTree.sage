def NumSpanTree(param=(5,5), seed=None):
    """
    A quiz generator for finding the number of spanning trees
    
    INPUT:
    
    - ``param`` -- tuple `(nmin, nmax)`; 
      a randome graph on n vertices with nmin <= n <= nmax  
      will be generated for computing the number of spanning trees
      (redo if the generated graph is not connected)
      
    - ``seed`` -- integer;  you may give a seed for  
      the random process if  you like.  Otherwise  
      the default is ``None`` and a random number  
      will be chosen.
      
    OUTPUT:
    
    three strings: QUESTION, SOLUTION, CHECKCODE
    """
    random.seed(seed)
    g_order = random.choice(list(range(param[0], param[1] + 1)))

    while True:
        g = graphs.RandomGNP(g_order, 0.5)
        if g.is_connected():
            break

    L = g.laplacian_matrix()
    L0 = L[1:,1:]

    ans = abs(L0.determinant())
    code = latex_graph_circular(g)

    QUESTION = r"""Let $G$ be the graph on $%(g_order)s$ vertices as shown below.

\begin{center}
\begin{tikzpicture}[scale=0.5]
%(code)s
\end{tikzpicture}
\end{center}

Count the number of spanning trees of $G$.

\bigskip
Check code $=$ (number of spanning trees) mod $10$
    """%{'code': code,
         'g_order': g_order
        }
    
    checkcode = ans % 10
    CHECKCODE = "%s"%checkcode
    
    SOLUTION = r"""The Laplacian matrix of $G$ is 
\[L = 
%(code)s.\]
Let $L'$ be the matrix obtained from $L$ by removing the first row and the first column.  
Then the number of spanning trees is $|\det(L')| = \rboxed{%(ans)s}$.

\bigskip 
Check code $=$ (number of spanning trees) mod $10$ $= %(checkcode)s$.
    """%({'code': latex_matrix(L),
          'ans': ans, 
          'checkcode': checkcode
         })
    
    return QUESTION, SOLUTION, CHECKCODE