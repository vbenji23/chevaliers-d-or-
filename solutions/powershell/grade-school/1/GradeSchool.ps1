class Student {
    [string]$Name
    [int]$Grade

    Student([string]$name, [int]$grade) {
        $this.Name = $name
        $this.Grade = $grade
    }
}

class Roster {
    [System.Collections.Generic.List[Student]]$Students

    Roster() {
        $this.Students = [System.Collections.Generic.List[Student]]::new()
    }

    [bool] AddStudent([int]$grade, [string]$name) {
        # Un élève ne peut pas être ajouté plus d'une fois au registre (tous niveaux confondus)
        foreach ($student in $this.Students) {
            if ($student.Name -ieq $name) {
                return $false
            }
        }

        $this.Students.Add([Student]::new($name, $grade))
        return $true
    }

    [Student[]] GetRoster() {
        if ($this.Students.Count -eq 0) {
            return @()
        }

        # Tri d'abord par niveau (Grade), puis par nom de manière insensible à la casse
        return $this.Students | Sort-Object -Property Grade, @{ Expression = { $_.Name.ToLower() } }
    }

    [Student[]] GetRoster([int]$grade) {
        $gradeStudents = $this.Students | Where-Object { $_.Grade -eq $grade }
        if (-not $gradeStudents) {
            return @()
        }

        # Tri par nom au sein d'un même niveau
        return $gradeStudents | Sort-Object -Property @{ Expression = { $_.Name.ToLower() } }
    }
}