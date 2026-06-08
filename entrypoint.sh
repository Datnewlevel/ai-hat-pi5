#!/bin/bash

hailomz compile --ckpt best.onnx --hw-arch hailo8l --calib-path calibration_imgs/ --yaml yolov8s_custom.yaml --model-script yolov8s_custom.alls --classes 5

mkdir -p /workspace/results

# Move everything that ISN'T one of your original source files
# We use an extended glob to ignore your specific protected files
shopt -s extglob
mv *.log *.har *.hef *._tmp.json /workspace/results/ 2>/dev/null
echo "Compilation finished. Generated files moved to /onnx-to-hef-yolov8/results"

#add y/n prompt to benchmark model and write to /results ?