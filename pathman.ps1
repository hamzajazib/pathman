#Requires -RunAsAdministrator

param
(
	[switch]$sys = $false,
	[switch]$add = $false,
	[switch]$remove = $false,
	[switch]$raw = $false,

	[Alias("d")]
	[string]$dir
)

if ($sys){$access = "MACHINE"}
else{$access = "USER"}

if ($add -and !$remove)
{
	if ($dir)
	{
		if( !(Test-Path $dir) )
		{
			Write-Host "Path not found." -ForegroundColor red
		}
		else
		{
			$PATH = [Environment]::GetEnvironmentVariable("PATH",$access)
			if( $PATH -notlike "*"+$dir+"*" )
			{
				[Environment]::SetEnvironmentVariable("PATH", "$PATH;$dir", $access)
				Write-Host "Successfully added." -ForegroundColor green
			}
			else
			{
				Write-Host "Directory already present in PATH." -ForegroundColor red
			}
		}
	}
	else
	{
		Write-Host "No path provided." -ForegroundColor red
	}
}
elseif ($remove -and !$add)
{
	if ($dir)
	{
		$PATH = [Environment]::GetEnvironmentVariable("PATH",$access)
		if( $PATH -like "*"+$dir+"*" )
		{
			$PATH = ($PATH.Split(';') | Where-Object { $_ -ne $dir }) -join ';'
			[Environment]::SetEnvironmentVariable("PATH", "$PATH", $access)
			Write-Host "Successfully removed." -ForegroundColor green
		}
		else
		{
			Write-Host "Directory not found in PATH." -ForegroundColor red
		}
	}
	else
	{
		Write-Host "No path provided." -ForegroundColor red
	}
}
else
{
	if ($raw)
	{
		Write-Host $access -ForegroundColor blue
		[Environment]::GetEnvironmentVariable("PATH",$access)
	}
	else
	{
		Write-Host $access -ForegroundColor blue
		[Environment]::GetEnvironmentVariable("PATH",$access).split(";")
	}
}
