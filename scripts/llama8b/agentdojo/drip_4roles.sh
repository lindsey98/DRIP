#!/bin/bash
# 4-role (tool-calling / AgentDojo) DRIP training launcher.
#
# Differs from the 3-role text training (scripts/llama8b/sep/drip_sep.sh) in two
# ways: it trains on the Alpaca + InjecAgent combined DPO set, and it uses a
# 4-role delimiter (TextTextText-4roles). See testing/agentdojo/README.md for how
# that data is built and why InjecAgent/Alpaca are mixed in.

export OMP_NUM_THREADS=4
export MKL_NUM_THREADS=4
export NCCL_NTHREADS=8
export TOKENIZERS_PARALLELISM=false
export WANDB_MODE=disabled

# === NCCL hang protection ===
export TORCH_NCCL_BLOCKING_WAIT=1
export TORCH_NCCL_ASYNC_ERROR_HANDLING=1
export TORCH_NCCL_TIMEOUT_MS=1800000
export TORCH_NCCL_TRACE_BUFFER_SIZE=20480
export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True,max_split_size_mb:512
export CUDA_VISIBLE_DEVICES="${CUDA_VISIBLE_DEVICES:-0,1,2,3,4,5}"

SCRIPT_PATH="train_unified.py"
BASELINE="drip"
BASE_MODEL="meta-llama/Llama-3.1-8B-Instruct"
BASE_MODEL_NAME="meta-llama/Llama-3.1-8B-Instruct"
DATA_PATH="datasets/alpaca_injecagent_dpo_combined.json"
FILENAME=$(basename "$DATA_PATH")
PREFIX=${FILENAME%%_*}
FSDP_CONFIG="training/config/fsdp_config.json"
DELIMITER="TextTextText-4roles"        # <-- 4-role delimiter (3-role uses "TextTextText")
SAVE_PATH="${BASE_MODEL_NAME}-${DELIMITER}-alpaca-injecagent-${BASELINE}"

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
