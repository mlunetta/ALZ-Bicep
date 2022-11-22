# For Azure global regions

dateYMD=$(date +%Y%m%dT%H%M%S%NZ)
NAME="alz-HubPeeredSpoke-${dateYMD}"
LOCATION="westeurope"
MGID="bicepbeta"
TEMPLATEFILE="infra-as-code/bicep/orchestration/hubPeeredSpoke/hubPeeredSpoke.bicep"
PARAMETERS="@infra-as-code/bicep/orchestration/hubPeeredSpoke/parameters/hubPeeredSpoke.parameters.all.json"

az deployment mg create --name ${NAME:0:63} --location $LOCATION --management-group-id $MGID --template-file $TEMPLATEFILE --parameters $PARAMETERS