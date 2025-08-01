################
# CERT-MANAGER #
################

# ----------- #
# SELF-SIGNED #
# ----------- #

# 1-namespace.yaml
This namespace is used to hold the shared gateway for the rhod3rz.com domain.
The gateway is created here so its application agnostic and can serve multiple applications within the same cluster
e.g. mango and titan.

# 2-cluster-issuer-ss.yaml
NOTE: Self-signed certs MUST be created for any https listener in gateway.yaml, before the valid cert is available.
This is because if no valid cert exists when the 'gateway' is deployed, it will provision with errors and prevent the acme pod from working.
This allows the 'gateway' to deploy succesfully and the acme pod do its thing to pull down a proper cert, which overwrites the self-signed ones.
---
kubectl get clusterissuer      # Check if the clusterissuer has been created and ready status is true.
kubectl describe clusterissuer # Check if the clusterissuer has any error events logged.
---
kubectl get certificate -n ns-rhod3rz-com
kubectl describe certificate cert-mango-cart -n ns-rhod3rz-com
kubectl get challenges -n ns-rhod3rz-com -o yaml # If the certificate has been successfully issued, the challenge will no longer be listed.
kubectl get secret secret-mango-cart -n ns-rhod3rz-com # DATA = 3 means it contains both tls.crt, tls.key & ca.crt | this is specific to self-signed certs.
kubectl get secret secret-mango-cart -n ns-rhod3rz-com -o yaml
# use this to read the certificate and confirm who the issuer is | Issuer: Blank = self signed!
$cert=[System.Convert]::FromBase64String((kubectl get secret secret-mango-cart -n ns-rhod3rz-com -o jsonpath="{.data.tls\.crt}")); $path="$env:TEMP\tls-cert.pem"; [System.IO.File]::WriteAllBytes($path, $cert); & openssl x509 -text -noout -in $path; Remove-Item $path -Force
---

# 3-gateway.yaml
---
kubectl get gateway -n ns-rhod3rz-com gw-rhod3rz-com -o yaml  # Check listeners for 80 & 443; ignore secret error until certificate.yaml is run.
# check this gets created ...
# NAMESPACE        NAME                                               CLASS                ADDRESS                               PROGRAMMED   AGE
# ns-rhod3rz-com   gateway.gateway.networking.k8s.io/gw-rhod3rz-com   azure-alb-external   dbgkg8dshpgqdqaa.fz82.alb.azure.com   True         79s

# ---- #
# ACME #
# ---- #

# 4-cluster-issuer-acme.yaml
# these acme-http-solvers briefly pop up as part of the certificate creation; then disappear once complete!
# NAMESPACE        NAME                           READY  STATUS   RESTARTS  AGE
# ns-rhod3rz-com   pod/cm-acme-http-solver-9p2s5  1/1    Running  0         12s
# ns-rhod3rz-com   pod/cm-acme-http-solver-bqh4r  1/1    Running  0         12s
# NAMESPACE        NAME                                                            HOSTNAMES                               AGE
# ns-rhod3rz-com   httproute.gateway.networking.k8s.io/cm-acme-http-solver-d2fhl   ["agfc.prd.blu.mango.cart.rhod3rz.com"]     5s
# ns-rhod3rz-com   httproute.gateway.networking.k8s.io/cm-acme-http-solver-gsm2g   ["agfc.prd.blu.mango.catalog.rhod3rz.com"]  5s
---
kubectl get clusterissuer                           # Check if the clusterissuer has been created and ready status is true.
kubectl describe clusterissuer                      # Check if the clusterissuer has any error events logged.
kubectl get secret pksr-letsencrypt -n cert-manager # Verify pksr exists.
---
kubectl get certificate -n ns-rhod3rz-com
kubectl describe certificate cert-mango-cart -n ns-rhod3rz-com
kubectl get challenges -n ns-rhod3rz-com -o yaml # If the certificate has been successfully issued, the challenge will no longer be listed.
kubectl get secret secret-mango-cart -n ns-rhod3rz-com # DATA = 2 means it contains both tls.crt and tls.key.
kubectl get secret secret-mango-cart -n ns-rhod3rz-com -o yaml
# use this to read the certificate and confirm who the issuer is | Issuer: C=US, O=Let's Encrypt, CN=R10 = Bingo!
$cert=[System.Convert]::FromBase64String((kubectl get secret secret-mango-cart -n ns-rhod3rz-com -o jsonpath="{.data.tls\.crt}")); $path="$env:TEMP\tls-cert.pem"; [System.IO.File]::WriteAllBytes($path, $cert); & openssl x509 -text -noout -in $path; Remove-Item $path -Force
---
