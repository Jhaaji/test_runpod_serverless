#!/bin/bash
set -e

echo "[INFO] Starting entrypoint script..."

# Validate token
if [ -z "$HF_TOKEN" ]; then
  echo "[ERROR] Environment variable HF_TOKEN is not set. Exiting."
  exit 1
fi

# Download models at runtime
echo "[INFO] Downloading models using HF_TOKEN..."

mkdir -p /app/ComfyUI/models/clip /app/ComfyUI/models/vae /app/ComfyUI/models/unet

wget https://huggingface.co/Comfy-Org/stable-diffusion-3.5-fp8/resolve/main/text_encoders/clip_l.safetensors \
  -O /app/ComfyUI/models/clip/clip_l.safetensors

wget https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp16.safetensors \
  -O /app/ComfyUI/models/clip/t5xxl_fp16.safetensors

wget --header="Authorization: Bearer $HF_TOKEN" \
  https://huggingface.co/black-forest-labs/FLUX.1-schnell/resolve/main/ae.safetensors \
  -O /app/ComfyUI/models/vae/ae.safetensors

wget --header="Authorization: Bearer $HF_TOKEN" \
  https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/flux1-dev.safetensors \
  -O /app/ComfyUI/models/unet/flux1-dev.safetensors

# Finally run the app
echo "[INFO] Running the app..."
exec python3 handler.py
