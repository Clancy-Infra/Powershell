$folder = 'R:\PTXBacs\IFS'
$filter = '*.*'                             
$destination = 'R:\PTXBacs\PTX\INPUT'
$logFile = "R:\PTXBacs\Script\FSW.csv" 


$fsw = New-Object IO.FileSystemWatcher 
$fsw.Path = $folder
$fsw.Filter = $filter
$fsw.IncludeSubdirectories = $false
$fsw.EnableRaisingEvents = $true 

$logfilePath = (Test-Path $logFile)
    if (($logFilePath) -ne "True")
    {
        # Create CSV File and Headers
        New-Item $logfile -ItemType File
        Add-Content $logfile "Date,Name,FilePath"
    }

Register-ObjectEvent $fsw Created -SourceIdentifier FileCreated -Action {
 $path = $Event.SourceEventArgs.FullPath
 $name = $Event.SourceEventArgs.Name
 $changeType = $Event.SourceEventArgs.ChangeType
 $timeStamp = $Event.TimeGenerated
 

 $newName = [System.IO.Path]::GetFileNameWithoutExtension($path) + '_' + (Get-Date -Format 'yyyyMMddTHHmmss')
 $fileExtension = [System.IO.Path]::GetExtension($path)
 $file2path = $destination + "\" + $newName + $fileExtension
 Start-Sleep -m 2000
 Copy-Item -path $path -Destination $file2path -Force -Verbose 
 Add-Content $logfile "File Created $timeStamp,$name,"
 Remove-Item -Path $path
}

Register-ObjectEvent $fsw Changed -SourceIdentifier FileChanged -Action {
 $path = $Event.SourceEventArgs.FullPath
 $name = $Event.SourceEventArgs.Name
 $changeType = $Event.SourceEventArgs.ChangeType
 $timeStamp = $Event.TimeGenerated
 

 $newName = [System.IO.Path]::GetFileNameWithoutExtension($path) + '_' + (Get-Date -Format 'yyyyMMddTHHmmss')
 $fileExtension = [System.IO.Path]::GetExtension($path)
 $file2path = $destination + "\" + $newName + $fileExtension
 Start-Sleep -m 2000
 Copy-Item -path $path -Destination $file2path -Force -Verbose 
 Add-Content $logfile "File Changed $timeStamp,$name,"
 Remove-Item -Path $path
}