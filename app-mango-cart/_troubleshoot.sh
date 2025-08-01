# POD TESTS - CMDLINE
kubectl exec -it dep-cart-7c9f759c99-v2klp -n ns-mango -- /bin/sh
apk update && apk add curl && curl ifconfig.me
printenv | sort | grep ^RDZ
cat /mnt/secrets-store/kvTestSecret1

# POD TESTS - WEBSITE
k port-forward pod/dep-cart-7c9f759c99-v2klp 8081:8080 -n ns-mango # Browse to http://localhost:8081

# SERVICE TESTS
k port-forward service/svc-cart 8081:80 -n ns-mango # Browse to http://localhost:8081
