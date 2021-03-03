def GnpSubG(param=(4,5), seed=None):
    """
    A quiz generator for finding the expected number of induced subgraphs in Erdos--Renyi random graph G(n,0.5)
    
    INPUT:
    
    - ``param`` -- tuple `(nmin, nmax)`; 
      a randome graph on n vertices with nmin <= n <= nmax  
      will be generated as the induced subgraph in the question
      
    - ``seed`` -- integer;  you may give a seed for  
      the random process if  you like.  Otherwise  
      the default is ``None`` and a random number  
      will be chosen.
      
    OUTPUT:
    
    three strings: QUESTION, SOLUTION, CHECKCODE
    """
    random.seed(seed)
    h_order = random.choice(list(range(param[0], param[1] + 1)))

    h = graphs.RandomGNP(h_order, 0.5)
    h_size = h.size()
    hb_size = binomial(h_order,2) - h_size
    
    aut_order = h.automorphism_group().order()
    num_orbits = factorial(h_order) // aut_order
    a,b,c,d = num_orbits, h_order, h_size, hb_size
    ans = [a, b, c, d]
    code = latex_graph_circular(h)

    QUESTION = r"""Let $H$ be the labeled tree on $%(h_order)s$ vertices as shown below.

\begin{center}
\begin{tikzpicture}
%(code)s
\end{tikzpicture}
\end{center}

Let $X$ be a random variable whose value is the number of induced subgraphs in the random graph model $G(n,p)$ that is isomorphic to $H$.  
Find the $a,b,c,d$ so that 

\[\mathbb{E}(X) = a \binom{n}{b}p^c(1-p)^d.\]

\bigskip
Check code $=$ ($a + b + c + d$) mod $10$
    """%{'code': code,
         'h_order': h_order
        }
    
    checkcode = sum(ans) % 10
    CHECKCODE = "%s"%checkcode
    
    SOLUTION = r"""There are $%(aut_order)s$ automorphisms on $H$, 
so there are $%(h_order)s! / %(aut_order)s = %(num_orbits)s$ ways to draw unlabeled $H$ on $%(h_order)s$ labeled vertices.  

There are $\binom{n}{%(h_order)s}$ ways to pick $%(h_order)s$ vertices.  
On this set of vertices, the probability of getting an $H$ is $%(num_orbits)s\times p^{%(h_size)s}(1-p)^{%(hb_size)s}$  
since there are $%(h_size)s$ edges and $%(hb_size)s$ nonedges in $H$.

Therefore, 
\[\mathbb{E}(X) = %(num_orbits)s \binom{n}{%(h_order)s}p^{%(h_size)s}(1-p)^{%(hb_size)s}\]
with $a = %(num_orbits)s$, $b = %(h_order)s$, $c = %(h_size)s$, and $d = %(hb_size)s$.

\bigskip 
Check code $=$ ($a + b + c + d$) mod $10$ $= %(checkcode)s$.
    """%({'aut_order': aut_order,
          'h_order': h_order, 
          'num_orbits': num_orbits, 
          'h_size': h_size, 
          'hb_size': hb_size, 
          'checkcode': checkcode
         })
    
    return QUESTION, SOLUTION, CHECKCODE