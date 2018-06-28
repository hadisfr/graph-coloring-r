Solving Graph Coloring Problem (GCP) using R
===

## Greedy Approach

In `colorize_greedy`,  all vertices of graph will be sorted non-increasing based on their degree. The smallest allowed color  will be assigned to each vertex. It's obvious that at most $`\|V(G)\|`$ colors will be needed.

## Integral Linear Programming Approach

### Modeling GCP to ILP

The graph coloring problem is modeled as in ILP problem.

> **Note**: 
> In writing this part, [Faigle U., Kern W., Still G. (2002) Integer Programming. In: Algorithmic Principles of Mathematical Programming. Kluwer Texts in the Mathematical Sciences (A Graduate-Level Book Series), vol 24. Springer, Dordrecht][Faigle] and [this StackOverflow post][IPLSO] were used.

If $`X_{i, j}`$ shows that vertex $`i`$ is colored with color $`j`$ and $`Y_i`$ shows that color $`j`$ is used, $`X`$ and $`Y`$ are `boolean` variables (i.e. `integer` variables with bounds 0 and 1), then we are interested in optimizing solution of:
```math
min(\sum_{k=1}^n{Y_k})
```
```math
\sum_{k=1}^{n}{X_{i,k} = 1:\forall i \in \{1, …, n\}}
```
```math
X_{i,k}-Y_{k} \le 0 : \forall i, k \in \{1, …,n\}
```
```math
X_{i,k}+X{j,k} \le 1 : \forall k \in \{1, …,n\},  <i,j> \in E(G)
```

### Solving ILP

Based on the previos model and using `lpsolve` package, the GCP problem can be solved.

## Analyzing Results

Some graphs of second [Erdős–Rényi model][ERM] ($`G(n, m)`$) were used to test and compare these approaches.

On small graph $`G(5, 5)`$ both algorithms generated result 3 in a short time.
```
[[1]]
[1] "Graph:"

[[2]]
IGRAPH a4a8b9d U--- 5 5 -- Erdos renyi (gnm) graph
+ attr: name (g/c), type (g/c), loops (g/l), m (g/n)
+ edges from a4a8b9d:
[1] 2--3 1--4 2--4 3--4 4--5

[1] "Greedy:" "3"      
   user  system elapsed 
  0.035   0.002   0.037 
[1] "Integer Linear Programming:" "3"                          
   user  system elapsed 
  0.032   0.002   0.034 

```

On $`G(10, 18)`$ both generated 4.
```
[[1]]
[1] "Graph:"

[[2]]
IGRAPH 089488b U--- 10 18 -- Erdos renyi (gnm) graph
+ attr: name (g/c), type (g/c), loops (g/l), m (g/n)
+ edges from 089488b:
 [1] 1-- 2 1-- 3 2-- 3 3-- 4 4-- 5 2-- 6 3-- 6 4-- 6 4-- 7 5-- 8 7-- 8 2-- 9
[13] 3-- 9 5-- 9 6-- 9 7-- 9 2--10 4--10

[1] "Greedy:" "4"      
   user  system elapsed 
  0.047   0.002   0.049 
[1] "Integer Linear Programming:" "4"                          
   user  system elapsed 
  0.340   0.003   0.345 
```

On $`G(15, 42)`$ both generated 5. ILP approach lasted about 22 times more than greedy approach.
```
[[1]]
[1] "Graph:"

[[2]]
IGRAPH b8c05dc U--- 15 42 -- Erdos renyi (gnm) graph
+ attr: name (g/c), type (g/c), loops (g/l), m (g/n)
+ edges from b8c05dc:
 [1]  2-- 3  1-- 5  4-- 5  2-- 7  1-- 8  2-- 8  3-- 8  6-- 8  2-- 9  2--10
[11]  3--10  4--10  5--10  6--10  8--10  3--11  5--11  6--11  1--12  5--12
[21]  7--12  9--12 10--12  1--13  2--13  3--13  4--13  7--13 10--13  3--14
[31]  5--14  7--14 10--14 13--14  1--15  2--15  3--15  5--15  9--15 10--15
[41] 11--15 14--15

[1] "Greedy:" "5"      
   user  system elapsed 
  0.059   0.002   0.061 
[1] "Integer Linear Programming:" "4"                          
   user  system elapsed 
 10.977   0.048  11.080 
```

On bigger graph $`G(20, 77)`$, greedy approach gave result 5 in 0.255 s. ILP approach reached result 4 in about 2 h.
```
[[1]]
[1] "Graph:"

[[2]]
IGRAPH a043ffc U--- 20 77 -- Erdos renyi (gnm) graph
+ attr: name (g/c), type (g/c), loops (g/l), m (g/n)
+ edges from a043ffc:
 [1]  1-- 2  1-- 3  2-- 4  4-- 5  1-- 6  2-- 6  3-- 6  4-- 6  5-- 6  1-- 7
[11]  4-- 7  5-- 7  1-- 8  5-- 8  1-- 9  4-- 9  5-- 9  6-- 9  7-- 9  5--10
[21]  6--10  7--10  8--10  2--11  3--11  5--11  6--11  8--11  9--11 10--11
[31]  1--12  4--12  5--12  8--12  3--13  4--13  6--13 11--13 12--13  2--14
[41]  3--14  9--14 10--14 13--14  4--15  9--15 10--15 11--15 14--15  1--16
[51]  2--16  8--16  9--16 11--16 13--16  4--17  5--17  6--17  8--17 11--17
[61] 13--17 14--17  1--18 11--18 14--18 17--18  1--19  3--19  4--19  7--19
[71]  9--19 12--19 16--19 17--19  2--20 11--20 19--20

[1] "Greedy:" "5"      
   user  system elapsed 
  0.213   0.012   0.225 
[1] "Integer Linear Programming:" "5"                          
    user   system  elapsed 
6840.432    0.471 6863.336 

```

On much bigger graph $`G(50, 500)`$, greedy approach gave result 10 in 0.235 s. ILP approach didn't reach the result in a reasonable time.

### Conclusion

It seems that greedy algorithm has appropriate accuracy. Because of very high temporal cost of ILP algorithm, it seems reasonable to use greedy algorithm for solving GCP in many usages. 

[Faigle]: http://wwwhome.math.utwente.nl/~uetzm/do/IP-FKS.pdf
[IPLSO]: https://stackoverflow.com/a/26764275
[ERM]: https://en.wikipedia.org/wiki/Erdős–Rényi_model
