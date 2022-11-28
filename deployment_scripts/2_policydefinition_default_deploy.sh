#!/bin/bash

# Management Group ID
MGID="bicepbeta"

dateYMD=$(date +%Y%m%dT%H%M%S%NZ)
NAME="alz-PolicyDefsDefaults-${dateYMD}"
LOCATION="westeurope"
TEMPLATEFILE="infra-as-code/bicep/modules/policy/definitions/alzDefaults/customPolicyDefinitions.bicep"
PARAMETERS="@infra-as-code/bicep/modules/policy/definitions/parameters/customPolicyDefinitions.parameters.all.json"

az deployment mg create --name ${NAME:0:63} --location $LOCATION --management-group-id $MGID --template-file $TEMPLATEFILE --parameters $PARAMETERS