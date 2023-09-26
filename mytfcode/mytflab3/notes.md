{
  "appId": "bda97ae1-bbe4-4a1c-b7d3-989cf366ef76",
  "displayName": "azure-cli-2023-05-17-19-22-15",
  "password": "uA_8Q~cayeqjt71mrcKfMZ8X0XsyFnANCIRL~dbv",
  "tenant": "67481c72-d897-4db4-a7fa-b96d76dfb545"
}

az login --service-principal -u bda97ae1-bbe4-4a1c-b7d3-989cf366ef76 -p uA_8Q~cayeqjt71mrcKfMZ8X0XsyFnANCIRL~dbv --tenant 67481c72-d897-4db4-a7fa-b96d76dfb545

$env:ARM_CLIENT_ID = "bda97ae1-bbe4-4a1c-b7d3-989cf366ef76"
$env:ARM_CLIENT_SECRET = "uA_8Q~cayeqjt71mrcKfMZ8X0XsyFnANCIRL~dbv"
$env:ARM_TENANT_ID = "67481c72-d897-4db4-a7fa-b96d76dfb545"
$env:ARM_SUBSCRIPTION_ID = "4cce77b1-65bc-4255-9570-07178450d61f"

