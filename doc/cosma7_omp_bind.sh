#!/bin/bash
numanode=` expr $PMI_RANK % 2 `
basecore=`expr $numanode \* 14`
core0=`expr $basecore + 0 `
core1=`expr $basecore + 13 `
export GOMP_CPU_AFFINITY="$core0-$core1"
echo GOMP_CUP_AFFINITY:$PMI_RANK $GOMP_CPU_AFFINITY
$@
