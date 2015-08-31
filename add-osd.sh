#!/bin/bash
echo "Name of storage storage server to add"
read stgsrv
echo "IP of ${stgsrv}"
read stgsrvaddr
echo "Number of OSDs to add to ${stgsrv}"
read osd
extosd=`ceph osd tree | sort -n | tail -1 | awk '{print $3;}' | cut -c5-6`
numosd=$(( $osd + $extosd ))
startosd=$(( $extosd + 1 ))
cat << EOF >> /etc/hosts
${stgsrvaddr}	${stgsrv}.ceph.cluster ${stgsrv}
EOF
echo "++++++++++++++++++++++++++++++++++++++++"
echo ""
echo "Existing OSDs: ${extosd}"
echo ""
echo "New OSDs: ${osd}"
echo ""
echo "Total OSDs after addition: ${numosd}"
echo ""
echo "++++++++++++++++++++++++++++++++++++++++"
ceph-deploy install $stgsrv
ceph-deploy admin $stgsrv
for i in `seq $startosd $numosd`; 
	do
		ssh ${stgsrv} mkdir -p /var/local/osd$i;
done
for i in `seq $startosd $numosd`;
	do
		ceph-deploy osd prepare ${stgsrv}:/var/local/osd$i;
done
for i in `seq $startosd $numosd`;
	do
		ceph-deploy osd activate ${stgsrv}:/var/local/osd$i;
done
