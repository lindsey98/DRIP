#!/bin/bash

SCRIPT_PATH="train_unified.py"
BASELINE="drip"
BASE_MODEL="meta-llama/Llama-3.1-8B-Instruct"
BASE_MODEL_NAME="meta-llama/Llama-3.1-8B-Instruct"
DATA_PATH="datasets/alpaca_injecagent_dpo_combined.json"
FILENAME=$(basename "$DATA_PATH")
PREFIX=${FILENAME%%_*}
FSDP_CONFIG="training/config/fsdp_config.json"
DELIMITER="TextTextText-4roles"
SAVE_PATH="${BASE_MODEL_NAME}-${DELIMITER}-toolcall-${BASELINE}"

BATCH_SIZE=2
EPOCH=1

OBJECTIVE="dpo"
MODEL_FAMILY="llama"
ARCH="fuse"

python -m torch.distributed.run --nproc_per_node="${NPROC_PER_NODE:-6}" --master_port=29951 "$SCRIPT_PATH" \
  --objective "${OBJECTIVE}" \
  --model-family "${MODEL_FAMILY}" \
  --arch "${ARCH}" \
  --model_name_or_path "$BASE_MODEL" \
  --data_path "$DATA_PATH" \
  --output_dir "$SAVE_PATH" \
  --num_train_epochs "$EPOCH" \
  --bf16 True \
  --per_device_train_batch_size "$BATCH_SIZE" \
  --per_device_eval_batch_size 1 \
  --gradient_accumulation_steps 8 \
  --save_strategy "epoch" \
  --learning_rate 5e-5 \
  --weight_decay 0. \
  --warmup_ratio 0.03 \
  --lr_scheduler_type "cosine" \
  --logging_steps 1 \
  --tf32 True \
  --attack "${DELIMITER}_None" \
  --model_max_length 4096 \
  --dataloader_num_workers 1 \
  --fsdp "full_shard auto_wrap" \
  --fsdp_config "$FSDP_CONFIG"