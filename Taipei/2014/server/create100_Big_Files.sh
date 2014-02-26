for index in `seq 1 100`;
do
dd if=/dev/urandom of=/data/exp1/bigFiles/bigFile$index bs=1M count=2
echo Createing file: $index;
done
