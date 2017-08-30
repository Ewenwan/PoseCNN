#!/bin/bash

set -x
set -e

export PYTHONUNBUFFERED="True"
export CUDA_VISIBLE_DEVICES=$1

LOG="experiments/logs/linemod_eggbox_test.txt.`date +'%Y-%m-%d_%H-%M-%S'`"
exec &> >(tee -a "$LOG")
echo Logging output to "$LOG"

# test for semantic labeling
time ./tools/test_net.py --gpu 0 \
  --network vgg16_convs \
  --model output/linemod/linemod_eggbox_train/vgg16_fcn_color_single_frame_linemod_eggbox_iter_40000.ckpt \
  --imdb linemod_eggbox_test \
  --cfg experiments/cfgs/linemod_eggbox.yml \
  --cad data/LINEMOD/models.txt \
  --pose data/LINEMOD/poses.txt \
  --background data/cache/backgrounds.pkl

# test for pose regression
time ./tools/test_net.py --gpu 0 \
  --network vgg16_convs \
  --model output/linemod/linemod_eggbox_train/vgg16_fcn_color_single_frame_pose_linemod_eggbox_iter_40000.ckpt \
  --imdb linemod_eggbox_test \
  --cfg experiments/cfgs/linemod_eggbox_pose.yml \
  --cad data/LINEMOD/models.txt \
  --pose data/LINEMOD/poses.txt \
  --background data/cache/backgrounds.pkl