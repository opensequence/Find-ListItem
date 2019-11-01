Describe Find-ListItem {
    $ScriptPath = (get-item (Split-Path $script:MyInvocation.MyCommand.Path))
    . "$($ScriptPath.parent.FullName)\Find-ListItem.ps1"
    Context "Find string in List of 3" {
        #Create List of strings
        $List = [System.Collections.Generic.List[string]]::New()
        $null = $List.Add("1234")
        $null = $List.Add("abcd")
        $null = $List.Add("xyz")
        # Execute
        $Item = Find-ListItem -Verbose -List $List -SearchString "abcd"
        It "Should Return the item containing SearchString" {
            $Item -eq "abcd" | Should -BeTrue
        }
    }

    Context "Find string in List of 3000" {
        #Create List of strings
        $List = [System.Collections.Generic.List[string]]::New()

        $numberfitems = 4000
        while ($count -le $numberfitems) {
            $null = $List.Add((New-Guid).Guid)
            $count++
        }

        $null = $List.Add("abcd")
        $null = $List.Add("xyz")
        # Execute
        $Item = Find-ListItem -Verbose -List $List -SearchString "xyz"
        It "Should Return the item containing SearchString" {
            $Item -eq "xyz" | Should -BeTrue
        }
    }

    Context "Find string in List of 4000 | SlowSearch" {
        #Create List of strings
        $List = [System.Collections.Generic.List[string]]::New()

        $numberfitems = 4000
        while ($count -le $numberfitems) {
            $null = $List.Add((New-Guid).Guid)
            $count++
        }

        $null = $List.Add("abcd")
        $null = $List.Add("xyz")
        # Execute
        $Item = Find-ListItem -Verbose -List $List -SearchString "abcd" -ForceSlowSearch $true
        It "Should Return the item containing SearchString" {
            $Item -eq "abcd" | Should -BeTrue
        }
    }

    Context "Find string in List of 850000 | Matching item at the end of list | SlowSearch vs FastSearch" {
        #Create List of strings
        $List = [System.Collections.Generic.List[string]]::New()

        $numberfitems = 850000
        while ($count -le $numberfitems) {
            $null = $List.Add((New-Guid).Guid)
            $count++
        }

        $null = $List.Add("abcd")
        $null = $List.Add("xyz")
        # Execute
        $SlowSearch = Measure-Command { $Item = Find-ListItem -Verbose -List $List -SearchString "abcd" -ForceSlowSearch $true }
        $FastSearch = Measure-Command { $Item = Find-ListItem -Verbose -List $List -SearchString "abcd" }
        It "FastSearch Should be Faster than SlowSearch" {
            $FastSearch.Ticks | Should -BeLessThan $SlowSearch.Ticks
        }
    }

    Context "Find string in List of 90000 | Matching item at position 45000 | SlowSearch vs FastSearch" {
        #Create List of strings
        $List = [System.Collections.Generic.List[string]]::New()

        $numberfitems = 90000
        while ($count -le $numberfitems) {
            $null = $List.Add((New-Guid).Guid)
            $count++
        }
        $null = $List.Add("abcd")
        $null = $List.Add("xyz")

        # Execute
        $SlowSearch = Measure-Command { $SlowItem = Find-ListItem -Verbose -List $List -SearchString "$($List[45000])" -ForceSlowSearch $true }
        $FastSearch = Measure-Command { $FastItem = Find-ListItem -Verbose -List $List -SearchString "$($List[45000])" }
        It "FastSearch Should be Faster than SlowSearch" {
            $FastSearch.Ticks | Should -BeLessThan $SlowSearch.Ticks
        }
        It "FastSearch Result Should be $($List[45000])" {
            $FastItem | Should -BeExactly "$($List[45000])"
        }
        It "SlowSearch Result Should be $($List[45000])" {
            $SlowItem | Should -BeExactly "$($List[45000])"
        }
    }
}