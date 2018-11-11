#Requires -Version 3.0
<#
.SYNOPSIS
Remove files older than a defined amount of time from a given directory.

.DESCRIPTION
The Clean-Directory function removes files older than a defined amount of time (months, days, hours or minutes) from a given directory
This function is written for servers that install apps on the D: Drive, so actions on the C: Drive are forbidden.

.PARAMETER directory
Directory which is to be cleaned.

.PARAMETER interval 
set the time unit (months,days,hours,minutes)

.PARAMETER count
set the amount of time units

.EXAMPLE
Remove files older than 3 days from D:\temp
Clean-Directory -directory "D:\temp" -interval days -count 3

.NOTES

#>


function Remove-Directory {
  <#
    .SYNOPSIS
    Describe purpose of "Clean-Directory" in 1-2 sentences.

    .DESCRIPTION
    Add a more complete description of what the function does.

    .PARAMETER directory
    Describe parameter -directory.

    .PARAMETER interval
    Describe parameter -interval.

    .PARAMETER count
    Describe parameter -count.

    .EXAMPLE
    CleanDirectory -directory Value -interval Value -count Value
    Describe what this call does


    .NOTES
    Place additional notes here.

    .LINK
    URLs to related sites
    The first link is opened by Get-Help -Online CleanDirectory

    .INPUTS
    List of input types that are accepted by this function.

    .OUTPUTS
    List of output types produced by this function.
  #>


    [CmdletBinding(SupportsShouldProcess)]
    param (
            [parameter(Mandatory,HelpMessage='Add help message for user')]
            [string]$directory,
            
            [parameter(Mandatory,HelpMessage='Add help message for user')]
            [string]$interval,
            
            [parameter(Mandatory,HelpMessage='Add help message for user')]
            [int]$count

        )
        
        PROCESS {
            
            $null = ($directory -split ':',2)[0]
            # check if D: disk
            #if ($disk -eq 'C') {
            #    Write-Verbose -Message 'C: Drive not allowed'
            #    break
            #}

            $limit=''
        
            if ($interval -eq 'months') {
                $limit = (Get-Date).AddMonths(-$count)
            }

            if ($interval -eq 'days') {
	            $limit = (Get-Date).AddDays(-$count)
            }
        
            if ($interval -eq 'hours') {
                $limit = (Get-Date).AddHours(-$count)
            }
        
            if ($interval -eq 'minutes') {
                $limit = (Get-Date).AddMinutes(-$count)
            }
        
            if ($pscmdlet.ShouldProcess($limit -and (Test-Path -path $directory -IsValid))) {
            #if ($limit -and (Test-Path -path $directory -IsValid)) {
                Write-Verbose -Message ('Cleaning files and directories in {0} older than {1}' -f $directory, $limit)
                Get-ChildItem -Path $directory -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit } | Remove-Item -Force -Verbose
                Get-ChildItem -Path $directory -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse -Verbose
               
            }
            
            
        }
}
export-modulemember -function Remove-Directory
