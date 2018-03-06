::##############################################################################
::
:: SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
::
:: © 2018 MICROSOFT PRESS
::
::##############################################################################
::
:: CHAPTER 5: PROVISIONING AZURE SQL DATABASE
:: COMMAND LINE SAMPLE
::
az sql db create --resource-group SSIO2017 --server ssio2017 --name Contoso --collation Latin1_General_CI_AS --edition Standard --service-objective S0 
az sql db show --resource-group SSIO2017 --server ssio2017 --name Contoso
