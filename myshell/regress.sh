#! /bin/bash
mkdir $1
cp /opt/remote/task/ww05/regression/intel-linux-media_sles_16.4.1-$1_64bit.tar.gz $1
cd $1
tar -xvf *.tar.gz
sudo cp opt/intel/mediasdk/lib64/iHD_drv_video.so /opt/intel/mediasdk/lib64/iHD_drv_video.so