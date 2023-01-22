
#remove all old output folders
Write-Host "removing old output folders"
Write-Host "+++++++++++++++++++++++++++"
$listOfOutputFolders = Get-ChildItem | Where-Object {$_.FullName -match "_output"}
foreach ($outputFolder in $listOfOutputFolders)
{
    remove-item $outputFolder -force -recurse -ErrorAction SilentlyContinue
}

#generate new output folders
$listOfCardDocuments = Get-ChildItem | Where-Object {$_.FullName -match ".csv"}
write-host ""
Write-Host "iterating over documents to generate card pngs"
$failureFound = $false
foreach ($cardDocument in $listOfCardDocuments)
{
    if ($failureFound)
    {
        exit
    }
    write-host ""
    $rubyDocument = Get-ChildItem | Where-Object {$_.FullName -match ".rb"}
    Write-Host "executing ruby script $rubyDocument on the $cardDocument csv"
    Write-Host "++++++++++++++++++++++++++++++++++++++++++"
    ruby $rubyDocument $cardDocument

    Write-Host "renaming output folder"
    $documentName = $cardDocument.Name
    #set the 'content' variable of "$matches" special powershell thing to the part we want to copy
    $documentName -match "_Data-(?<content>.*).csv"
    $docShortName = $matches['content']

    $outputDirName = resolve-path _output -ErrorAction SilentlyContinue
    if(test-path $outputDirName)
    {
        Write-Host "____output folder generated, renaming it for parsability"
        $newOutputDirName = $outputDirName -replace "_output","_output-$docShortName"

        #rename folder
        rename-item $outputDirName $newOutputDirName
    }
    else
    {
        Write-Host "____output folder not generated"
        $failureFound = $true
    }
    Write-Host "--------------------"
}
if ($failureFound)
{
    Write-Host "ran into an error, ending early"
}