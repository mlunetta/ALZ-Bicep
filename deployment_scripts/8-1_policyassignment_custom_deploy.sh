# For Azure global regions

dateYMD=$(date +%Y%m%dT%H%M%S%NZ)
NAME="customMarc-customMarcPolicyAssignmentCustom-${dateYMD}"
LOCATION="westeurope"
MGID="bicepbeta"
TEMPLATEFILE="infra-as-code/bicep/modules/policy/assignments/customMarc/customMarcPolicyAssignments.bicep"
PARAMETERS="@infra-as-code/bicep/modules/policy/assignments/customMarc/parameters/customMarcPolicyAssignments.parameters.all.json"

az deployment mg create --name ${NAME:0:63} --location $LOCATION --management-group-id $MGID --template-file $TEMPLATEFILE --parameters $PARAMETERS