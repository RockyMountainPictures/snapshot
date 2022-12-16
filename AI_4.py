from asyncore import write
import os, io, warnings, sys
from concurrent.futures import ThreadPoolExecutor

from PIL import Image
from stability_sdk import client
import stability_sdk.interfaces.gooseai.generation.generation_pb2 as generation

num = 4
file = open(sys.argv[1], "r")
session = sys.argv[2]
path = "E:\\Snapshot\\data\\sessions\\" + str(session) + "\\ai\\"
password = "sk-sUy7evKxVL7rZH7hFOgbHk4o9UVwFGIQccrL10LzDbqMs6ns"

def generate(message, num):
    # NB: host url is not prepended with \"https\" nor does it have a trailing slash.
    os.environ['STABILITY_HOST'] = 'grpc.stability.ai:443'
    print("Connected to API")
    # To get your API key, visit https://beta.dreamstudio.ai/membership
    os.environ['STABILITY_KEY'] = password

    print("Got API key")

    stability_api = client.StabilityInference(
    key=os.environ['STABILITY_KEY'], 
    verbose=True,
    )
    print("SENDING message to prompt")
    answers = stability_api.generate(
    prompt=message,
    steps=50, 
    sampler = generation.SAMPLER_K_EULER_ANCESTRAL,
    guidance_preset = generation.GUIDANCE_PRESET_SLOW,
    height = 512, 
    width = 512, 
    cfg_scale = 10.0, 
    )
    print("Sent message to prompt")
    for resp in answers:
        for artifact in resp.artifacts:
            if artifact.finish_reason == generation.FILTER:
                warnings.warn(
                    "Your request activated the API's safety filters and could not be processed."
                    "Please modify the prompt and try again.")
            if artifact.type == generation.ARTIFACT_IMAGE:
                img = Image.open(io.BytesIO(artifact.binary), "r")
                img.save(path + str(num-1) + ".png")

for line in file:
    generate(line, num)