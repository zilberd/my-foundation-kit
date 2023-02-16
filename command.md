# connect test tenant
````
connect-AzAccount -tenantId 8e898b91-9590-4c30-9d66-c7aefa229c04 -Subscription 2bd351ba-6fe3-48ea-84a4-acaa8d98c306
az login --tenant 8e898b91-9590-4c30-9d66-c7aefa229c04
````

# initialisation
````
git init my-foundation-kit 
cd .\my-foundation-kit\     
collie foundation new my-foundation-dev
````

# first module
````
collie kit new "lz-az-module"
collie kit apply "lz-az-module" --foundation my-foundation-dev --platform msdnpoc
````


collie kit tree 
collie foundation docs my-foundation-dev
collie compliance tree

 collie kit new bootstrap


https://www.meshcloud.io/de/blog/mastering-landing-zones-in-azure/



