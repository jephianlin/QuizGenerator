
def Prufer(param=(8,), seed=None):
    """
    A quiz generator for finding the Prufer code of a tree
    
    INPUT:
    
    - ``param`` -- tuple `(tree_order)`; 
      
    - ``seed`` -- integer;  you may give a seed for  
      the random process if  you like.  Otherwise  
      the default is ``None`` and a random number  
      will be chosen.
      
    OUTPUT:
    
    three strings: QUESTION, SOLUTION, CHECKCODE
    """
    tree_order = param[0]
    random.seed(seed)

    g = graphs.RandomTree(tree_order)
    ans = Prufer_code(g)
    code = latex_graph_circular(g)

    QUESTION = r"""Let $T$ be the labeled tree as shown below.

\begin{center}
\begin{tikzpicture}
%(code)s
\end{tikzpicture}
\end{center}

Find the Pr\"ufer code of $T$.

\bigskip
Check code $=$ (sum of all digits of your answer) mod $10$
    """%{'code': code 
        }
    
    compact_ans = ''.join(str(d) for d in ans)
    checkcode = sum(ans) % 10
    CHECKCODE = "%s"%checkcode
    
    SOLUTION = r"""The Pr\"ufer code is $%(compact_ans)s$.

\bigskip 
Check code $=$ (sum of all digits of your answer) mod $10$ $= %(checkcode)s$.
    """%({'compact_ans': compact_ans, 
          'checkcode': checkcode
         })
    
    return QUESTION, SOLUTION, CHECKCODE
