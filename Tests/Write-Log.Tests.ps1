#$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
#. "$here\$sut"




# ----- Get the module name
if ( -Not $PSScriptRoot ) { $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent }

Write-Output "PSScriptRoot = $PSScriptRoot"

$ModulePath = $PSScriptRoot.substring(0,$PSScriptRoot.LastIndexOf('\'))

Write-output "ModulePath = $ModulePath"

$Global:ModuleName = $ModulePath | Split-Path -Leaf

Write-Output "ModuleName = $ModuleName"

$FunctionName = $MyInvocation.MyCommand.Name -Replace '\.Tests\.','.'

Write-Output "Functionname = $FunctionName"

# ----- Dot source Function
. $ModulePath/$FunctionName

#-------------------------------------------------------------------------------------

Describe "Write-Log" {
    Mock -CommandName Get-Date -MockWith {
        Return '2019-11-08 10:45:21'
    }
    
    Write-Log -Path testdrive:\log.log -Message 'this works' 
    
    It "Should create a log file if it does not exist" {
        'Testdrive:\log.log' | Should Exist
    }

    It "Should Write 'this works' to log file" {
        Get-content 'Testdrive:\log.log' | Should Match 'this works'
    }

    It 'Should write a Error if specified' {
        Write-Log -Path testdrive:\log.log -Message 'this works' -Throw
        Get-content 'Testdrive:\log.log' | Should Match 'Error'
    } -pending

    It 'Should write a warning if specified' {
        Write-Log -Path testdrive:\log.log -Message 'this works' -Warning 
        Get-content 'Testdrive:\log.log' | Should Match 'Warning'
    } -Pending
}