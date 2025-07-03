FROM python:3.10-slim
WORKDIR /app

RUN apt-get update && \
    apt-get install -y git ffmpeg libgl1 unzip wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/comfyanonymous/ComfyUI.git
WORKDIR /app/ComfyUI
RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /app/ComfyUI/custom_nodes

RUN git clone https://github.com/rgthree/rgthree-comfy.git
RUN git clone https://github.com/florestefano1975/comfyui-portrait-master.git
RUN git clone https://github.com/chrisgoringe/cg-use-everywhere.git
RUN git clone https://github.com/dagthomas/comfyui_dagthomas.git
RUN git clone https://github.com/syllebra/bilbox-comfyui.git
RUN git clone https://github.com/kijai/ComfyUI-KJNodes.git
RUN git clone https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes.git

WORKDIR /app/ComfyUI/custom_nodes/comfyui_dagthomas
RUN pip install --no-cache-dir -r requirements.txt && \
    pip install "huggingface-hub>=0.26.0,<1.0"

WORKDIR /app/ComfyUI

# Create model directories
RUN mkdir -p models/clip models/vae

WORKDIR /app/ComfyUI/models/clip
RUN wget https://huggingface.co/Comfy-Org/stable-diffusion-3.5-fp8/resolve/main/text_encoders/clip_l.safetensors && \
    wget https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp16.safetensors

WORKDIR /app/ComfyUI/models/vae
RUN wget https://huggingface.co/lovis93/testllm/resolve/ed9cf1af7465cebca4649157f118e331cf2a084f/ae.safetensors

WORKDIR /app

COPY comfyui_workflow.json comfyui_workflow.json
COPY requirements.txt requirements.txt
COPY handler.py handler.py

RUN pip install --no-cache-dir -r requirements.txt

CMD ["python3", "handler.py"]
