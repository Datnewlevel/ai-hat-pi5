Updating your parameters for the Hailo conversion process is an important step. While the default settings in this repo provide a good baseline, hardware constraints and specific model architectures require precise configuration to ensure your model runs both accurately and efficiently on the Hailo-8 processor.

The following three files control how your model is optimized, compiled, and post-processed.

---

## 1. `yolov8s_custom.alls` (Optimization Script)

This file dictates the trade-off between speed and accuracy during the quantization process.

* **Key Line:** `model_optimization_flavor(optimization_level=2, compression_level=1)`
* **What to know:** * `optimization_level`: Level 2 is the standard for YOLOv8. Increasing this can improve accuracy but significantly increases compilation time.
* `compression_level`: Determines how aggressively the weights are compressed. Level 1 is safe; higher levels may reduce model size but can introduce "noise" into your detections.
* **Recommendation:** Leave these as defaults unless you find your post-quantization accuracy is dropping significantly.



---

## 2. `yolov8s_custom.yaml` (Model Path Configuration)

This file acts as the "map" for the Hailo Dataflow Compiler.

* **Configuration Sections:** Do **not** modify the `parser`, `network`, or `postprocessing` sections. These contain the exact node names (e.g., `/model.22/cv2.0/...`) required to map your ONNX file to the Hailo hardware. If these names don't match your specific ONNX structure, the compilation will fail.
* **Metadata (`info`):** You can freely update the `info` section. Fields like `task`, `parameters`, and `source` are purely for documentation and do not affect the compiled model's performance.

---

## 3. `yolov8s_nms_config.json` (Post-Processing)

This is the most critical file for ensuring your model outputs correct bounding boxes.

### Fields you should update:

* **`"image_dims"`**: Must match the exact resolution used during training and calibration (e.g., `[640, 640]`).
* **`"classes"`**: Change this to the exact number of objects your model was trained to detect.
* **`"max_proposals_per_class"`**: This sets the hardware limit for how many candidate boxes the chip tracks per class before filtering. 100 is standard; increase this only if you expect extremely crowded scenes (e.g., a massive parking lot or stadium).
* **`"background_removal"`**: Usually set to `false`. If enabled, it attempts to filter out boxes that the model predicts as "background," which can save processing time but may skip valid detections.

### ⚠️ IMPORTANT: Do Not Change `regression_length`

The **`"regression_length"`** (typically set to `16` for YOLOv8) is tied to the **Distribution Focal Loss (DFL)** architecture used during training.

* This is not a "tuning" parameter; it is a mathematical constant for how the model calculates box boundaries.
* Changing this value will result in completely broken bounding boxes (either tiny dots or screen-filling rectangles).

---

**Next Steps:** Once these files are updated to match your training environment, you are ready to run the `hailo_model_zoo` compiler to generate your `.hef` file.