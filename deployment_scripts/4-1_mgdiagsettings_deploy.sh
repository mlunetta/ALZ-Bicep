# For Azure Global regions

# Management Group ID
MGID="bicepbeta"

MANAGEMENTSUBSCRIPTIOID=$(jq -r '.parameters.parLogAnalyticsWorkspaceResourceId.value' infra-as-code/bicep/orchestration/mgDiagSettingsAll/parameters/mgDiagSettingsAll.parameters.all.json | cut -d '/' -f3)
dateYMD=$(date +%Y%m%dT%H%M%S%NZ)
NAME="alz-MgDiagSettings-${dateYMD}"
LOCATION="westeurope"
TEMPLATEFILE="infra-as-code/bicep/orchestration/mgDiagSettingsAll/mgDiagSettingsAll.bicep"
PARAMETERS="@infra-as-code/bicep/orchestration/mgDiagSettingsAll/parameters/mgDiagSettingsAll.parameters.all.json"

# Enable microsoft.insights on the management subscription
pauseNeeded=0
az account set --subscription $MANAGEMENTSUBSCRIPTIOID
microsoftInsightsIsRegistered=$(az provider show -n Microsoft.Insights | jq -r '.registrationState')
if [ "$microsoftInsightsIsRegistered" != "Registered" ]
then
    az provider register -n Microsoft.Insights
    sleep 1m
fi

# Deployment
az deployment mg create --name ${NAME:0:63} --location $LOCATION --management-group-id $MGID --template-file $TEMPLATEFILE --parameters $PARAMETERS