
def CountIntSol(param=(5,10), seed=None):
    """
    A quiz generator for counting the number of integer solutions
    
    INPUT:
    
    - ``param`` -- tuple `(num_var, bound)`;
      Consider the equation x1 + ... + xk = w;
      3 <= k <= num_var;
      3 <= w <= bound;
      
    - ``seed`` -- integer;  you may give a seed for  
      the random process if  you like.  Otherwise  
      the default is ``None`` and a random number  
      will be chosen.
      
    OUTPUT:
    
    three strings: QUESTION, SOLUTION, CHECKCODE
    """
    random.seed(seed)
    
    ans = 0
    while ans <= 10 or ans >= 10000: ### if the ans is too bad
        k = random.choice(list(range(3, param[0]+1)))
        w = random.choice(list(range(3, param[1]+1)))
        geq = [random.choice([0,1]) for _ in range(k)]
        neq = random.choice(['=', r'\leq'])

        eqn = r"x_1 + \cdots + x_{%s} %s %s"%(k,neq,w)
        conds = ', '.join([r'x_%s\geq %s'%(i+1,geq[i]) for i in range(k)])
        
        up = k if neq == '=' else k+1
        down = w - sum(geq)
        
        ans = binomial(up+down-1, down)
    
    QUESTION = r"""Consider the equation 
\[%(eqn)s\]
under the conditions
\[%(conds)s.\]
Count the number of the integer solutions.

\bigskip
Check code $=$ (sum of all digits of your answer) mod $10$
    """%{'eqn': eqn, 
         'conds': conds, 
        }
    
    y_eqn = r"y_1 + \cdots + y_{%s} = %s"%(up,down)
    trans = ', '.join(['y_{%s} = x_%s %s'%(i+1,i+1,'-1' if geq[i] == 1 else '') 
                       for i in range(k)])
    
    checkcode = sum(int(d) for d in str(ans)) % 10
    CHECKCODE = "%s"%checkcode
    
    SOLUTION = r"""The equivalent equation is 
\[%(y_eqn)s,\]
where 
\[%(trans)s.\]
    
Therefore, the answer is 
\[\binom{%(up)s + %(down)s - 1}{%(down)s} = %(ans)s.\]

\bigskip 
Check code $=$ (sum of all digits of your answer) mod $10$ $= %(checkcode)s$.
    """%({'y_eqn': y_eqn, 
          'trans': trans,
          'up': up,
          'down': down, 
          'ans': ans, 
          'checkcode': checkcode
         })
    
    return QUESTION, SOLUTION, CHECKCODE
