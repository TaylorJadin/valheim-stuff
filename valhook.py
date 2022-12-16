import subprocess
import json
import os.path
import requests

# This script requires gamedig to be installed: https://github.com/gamedig/node-gamedig#usage-from-command-line

### config ###
webhook_url = "https://discord.com/api/webhooks/..."
gamedig_cmd = "gamedig --type valheim server.address:2457"
lastcount_file = "/home/username/valhook/count.txt"
announcement = "Number of players connected: "

# send_webhook function
def send_webhook(url, message):
    data = {
        "content" : message
    }
    result = requests.post(url, json = data)
    try:
        result.raise_for_status()
    except requests.exceptions.HTTPError as err:
        print(err)
    else:
        print("Payload delivered successfully, code {}.".format(result.status_code))

# Read in the file
fileexists = os.path.isfile(lastcount_file)
if fileexists:
    r = open(lastcount_file)
    lastcount = int(r.read())
    r.close()
else:
    lastcount = None

# Run the Gamedig command, store the output, parse the json
raw = subprocess.check_output(gamedig_cmd, shell=True)
result = json.loads(raw)
# Grab just the player count
newcount = int(result["raw"]["numplayers"])

# Debug
# json_formatted_str = json.dumps(newcount, indent=4)
# print(json_formatted_str)
print("Last Count:", lastcount)
print("New Count:", newcount)
print("")

if lastcount != newcount:
    print("Last count is NOT the same as the new count. Sending message:")
    message_content = announcement + str(newcount)
    print("-------------------------------------------------------------")
    print(message_content)
    print("-------------------------------------------------------------")
    send_webhook(webhook_url, message_content)
else:
    print("Last count is the same as the new count. Exiting.")

# Save count for next run
f = open(lastcount_file, "w")
f.write(str(newcount))
f.close()
