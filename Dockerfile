# worker-comfyui + Comfy_HunyuanImage3 custom nodes for HunyuanImage 3.0 Instruct edits.
FROM runpod/worker-comfyui:5.8.6-base

# Install the Hunyuan Image 3 custom nodes into ComfyUI.
RUN cd /comfyui/custom_nodes \
 && git clone --depth 1 https://github.com/EricRollei/Comfy_HunyuanImage3.git

# Install the node's Python deps. Skip torch on purpose — the base image already
# ships the correct CUDA build; letting pip pull torch>=2.8 would clobber it.
RUN pip install --no-cache-dir \
      "transformers>=4.47.0" \
      "bitsandbytes>=0.48.2" \
      "accelerate>=1.2.1" \
      "safetensors>=0.4.5" \
      "huggingface_hub>=0.20.0" \
      "pillow>=11.0.0" \
      "numpy>=1.26.0" \
      "requests>=2.32.0" \
      "psutil>=5.9.0" \
      "diffusers>=0.31.0" \
      "einops>=0.8.0"

# Register the network volume's models dir under the Hunyuan folder categories so
# the loader finds the model at /runpod-volume/models/<model-name>/.
RUN printf '\ncomfyui_hunyuan:\n  base_path: /runpod-volume\n  hunyuan: models/\n  hunyuan_instruct: models/\n' >> /comfyui/extra_model_paths.yaml
