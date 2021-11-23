# This script will check and create required terraform backend.
# This script uses AZ Cli to perform tasks on Azure using the current AZ login context.

param (
    [string]$WorkingDirectory,
    [string]$Landscape,
    [string]$Workspace_ID,
    [String]$configFile="config.json",
    [string]$defaultLocation = "eastus2"
)

$directory = "$($WorkingDirectory)/$($Landscape)/$($Workspace_ID)"
try{
    $file = Get-ChildItem -Path $directory -Filter $configFile
}
catch {
    write-error "Error in fetching config.json file from $directory."
    write-host "##vso[task.backendcheck type=error]Error in fetching config.json file from $directory."
    exit(1)
}

# read the config file
$configJson = get-content $file.FullName | convertfrom-json 

# get storage access key
$key = az storage account keys list -g $configJson.resource_group -n $configJson.storage_account --query '[0].value'
# perform a check to see if the container exists
$contResult =   az storage container exists --account-name $configJson.storage_account --name $configJson.container --account-key $key
if ($contResult -eq "false"){
    az storage container create --name $configJson.container --account-name $configJson.storage_account
}


# export the variables for use in subsequent tasks



