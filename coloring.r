#!/usr/bin/env Rscript

# Algorithmic Graph Theory ~ F 97 :: CA3 ~ Q2 by Hadi Safari (hadi@hadisafari.ir)

library(igraph)
library(lpSolve)

colorize_greedy <- function(g) {
    all_colors <- c(1:length(V(g)))
    V(g)$color <- c(0)
    v_order <- order(degree(g), decreasing = TRUE)
    "%ni%" <- Negate("%in%")
    lapply(v_order, function(i) V(g)$color[i] <<- min(all_colors[all_colors %ni%
        sapply(neighbors(g, i), function(j) {
            V(g)$color[j]
        })]))
    return(max(V(g)$color))
}

########

colorize_lp <- function(g) {

    # X_1_1, X_1_2, ..., X_1_n, X_2_1, ..., X_n_n, Y_1, Y_2, ..., Y_n

    # X_i_j: Is node i colored with color j? Y_n: Is color j used?

    n <- length(V(g))
    m <- length(E(g))
    obj <- c(rep(0, n * n), rep(1, n))
    const <- rbind(
        # sum_{k=1}^{n}{X_i_k} = 1, for i in {1..n}
        do.call(rbind, lapply(c(1:n), function(i) c(rep(as.numeric(c(1:n) == i),
            each = n), rep(0, n)))),
        # X_i_k - Y_k <= 0 for i, k in {1..n}
        do.call(rbind, lapply(c(1:n), function(i) do.call(rbind, lapply(c(1:n),
            function(k) c(rep(0, n * (i - 1) + (k - 1)), 1, rep(0, (n * n) - (n * (i -
                1) + (k - 1) + 1)), rep(0, k - 1), (-1), rep(0, n - k)))))),
        # X_i_k + X_j_k <= 1 for <i, j> in E, k in {1..n}
        do.call(rbind, lapply(c(1:n), function(k) do.call(rbind, split(apply(ends(g,
            E(g)), 1, function(e) {
            ret <- rep(0, n * n + n)
            ret[(e[1] - 1) * n + k] <- 1
            ret[(e[2] - 1) * n + k] <- 1
            return(ret)
        }), rep(c(1:m), each = (n * n + n))))))
    )
    ineq <- c(rep("=", n), rep("<=", n * n), rep("<=", length(E(g)) * n))
    rhs <- c(rep(1, n), rep(0, n * n), rep(1, length(E(g)) * n))
    res <- lp("min", obj, const, ineq, rhs, all.bin = TRUE)
    return(sum(res$solution[-c(1:(n * n))]))
}

################

g <- erdos.renyi.game(50, 500, "gnm")
# g <- erdos.renyi.game(20, 77, 'gnm')
# g <- erdos.renyi.game(15, 42, 'gnm')
# g <- erdos.renyi.game(10, 18, 'gnm')
# g <- erdos.renyi.game(5, 5, 'gnm')
print(list("Graph:", g))
########
system.time(print(c("Greedy:", colorize_greedy(g))))
########
system.time(print(c("Integer Linear Programming:", colorize_lp(g))))