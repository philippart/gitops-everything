# Setup AWS Credentials
See [crossplane docs](https://crossplane.io/docs/v1.5/getting-started/install-configure.html)

Run this shell script to update your AWS credentials (aws-creds secret):
```
./update-aws-creds.sh
```

The following files will also be updated:
- creds.conf
- aws-creds.yaml

NB: the script assumes you AWS profile is 'myprofile'.
