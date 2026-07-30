.text
.globl can_chain

// int can_chain(size_t domino_count, const domino_t *dominoes)
// x0 = domino_count
// x1 = dominoes pointer
can_chain:
        // Une liste vide de dominos est toujours valide
        cmp     x0, #0
        bne     .L_start
        mov     w0, #1
        ret

.L_start:
        // Sauvegarde des registres callee-saved
        stp     fp, lr, [sp, #-96]!
        mov     fp, sp
        stp     x19, x20, [sp, #16]
        stp     x21, x22, [sp, #32]
        stp     x23, x24, [sp, #48]
        stp     x25, x26, [sp, #64]
        stp     x27, x28, [sp, #80]

        mov     x19, x0               // x19 = domino_count
        mov     x20, x1               // x20 = dominoes pointer

        // Allocation mémoire sur la pile (256 octets par structure)
        // visited: sp
        // degree:  sp + 256
        // adj:     sp + 1280 (256 * 256 octets = 65536)
        // Total = 67072 octets
        movz    x9, #0x0600
        movk    x9, #0x0001, lsl #16  // x9 = 67072
        sub     sp, sp, x9

        // Initialisation à zéro
        mov     x0, sp
        mov     w1, #0
        mov     x2, x9
        bl      memset

        mov     x21, sp               // x21 = visited (256 B)
        add     x22, sp, #256         // x22 = degree (1024 B)
        add     x23, sp, #1280        // x23 = adj matrix (65536 B)

        mov     x24, #0               // Index i
        mov     x25, #256             // Premier nœud actif (start_node)

.L_parse_loop:
        cmp     x24, x19
        bge     .L_check_degrees

        // Chargement du domino : uint16_t first (offset 0), uint16_t second (offset 2)
        add     x0, x20, x24, lsl #2
        ldrh    w1, [x0]              // u = domino[i].first
        ldrh    w2, [x0, #2]          // v = domino[i].second

        // Enregistrer le premier nœud rencontré
        cmp     x25, #256
        bne     .L_skip_start
        mov     x25, x1               // start_node = u
.L_skip_start:

        // degree[u]++
        ldr     w3, [x22, x1, lsl #2]
        add     w3, w3, #1
        str     w3, [x22, x1, lsl #2]

        // degree[v]++
        ldr     w3, [x22, x2, lsl #2]
        add     w3, w3, #1
        str     w3, [x22, x2, lsl #2]

        // adj[u][v]++
        lsl     x4, x1, #8
        add     x4, x4, x2
        ldrb    w3, [x23, x4]
        add     w3, w3, #1
        strb    w3, [x23, x4]

        // adj[v][u]++
        lsl     x4, x2, #8
        add     x4, x4, x1
        ldrb    w3, [x23, x4]
        add     w3, w3, #1
        strb    w3, [x23, x4]

        add     x24, x24, #1
        b       .L_parse_loop

.L_check_degrees:
        // RÈGLE 1 : Tous les nœuds doivent avoir un degré PAIR
        mov     x24, #0
.L_deg_loop:
        cmp     x24, #256
        bge     .L_bfs_init

        ldr     w1, [x22, x24, lsl #2]
        tst     w1, #1
        bne     .L_fail               // Degré impair -> Impossible

        add     x24, x24, #1
        b       .L_deg_loop

.L_bfs_init:
        // RÈGLE 2 : Vérification de la connectivité via BFS
        sub     sp, sp, #256          // File d'attente (Queue) BFS
        mov     x26, sp

        mov     w0, #1
        strb    w0, [x21, x25]        // visited[start_node] = 1

        mov     x27, #0               // head = 0
        mov     x28, #0               // tail = 0

        strb    w25, [x26, x28]       // push(start_node)
        add     x28, x28, #1

.L_bfs_loop:
        cmp     x27, x28
        bge     .L_check_connectivity

        // pop u
        ldrb    w1, [x26, x27]
        add     x27, x27, #1

        // Parcourir tous les voisins v (0 à 255)
        mov     x2, #0
.L_neighbor_loop:
        cmp     x2, #256
        bge     .L_bfs_loop

        // Vérifier si adj[u][v] > 0
        lsl     x3, x1, #8
        add     x3, x3, x2
        ldrb    w4, [x23, x3]
        cbz     w4, .L_next_neighbor

        // Si v n'a pas encore été visité
        ldrb    w4, [x21, x2]
        cbnz    w4, .L_next_neighbor

        mov     w4, #1
        strb    w4, [x21, x2]         // visited[v] = 1
        strb    w2, [x26, x28]        // push(v)
        add     x28, x28, #1

.L_next_neighbor:
        add     x2, x2, #1
        b       .L_neighbor_loop

.L_check_connectivity:
        add     sp, sp, #256          // Libérer la file d'attente

        // Vérifier que CHAQUE nœud actif (degré > 0) a été visité
        mov     x24, #0
.L_conn_loop:
        cmp     x24, #256
        bge     .L_success

        ldr     w1, [x22, x24, lsl #2]
        cbz     w1, .L_skip_conn      // Degré 0 -> Ignorer

        ldrb    w2, [x21, x24]        // visited[i]
        cbz     w2, .L_fail           // Nœud actif non visité -> Graphe déconnecté

.L_skip_conn:
        add     x24, x24, #1
        b       .L_conn_loop

.L_success:
        mov     w0, #1
        b       .L_epilogue

.L_fail:
        mov     w0, #0

.L_epilogue:
        mov     sp, fp
        ldp     x19, x20, [sp, #16]
        ldp     x21, x22, [sp, #32]
        ldp     x23, x24, [sp, #48]
        ldp     x25, x26, [sp, #64]
        ldp     x27, x28, [sp, #80]
        ldp     fp, lr, [sp], #96
        ret