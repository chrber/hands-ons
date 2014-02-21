for index in `seq 1 100`;
do
dd if=/dev/urandom of=/nfs4/bigFile bs=1M count=2
echo Createing file: ;
done
