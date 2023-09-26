# Azure Cloud Framework - State Management


## Getting started with launchpad

Depending on what you are trying to achieve, we provide you with different levels of launchpads to cover different scenario:

| level                 | scenario                                                                                                         | supported environments                     |
|-----------------------|------------------------------------------------------------------------------------------------------------------|--------------------------------------------|
| [100](./scenario/100) | Start with this one! basic functionalities and features, no RBAC or security hardening - for demo and simple POC | working on AIRS subscriptions              |
| [200](./scenario/200) | intermediate functionalities includes diagnostics features                                                       | may not work in AIRS, need AAD permissions |

You can pick your scenario and use one of the following commands:

```bash
# Simple scenario for learning and demonstration
rover -lz /tf/caf/caf_launchpad \
    -launchpad \
    -var-folder /tf/caf/caf_launchpad/scenario/100 \
    -parallelism=30 \
    -a apply

# Advanced scenario - Requires Azure AD privileges
rover -lz /tf/caf/caf_launchpad \
    -launchpad \
    -var-folder /tf/caf/caf_launchpad/scenario/200 \
    -parallelism=30 \
    -a apply

# If the tfstates are stored in a different subscription you need to execute the following command
rover -lz /tf/caf/caf_launchpad \
    -tfstate_subscription_id <ID of the subscription> \
    -launchpad \
    -var-folder /tf/caf/caf_launchpad/scenario/200 \
    -parallelism=30 \
    -a apply
```

</BR>
