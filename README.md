# Demo: Generating a Software Bill of Materials with Syft

This is a very rough demo of using Syft with Jenkins to generate a software bill of materials.  If you don't know what Syft is, read up here: https://github.com/anchore/syft

## Part 1: Jenkins Setup 

We're going to run jenkins in a container to make this fairly self-contained and easily disposable.  This command will run jenkins and bind to the host's docker sock (if you don't know what that means, don't worry about it, it's not important).

`$ docker run -u root -d --name jenkins --rm -p 8080:8080 -p 50000:50000 -v /var/run/docker.sock:/var/run/docker.sock -v /tmp/jenkins-data:/var/jenkins_home jenkinsci/blueocean
`

Once Jenkins is up and running, we have just a few things to configure:
- Get the initial password (`$ docker logs jenkins`)
- log in on port 8080
- Unlock Jenkins using the password from the logs
- Select “Install Selected Plugins” and create an admin user

## Part 2: Get Syft
Syft has a simple install script, which you can execute inside the container:

`docker exec jenkins bash -c 'curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin'`

## Part 3: Start generating SBOMs

Time to get to work:

- Fork this repo (actually this isn't even really necessary, you can just use this repo directly)
- From the jenkins main page, select “New Item” 
- Name it “syft-sbom-demo”
- Choose “pipeline” and click “OK”
- On the configuration page, scroll down to “Pipeline”
- For “Definition,” select “Pipeline script from SCM”
- For “SCM,” select “git”
- For “Repository URL,” paste in the URL of your forked github repo
	e.g. https://github.com/pvnovarese/syft-sbom-demo (with your github user ID)
- Click “Save”
- You’ll now be at the top-level project page.  Click “Build Now”

Jenkins will check out the repo and build an image using the provided Dockerfile.  This image will be a simple copy of the alpine base image with curl added.  Once the image is built, Jenkins will call Syft, generate a SPDX SBOM in json format, and archive it.  Finally, the script cleans up by deleting the docker image and the resulting sbom from the workspace (this is a little extra, since we're using a disposable jenkins container).


## Part 4: Cleanup
- Kill the jenkins container (it will automatically be removed since we specified --rm when we created it):
	`pvn@gyarados /home/pvn> docker kill jenkins`
- Remove the jenkins-data directory from /tmp
	`pvn@gyarados /home/pvn> sudo rm -rf /tmp/jenkins-data/`
- Remove all demo images from your local machine (there shouldn't be any if our cleanup stage worked correctly, but just in case):
	`pvn@gyarados /home/pvn> docker image ls | grep "syft-sbom-demo" | awk '{print $3}' | xargs docker image rm -f`

