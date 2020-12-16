
def RecRel(param=(5,10), seed=None):
    """
    A quiz generator for solving a recurrence relation
    
    INPUT:
    
    - ``param`` -- tuple `(r_bound, c_bound)`;
      the general solution will be 
          c_1 r_1^n  + c_2 r_2^n
      |r_i| <= r_bound
      |c_i| <= c_bound
      
    - ``seed`` -- integer;  you may give a seed for  
      the random process if  you like.  Otherwise  
      the default is ``None`` and a random number  
      will be chosen.
      
    OUTPUT:
    
    three strings: QUESTION, SOLUTION, CHECKCODE
    """
    r_bound, c_bound = param
    random.seed(seed)
    
    c_choices = list(range(-c_bound,c_bound+1))
    c_choices.remove(0)
    c1 = random.choice(c_choices)
    c2 = random.choice(c_choices)

    r_choices = list(range(-r_bound,r_bound+1))
    r_choices.remove(0)
    r_choices.remove(1)
    r1 = random.choice(r_choices)
    r_choices.remove(r1)
    r2 = random.choice(r_choices)
    
    g_sol = r"(%s)\cdot(%s)^n + (%s)\cdot(%s)^n"%(c1,r1,c2,r2)
    ak = lambda k: c1 * (r1)**k + c2 * (r2)**k
    a0 = ak(0)
    a1 = ak(1)
    
    p,q = r1+r2, -r1*r2
    rel = r"a_n = (%s) a_{n-1} + (%s) a_{n-2}"%(p,q)
    char_eq = "x^2 = (%s)x + (%s)"%(p,q)

    QUESTION = r"""Solve the recurrence relation
\[%(rel)s \text{ for }n\geq 2,\]
\[a_0 = %(a0)s, a_1 = %(a1)s.\]
Write your solution in the form of 
\[a_n = c_1\cdot r_1^n + c_2\cdot r_2^n.\]

\bigskip
Check code $=$ $(c_1+c_2+r_1+r_2)$ mod $10$
    """%{'rel': rel,
         'a0': a0,
         'a1': a1
        }
    
    checkcode = (c1 + c2 + r1 + r2) % 10
    CHECKCODE = "%s"%checkcode
    
    SOLUTION = r"""Solve the characteristic polynomial 
\[%(char_eq)s\]
and get 
\[\rboxed{r_1 = %(r1)s, r_2 = %(r2)s}.\]

Then solve the system of linear equations
\[a_0 = c_1 + c_2 = %(a0)s\]
\[a_1 = (%(r1)s) c_1 + (%(r2)s) c_2 = %(a1)s\]
to get 
\[\rboxed{c_1 = %(c1)s, c_2 = %(c2)s}.\]

\bigskip 
Check code $=$ $(c_1+c_2+r_1+r_2)$ mod $10$ $= %(checkcode)s$.
    """%({'char_eq': char_eq,
          'r1': r1,
          'r2': r2, 
          'c1': c1, 
          'c2': c2, 
          'a0': a0,
          'a1': a1, 
          'checkcode': checkcode
         })
    
    return QUESTION, SOLUTION, CHECKCODE
