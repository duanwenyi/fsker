#stop -create -condition {#%d count = 100 }
#run
database -open waves -into waves.shm -default
probe -create -shm -all -variable -depth all
run
#exit
