sudo brctl addbr br0
sleep 1
sudo brctl addif br0 enp5s0
sleep 1
sudo ip link set br0 up
sudo dhclient
