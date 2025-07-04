FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Install required packages
RUN apt-get update && \
    apt-get install -y git ffmpeg libgl1 unzip wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Clone ComfyUI repo
RUN git clone https://github.com/comfyanonymous/ComfyUI.git
WORKDIR /app/ComfyUI
RUN pip install --no-cache-dir -r requirements.txt

# Clone custom nodes
WORKDIR /app/ComfyUI/custom_nodes
RUN git clone https://github.com/rgthree/rgthree-comfy.git && \
    git clone https://github.com/florestefano1975/comfyui-portrait-master.git && \
    git clone https://github.com/chrisgoringe/cg-use-everywhere.git && \
    git clone https://github.com/dagthomas/comfyui_dagthomas.git && \
    git clone https://github.com/syllebra/bilbox-comfyui.git && \
    git clone https://github.com/kijai/ComfyUI-KJNodes.git && \
    git clone https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes.git

# Install requirements for a specific node
WORKDIR /app/ComfyUI/custom_nodes/comfyui_dagthomas
RUN pip install --no-cache-dir -r requirements.txt && \
    pip install "huggingface-hub>=0.26.0,<1.0"

# Go back to root project
WORKDIR /app/ComfyUI

# Copy project files
COPY comfyui_workflow.json comfyui_workflow.json
COPY requirements.txt requirements.txt
COPY handler.py handler.py
COPY entrypoint.sh /entrypoint.sh

# Install any extra Python dependencies
RUN pip install --no-cache-dir -r /app/ComfyUI/requirements.txt
RUN chmod +x /entrypoint.sh

# Use entrypoint to download models at runtime
ENTRYPOINT ["/entrypoint.sh"]
