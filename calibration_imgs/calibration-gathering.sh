#!/bin/bash
# Retrieve N identical images from each class based on label files.
DATASET_IMAGES="$1"    # đường dẫn tới train/images
DATASET_LABELS="$2"    # đường dẫn tới train/labels
OUTPUT_DIR="$3"        # thư mục output
N_PER_CLASS=${4:-16}   # mặc định 16 ảnh/class
NUM_CLASSES=${5:-4}    # số class

mkdir -p "$OUTPUT_DIR"

for class_id in $(seq 0 $((NUM_CLASSES-1))); do
    echo "Collecting class $class_id..."
    count=0
    for label_file in "$DATASET_LABELS"/*.txt; do
        if [ $count -ge $N_PER_CLASS ]; then break; fi
        if grep -q "^${class_id} " "$label_file"; then
            img_name=$(basename "${label_file%.txt}")
            img_file=$(find "$DATASET_IMAGES" -name "${img_name}.*" | head -1)
            if [ -n "$img_file" ]; then
                cp "$img_file" "$OUTPUT_DIR/"
                count=$((count+1))
            fi
        fi
    done
    echo "  → Got $count images for class $class_id"
done

total=$(ls "$OUTPUT_DIR" | wc -l)
echo "Total calibration images: $total"