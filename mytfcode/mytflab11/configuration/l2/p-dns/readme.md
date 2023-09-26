
## Deployment

Deploy the management services


```bash
rover \
  -lz /tf/caf/framework/component/landingzone/ \
  -var-folder /tf/caf/framework/configuration/l2/p-dns/ \
  -tfstate_subscription_id 6bf8037f-4ed7-4adf-b1a3-e09efbcc2b3c \
  -target_subscription 58074758-c68b-473b-aea0-0346566fbc27 \
  -tfstate dns.tfstate \
  -env power \
  -level level2 \
  -w tfstate \
  -p ${TF_DATA_DIR}/dns.tfstate.tfplan \
  -a plan
```