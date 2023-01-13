#### Create and deploy a custom Windows Virtual Desktop Image

#Install Azure Image Builder and Managed Service Identity PowerShell modules.
Install-Module Az -Force
Install-Module -Name Az.DesktopVirtualization -Force
'Az.ImageBuilder', 'Az.ManagedServiceIdentity' | ForEach-Object {Install-Module -Name $_ -AllowPrerelease}

# Connect to Azure with a browser sign in token
Connect-AzAccount

# To use Azure Image Builder during the preview, you have to register the Azure Image Builder feature.
Register-AzProviderFeature -FeatureName VirtualMachineTemplatePreview -ProviderNamespace Microsoft.VirtualMachineImages
Get-AzProviderFeature -FeatureName VirtualMachineTemplatePreview -ProviderNamespace Microsoft.VirtualMachineImages

# Register for the providers
Register-AzResourceProvider -ProviderNamespace Microsoft.VirtualMachineImages
Register-AzResourceProvider -ProviderNamespace Microsoft.Storage
Register-AzResourceProvider -ProviderNamespace Microsoft.Compute
Register-AzResourceProvider -ProviderNamespace Microsoft.KeyVault

# get existing context
$currentAzContext = Get-AzContext
 
# destination image resource group
$imageResourceGroup="rg-wvd-azimg"
 
# location
$location="WestEurope"
 
# get your current subscription
$subscriptionID=$currentAzContext.Subscription.Id
 
# image template name
$imageTemplateName="wvd-win10-img-template"
 
# create resource group
New-AzResourceGroup -Name $imageResourceGroup -Location $location

# setup role def names, these need to be unique
$timeInt=(Get-Date -UFormat "%s").Split(".")[0]
$imageRoleDefName="Azure Image Builder Image Def"+$timeInt
$identityName="aibIdentity"+$timeInt
 
# create identity
New-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName
 
$identityNameResourceId=$(Get-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName).Id
$identityNamePrincipalId=$(Get-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName).PrincipalId


# create temp folder 
$FolderPath = "C:\temp\"
New-Item -Path $FolderPath -ItemType Directory -Force
 
$aibRoleImageCreationUrl="https://raw.githubusercontent.com/PeterR-msft/M365WVDWS/master/Azure%20Image%20Builder/aibRoleImageCreation.json"
$aibRoleImageCreationPath = $FolderPath + "aibRoleImageCreation.json"
 
# download config
Invoke-WebRequest -Uri $aibRoleImageCreationUrl -OutFile $aibRoleImageCreationPath -UseBasicParsing
 
((Get-Content -path $aibRoleImageCreationPath -Raw) -replace '<subscriptionID>',$subscriptionID) | Set-Content -Path $aibRoleImageCreationPath
((Get-Content -path $aibRoleImageCreationPath -Raw) -replace '<rgName>', $imageResourceGroup) | Set-Content -Path $aibRoleImageCreationPath
((Get-Content -path $aibRoleImageCreationPath -Raw) -replace 'Azure Image Builder Service Image Creation Role', $imageRoleDefName) | Set-Content -Path $aibRoleImageCreationPath
 
# create role definition
New-AzRoleDefinition -InputFile $aibRoleImageCreationPath
 
# grant role definition to image builder service principal
New-AzRoleAssignment -ObjectId $identityNamePrincipalId -RoleDefinitionName $imageRoleDefName -Scope "/subscriptions/$subscriptionID/resourceGroups/$imageResourceGroup"


# Shared Image Gallery properties
$sigGalleryName= "WVDSIG"
$imageDefName ="WVD-Img-Definitions"
 
# create SIG
New-AzGallery -GalleryName $sigGalleryName -ResourceGroupName $imageResourceGroup -Location $location
 
# create gallery definition
$GalleryParams = @{
  GalleryName = $sigGalleryName
  ResourceGroupName = $imageResourceGroup
  Location = $location
  Name = $imageDefName
  OsState = 'generalized'
  OsType = 'Windows'
  Publisher = 'Contoso'
  Offer = 'Windows'
  Sku = 'Win10WVD'
}
New-AzGalleryImageDefinition @GalleryParams

# assign permissions for the resource group, so that AIB can distribute the image to it
New-AzRoleAssignment -ApplicationId cf32a0cc-373c-47c9-9156-0db11f6a6dfc -Scope /subscriptions/$subscriptionID/resourceGroups/$imageResourceGroup -RoleDefinitionName Contributor

$SrcObjParams = @{
    SourceTypePlatformImage = $true
    Publisher = 'MicrosoftWindowsDesktop'
    Offer = 'Windows-10'
    Sku = '20h2-evd'
    Version = 'latest'
  }
  $srcPlatform = New-AzImageBuilderSourceObject @SrcObjParams

  $disObjParams = @{
    SharedImageDistributor = $true
    GalleryImageId = "/subscriptions/$subscriptionID/resourceGroups/$imageResourceGroup/providers/Microsoft.Compute/galleries/$sigGalleryName/images/$imageDefName"
    ArtifactTag = @{tag='dis-share'}
   
    # 1. Uncomment following line for a single region deployment.
    ReplicationRegion = $location
   
    # 2. Uncomment following line if the custom image should be replicated to another region.
    #ReplicationRegion = $location,'EastUS'
   
    RunOutputName = "winclientR01"
    ExcludeFromLatest = $false
  }
  $disSharedImg = New-AzImageBuilderDistributorObject @disObjParams

  $ImgCustomParams = @{
    PowerShellCustomizer = $true
    CustomizerName = 'InstallFSlogixAgent'
    RunElevated = $true
    Inline = @("Invoke-WebRequest -Uri 'https://aka.ms/fslogix_download' -OutFile 'c:\windows\temp\fslogix.zip'", "Start-Sleep -Seconds 10", "Expand-Archive -Path 'C:\windows\temp\fslogix.zip' -DestinationPath 'C:\windows\temp\fslogix\' -Force", "Invoke-Expression -Command 'C:\windows\temp\fslogix\x64\Release\FSLogixAppsSetup.exe /install /quiet /norestart'")
  }
  $Customizer = New-AzImageBuilderCustomizerObject @ImgCustomParams


  Get-AzImageBuilderTemplate -ImageTemplateName $imageTemplateName -ResourceGroupName $imageResourceGroup | Select-Object -Property Name, LastRunStatusRunState, LastRunStatusMessage, ProvisioningState


  Start-AzImageBuilderTemplate -ResourceGroupName $imageResourceGroup -Name $imageTemplateName
