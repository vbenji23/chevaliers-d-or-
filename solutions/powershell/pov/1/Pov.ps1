Class Tree {
    [string]$Value
    [Tree[]]$Children

    # Constructeurs
    Tree([string]$value) {
        $this.Value = $value
        $this.Children = @()
    }

    Tree([string]$value, [Tree[]]$children) {
        $this.Value = $value
        $this.Children = if ($null -eq $children) { @() } else { $children }
    }

    # Trouve le chemin (tableau de nœuds) de la racine jusqu au nœud 'target'
    [Tree[]] FindPathTo([string]$target) {
        if ($this.Value -eq $target) {
            return @($this)
        }
        foreach ($child in $this.Children) {
            $subPath = $child.FindPathTo($target)
            if ($subPath.Count -gt 0) {
                return @($this) + $subPath
            }
        }
        return @()
    }

    # Re-racine l'arbre autour du nœud spécifié
    [Tree] FromPov([string]$node) {
        $pathToNode = $this.FindPathTo($node)
        if ($pathToNode.Count -eq 0) {
            Throw "Tree could not be reoriented: node '$node' not found."
        }

        # On reconstruit l'arbre de bas en haut le long du chemin
        $currentNewTree = $null

        for ($i = 0; $i -lt $pathToNode.Count; $i++) {
            $currNode = $pathToNode[$i]
            
            # Récupère tous les enfants sauf le suivant dans le chemin
            $nextInPath = if ($i + 1 -lt $pathToNode.Count) { $pathToNode[$i + 1] } else { $null }
            $newChildren = @()

            foreach ($child in $currNode.Children) {
                if ($null -eq $nextInPath -or $child.Value -ne $nextInPath.Value) {
                    $newChildren += $child
                }
            }

            if ($null -ne $currentNewTree) {
                $newChildren += $currentNewTree
            }

            $currentNewTree = [Tree]::new($currNode.Value, $newChildren)
        }

        return $currentNewTree
    }

    # Trouve le chemin orienté sous forme de chaînes de caractères de 'from' vers 'to'
    [string[]] Path([string]$from, [string]$to) {
        try {
            $rerooted = $this.FromPov($from)
        } catch {
            Throw "No path found: source '$from' does not exist."
        }

        $pathToDest = $rerooted.FindPathTo($to)
        if ($pathToDest.Count -eq 0) {
            Throw "No path found: destination '$to' does not exist."
        }

        $result = @()
        foreach ($node in $pathToDest) {
            $result += $node.Value
        }
        return $result
    }

    # Comparaison d'égalité indépendante de l'ordre des enfants
    [bool] Equals([object]$other) {
        if ($null -eq $other -or $other -isnot [Tree]) {
            return $false
        }
        
        $otherTree = [Tree]$other
        if ($this.Value -ne $otherTree.Value) {
            return $false
        }
        if ($this.Children.Count -ne $otherTree.Children.Count) {
            return $false
        }

        # Vérification des enfants sans tenir compte de l'ordre
        $matchedIndices = [System.Collections.Generic.HashSet[int]]::new()
        foreach ($child in $this.Children) {
            $found = $false
            for ($j = 0; $j -lt $otherTree.Children.Count; $j++) {
                if (-not $matchedIndices.Contains($j) -and $child.Equals($otherTree.Children[$j])) {
                    $matchedIndices.Add($j) | Out-Null
                    $found = $true
                    break
                }
            }
            if (-not $found) {
                return $false
            }
        }

        return $true
    }
}