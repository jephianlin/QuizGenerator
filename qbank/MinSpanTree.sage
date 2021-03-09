def MinSpanTree(param=(6,20), seed=None):
    """
    A quiz generator for finding the minimum spanning tree on a weighted graph
    
    INPUT:
    
    - ``param`` -- tuple `(n, wmax)`; 
      a table recording the weights of Kn will be given
      the weightes are integers between 1 and wmax (inclusive on both ends)
      
    - ``seed`` -- integer;  you may give a seed for  
      the random process if  you like.  Otherwise  
      the default is ``None`` and a random number  
      will be chosen.
      
    OUTPUT:
    
    three strings: QUESTION, SOLUTION, CHECKCODE
    """
    n,wmax = param
    random.seed(seed)

    W = zero_matrix(n)
    for i in range(0,n-1):
        for j in range(i+1, n):
            W[i,j] = random.randint(1, wmax)
            W[j,i] = W[i,j]
    
    W_text = []
    for i in range(n+1):
        W_text.append([' ' for j in range(n+1)])
        
    for j in range(n):
        W_text[0][j+1] = j
        W_text[j+1][0] = j
    W_text[1][0] = '\\hline\n 0'

    for i in range(1,n):
        for j in range(i+1, n+1):
            W_text[i][j] = W[i-1,j-1]
    
    g = graphs.CompleteGraph(n)
    w_func = lambda e: W[e[0],e[1]]
   
    s_tree = g.min_spanning_tree(weight_function=w_func)
    
    ans = sum(w_func(e) for e in s_tree)

    QUESTION = r"""Let $G$ be the complete graph on vertices $\{0,\ldots, %(np)s\}$  
such that the weights of its edges are recorded in the following table.

\begin{center}
\begin{tabular}{%(cs)s}
%(content)s
\end{tabular}
\end{center}

Recall that the weight of a spanning tree is the sum of its edge weights.  
Find a spanning tree of $G$ with the minimum weight.

\bigskip
Check code $=$ (weight of your spanning tree) mod $10$
    """%{'np': n - 1,
         'cs': 'c|' + 'c'*n,
         'content': latex_matrix(W_text, False)
        }
    
    checkcode = ans % 10
    CHECKCODE = "%s"%checkcode
  
    SOLUTION = r"""Apply one of the minimum spanning tree algorithms, e.g., Kruskal's algorithm or Prim's algorithm.  
The tree using the following edges  
\[\rboxed{%(treeedges)s}\]
is a minimum spanning tree, whose weight is $\rboxed{%(ans)s}$.  

\bigskip 
Check code $=$ (weight of your spanning tree) mod $10$ $= %(checkcode)s$.
    """%({'treeedges': ', '.join("%s%s"%(e[0],e[1]) for e in s_tree),
          'ans': ans, 
          'checkcode': checkcode
         })
    
    return QUESTION, SOLUTION, CHECKCODE