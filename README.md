# Android-emulator API-25 with armeabi-v7a image

Forked from https://github.com/tracer0tong/android-emulator

Changes:
1. Specify 16.04 as base image
2. Include only API-25 SDK and its arm image.
3. Removed SSH Server

### Version
0.0.1

### Build
git clone https://github.com/dodoinblue/android-emulator
cd android-emulator
docker build .


### Pull & Run
Use Docker registry with *latest* tag:

```sh
$ docker pull netdodo/android-emulator:latest
$ docker run -d -P --name android netdodo/android-emulator
```

Now a container should be running in the background. Now restart adb-server to connect to the newly launched emulator.


### Use emulator
1. Find which port is using:
```shell
$ docker port android

# Output
5037/tcp -> 0.0.0.0:32784
5554/tcp -> 0.0.0.0:32783
5555/tcp -> 0.0.0.0:32782 #<-- use this port
```

2. Use the port linked with 5555 to start server.

```shell
adb kill-server
adb connect 172.17.0.2:32782
```
If this does not work, use try following:
```shell
adb connect 0.0.0.0:32782
$ adb kill-server
$ adb connect 0.0.0.0:32782
```

If works, you should get messages like these:
```shell
* daemon not running. starting it now on port 5037 *
* daemon started successfully *
connected to 0.0.0.0:32782
$ adb devices
List of devices attached
0.0.0.0:32782   device
```

3. Now you should be able to run test on this emulator
```shell
./gradlew connectedDebugAndroidTest
```

### Use build environment
1. Clone android app code to your host machine, say /User/test/test-app
2. Start container, mount volume and specify build command.
Example:
```shell
cd /User/test/test-app
docker run -P -v `pwd`:/workspace -n android bash -c "./gradlew assembleDebug"
```

### Issues
1. Use emulator and gradle build in same container is not stable. Emulator may be killed for some reason.
2. When you build, make sure your source code root does not contain a local.properties file.
