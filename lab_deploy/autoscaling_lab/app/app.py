from flask import Flask, render_template
from ec2_metadata import ec2_metadata
import logging

logging.basicConfig(filename='/home/ec2-user/site/events.log', level=logging.INFO)
app = Flask(__name__)

@app.route("/")
def hello():
    instance_type = ec2_metadata.instance_type
    instance_family = instance_type.split(".")[0]
    instance_id = ec2_metadata.instance_id
    availability_zone = ec2_metadata.availability_zone
    meta = {
        'instance_id': instance_id,
        'instance_type': instance_type,
        'instance_family': instance_family,
        'availability_zone': availability_zone
    }
    logging.info(f"Instance Family is {instance_family}")
    logging.info(f"Instance Type is {instance_type}")
    logging.info(f"Instance Id is {instance_id}")
    logging.info(f"Availability Zone is {availability_zone}")

    return render_template("index.html", meta=meta)


# run the app.
if __name__ == "__main__":
    app.debug = True
    app.run(host="0.0.0.0")