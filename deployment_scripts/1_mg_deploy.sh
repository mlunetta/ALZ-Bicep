#!/bin/bash

dateYMD=$(date +%Y%m%dT%H%M%S%NZ)
NAME="alz-MGDeployment-${dateYMD}"
LOCATION="westeurope"
TEMPLATEFILE="infra-as-code/bicep/modules/managementGroups/managementGroups.bicep"
PARAMETERS="@infra-as-code/bicep/modules/managementGroups/parameters/managementGroups.parameters.all.json"

az deployment tenant create --name ${NAME:0:63} --location $LOCATION --template-file $TEMPLATEFILE --parameters $PARAMETERS