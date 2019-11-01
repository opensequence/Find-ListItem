function Find-ListItem {
    # https://github.com/opensequence
    param (
        [CmdletBinding()]
        [Parameter(Mandatory = $true)]
        [System.Collections.Generic.List[object]]
        $List,
        [Parameter(Mandatory = $false)]
        [string]
        $SearchField,
        [Parameter(Mandatory = $true)]
        [string]
        $SearchString,
        [Parameter(Mandatory = $false)]
        [bool]
        $ForceSlowSearch = $false
    )
    #Set the error action preference to stop to handle errors as they occur
    $ErrorActionPreference = "Stop"
    Write-Verbose "START: Locating $($SearchString) in List"
    try {
        #Check Whether this object already exists in the list
        if (($List.Count -gt 0) -and ($List.Count -lt 3000) -or ($ForceSlowSearch)) {

            #select the existing object
            if ([string]::IsNullOrEmpty($SearchField)) {
                if (($List).contains($SearchString)) {
                    [object]$Item = $List.Find([Predicate[object]] { $args[0] -eq $SearchString })
                }
            } else {
                if (($List.$SearchField).contains($SearchString)) {
                    [object]$Item = $List.Find([Predicate[object]] { $args[0].$SearchField -eq $SearchString })
                }
            }
        } elseif ($List.Count -ge 3000) {
            $Count = $List.Count
            [int]$Quarters = $Count / 4
            [System.Collections.Generic.List[object]]$FirstSection = $List[0..$($Quarters)]
            [System.Collections.Generic.List[object]]$SecondSection = $List[$Quarters..$($Quarters * 2)]
            [System.Collections.Generic.List[object]]$ThirdSection = $List[$($Quarters * 2)..$($Quarters * 3)]
            [System.Collections.Generic.List[object]]$FourthSection = $List[$($Quarters * 3)..$($Count - 1)]
            if ([string]::IsNullOrEmpty($SearchField)) {
                if (($FirstSection).contains($SearchString)) {
                    [object]$Item = $FirstSection.Find([Predicate[object]] { $args[0] -eq $SearchString })
                } elseif (($FourthSection).contains($SearchString)) {
                    [object]$Item = $FourthSection.Find([Predicate[object]] { $args[0] -eq $SearchString })
                } elseif (($SecondSection).contains($SearchString)) {
                    [object]$Item = $SecondSection.Find([Predicate[object]] { $args[0] -eq $SearchString })
                } elseif (($ThirdSection).contains($SearchString)) {
                    [object]$Item = $ThirdSection.Find([Predicate[object]] { $args[0] -eq $SearchString })
                }
            } else {
                if (($FirstSection.$SearchField).contains($SearchString)) {
                    [object]$Item = $FirstSection.Find([Predicate[object]] { $args[0].$SearchField -eq $SearchString })
                } elseif (($FourthSection).contains($SearchString)) {
                    [object]$Item = $FourthSection.Find([Predicate[object]] { $args[0].$SearchField -eq $SearchString })
                } elseif (($SecondSection).contains($SearchString)) {
                    [object]$Item = $SecondSection.Find([Predicate[object]] { $args[0].$SearchField -eq $SearchString })
                } elseif (($ThirdSection).contains($SearchString)) {
                    [object]$Item = $ThirdSection.Find([Predicate[object]] { $args[0].$SearchField -eq $SearchString })
                }
            }
        }
    } catch {
        Throw $_.Exception.Message
    }
    Write-Verbose "FINISH: Locating $($SearchString) in List."
    return $Item

}