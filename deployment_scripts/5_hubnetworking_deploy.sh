# For Azure global regions

# Set Platform connectivity subscription ID as the the current subscription
ConnectivitySubscriptionId="23447211-05cf-4a0e-bdb4-e37ebf4e3b88"

az account set --subscription $ConnectivitySubscriptionId

# Set the top level MG Prefix in accordance to your environment. This example assumes default 'alz'.
TopLevelMGPrefix="bicepbeta"


LOCATION="westeurope"
dateYMD=$(date +%Y%m%dT%H%M%S%NZ)
NAME="alz-HubNetworkingDeploy-${dateYMD}"
GROUP="rg-hubnetworking-centralized-001"
TEMPLATEFILE="infra-as-code/bicep/modules/hubNetworking/hubNetworking.bicep"
PARAMETERS="@infra-as-code/bicep/modules/hubNetworking/parameters/hubNetworking.parameters.all.json"

az group create --location $LOCATION --name $GROUP

az deployment group create --name ${NAME:0:63} --resource-group $GROUP --template-file $TEMPLATEFILE --parameters $PARAMETERS