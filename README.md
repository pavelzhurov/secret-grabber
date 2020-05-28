# secret-grabber

This is the demo of a secrets grabber, which uses both [conjur-k8s-authenticator](https://github.com/cyberark/conjur-authn-k8s-client) and [summon](https://github.com/cyberark/summon) to transfer secrets into a legacy application through the volume (emptyDir).
This grabber works according to the following schema.

![schema](https://github.com/pavelzhurov/secret-grabber/blob/master/images/ConjurIntegration.png)

1. Authenticator requests access to secrets:
    1. Sends a CSR with SAN containing pod and namespace
    2. Conjur generates a certificate and adds it to the particular pod in a particular namespace (indicated in CSR's SAN)
    3. Openshift injects certificate in that pod
2. The authenticator uses the certificate to obtain a temporal token. Then, custom scripts with summon starts.
3. The script using summon and token, which was obtained by the authenticator, grabs secrets and then... 
4. ... put them into empty Dir
5. The application uses secrets from emptyDir

## Container settings
Environment variables:

- MY_POD_NAME
- MY_POD_NAMESPACE
- CONJUR_VERSION
- CONJUR_ACCOUNT
- CONJUR_AUTHN_URL - URL pointing to authenticator service endpoint
- CONJUR_SSL_CERTIFICATE
- CONJUR_APPLIANCE_URL
- CONJUR_AUTHN_TOKEN_FILE – empty dir token
- TIMEOUT – how often to grab secrets

Mount: summon YAML config should be mounted into path /config/secrets.yaml
