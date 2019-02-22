Import-Module -Name AzureRM

Login-AzureRmAccount -EnvironmentName AzureChinaCloud

#Declare Variables
$resourceGroupName = 'CCNSVBKALL'
$snapshotName = 'snapshot20190211_mailbkup1'
$resourceGroupNameStorageAccount = 'CCNSVBKALL'
$storageAccountName = 'snapshot01'
$storageContainerName = 'mailbkup1'
$destinationVHDFileName = 'mailbkup1'

#Get the Storage Account Key of the Destination Storage Account
$storageAccountKey = Get-AzureRmStorageAccountKey -resourceGroupName $resourceGroupNameStorageAccount -AccountName $storageAccountName

#Generate the SAS for the snapshot
$sas = Grant-AzureRmSnapshotAccess -ResourceGroupName $resourceGroupName -SnapshotName $snapshotName  -DurationInSecond 3600 -Access Read 

$destinationContext = New-AzureStorageContext –storageAccountName $storageAccountName -StorageAccountKey ($storageAccountKey).Value[0]

#Copy the snapshot to the destination Storage Account
Start-AzureStorageBlobCopy -AbsoluteUri $sas.AccessSAS -DestContainer $storageContainerName -DestContext $destinationContext -DestBlob $destinationVHDFileName