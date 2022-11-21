# For Azure Global regions
# Set Platform management subscripion ID as the the current subscription
ManagementSubscriptionId="ded0b858-c4c1-4116-b304-fe3dcb8a6f5f"
az account set --subscription $ManagementSubscriptionId

LOCATION="westeurope"
dateYMD=$(date +%Y%m%dT%H%M%S%NZ)
GROUP="rg-shmgmt-centralized-001"
NAME="alz-loggingDeployment-${dateYMD}"
TEMPLATEFILE="infra-as-code/bicep/modules/logging/logging.bicep"
PARAMETERS="@infra-as-code/bicep/modules/logging/parameters/logging.parameters.all.json"

# Create Resource Group - optional when using an existing resource group
az group create \
  --name $GROUP \
  --location $LOCATION

# Deploy Module
az deployment group create --name ${NAME:0:63} --resource-group $GROUP --template-file $TEMPLATEFILE --parameters $PARAMETERS