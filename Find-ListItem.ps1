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
                    [object]$Item = $List.Where( { $_ -eq $SearchString }) | Select-Object -First 1
                }
            } else {
                if (($List.$SearchField).contains($SearchString)) {
                    [object]$Item = $List.Where( { $_.$SearchField -eq $SearchString }) | Select-Object -First 1
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
                    #[object]$Item = $FirstSection.Find([Predicate[object]] { $args[0] -eq $SearchString })
                    [object]$Item = $FirstSection.Where( { $_ -eq $SearchString }) | Select-Object -First 1
                } elseif (($FourthSection).contains($SearchString)) {
                    #[object]$Item = $FourthSection.Find([Predicate[object]] { $args[0] -eq $SearchString })
                    [object]$Item = $FourthSection.Where( { $_ -eq $SearchString }) | Select-Object -First 1
                } elseif (($SecondSection).contains($SearchString)) {
                    #[object]$Item = $SecondSection.Find([Predicate[object]] { $args[0] -eq $SearchString })
                    [object]$Item = $SecondSection.Where( { $_ -eq $SearchString }) | Select-Object -First 1
                } elseif (($ThirdSection).contains($SearchString)) {
                    #[object]$Item = $ThirdSection.Find([Predicate[object]] { $args[0] -eq $SearchString })
                    [object]$Item = $ThirdSection.Where( { $_ -eq $SearchString }) | Select-Object -First 1
                }
            } else {
                if (($FirstSection.$SearchField).contains($SearchString)) {
                    #[object]$Item = $FirstSection.Find([Predicate[object]] { $args[0].$SearchField -eq $SearchString })
                    [object]$Item = $FirstSection.Where( { $_.$SearchField -eq $SearchString }) | Select-Object -First 1
                } elseif (($FourthSection).contains($SearchString)) {
                    #[object]$Item = $FourthSection.Find([Predicate[object]] { $args[0].$SearchField -eq $SearchString })
                    [object]$Item = $FourthSection.Where( { $_.$SearchField -eq $SearchString }) | Select-Object -First 1
                } elseif (($SecondSection).contains($SearchString)) {
                    #[object]$Item = $SecondSection.Find([Predicate[object]] { $args[0].$SearchField -eq $SearchString })
                    [object]$Item = $SecondSection.Where( { $_.$SearchField -eq $SearchString }) | Select-Object -First 1
                } elseif (($ThirdSection).contains($SearchString)) {
                    #[object]$Item = $ThirdSection.Find([Predicate[object]] { $args[0].$SearchField -eq $SearchString })
                    [object]$Item = $ThirdSection.Where( { $_.$SearchField -eq $SearchString }) | Select-Object -First 1
                }
            }
        }
    } catch {
        Throw $_.Exception.Message
    }
    Write-Verbose "FINISH: Locating $($SearchString) in List."
    return $Item

}