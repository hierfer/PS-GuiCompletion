$ErrorActionPreference = 'Stop'
$UI = $Host.UI.RawUI

. $PSScriptRoot\scripts\ConsoleLib.ps1
# . $PSScriptRoot\scripts\GuiCompletionConfig.ps1

function Install-GuiCompletion1($Key = 'Ctrl+Spacebar') {
	Set-PSReadLineKeyHandler -Key $Key -ScriptBlock {
		Invoke-GuiCompletion1
	}
}

function Invoke-GuiCompletion1 {
	for() {
		# get input buffer state
		$buffer = ''
		$cursorPosition = 0
		[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$buffer, [ref]$cursorPosition)
		if (!$cursorPosition) {
			return
		}

		# get completion items
		try {
			$completion = TabExpansion2 $buffer $cursorPosition
		}
		catch {
			return
		}
		if (!$completion.CompletionMatches) {
			return
		}
        # 前面是readline带的功能。下面是这个completion的核心。
		# show the menu
		$Repeat = $false
		$replacement = Get-ConsoleList -Content $completion.CompletionMatches -Repeat ([ref]$Repeat)

		# apply the completion
		if ($replacement) {
			[Microsoft.PowerShell.PSConsoleReadLine]::Replace($completion.ReplacementIndex, $completion.ReplacementLength, $replacement)
		}
		if (!$Repeat) {
			break
		}
	}
}

# Export-ModuleMember -Function Install-GuiCompletion1, Invoke-GuiCompletion1 -Variable GuiCompletionConfig
