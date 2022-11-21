# For Azure global regions

# Management Group ID
MGID="bicepbeta"

dateYMD=$(date +%Y%m%dT%H%M%S%NZ)
NAME="alz-CustomRoleDefsDeployment-${dateYMD}"
LOCATION="westeurope"
TEMPLATEFILE="infra-as-code/bicep/modules/customRoleDefinitions/customRoleDefinitions.bicep"
PARAMETERS="@infra-as-code/bicep/modules/customRoleDefinitions/parameters/customRoleDefinitions.parameters.all.json"

az deployment mg create --name ${NAME:0:63} --location $LOCATION --management-group-id $MGID --template-file $TEMPLATEFILE --parameters $PARAMETERS